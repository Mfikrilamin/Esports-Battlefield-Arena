import 'package:country_picker/country_picker.dart';
import 'package:esports_battlefield_arena/app/app.dart';
import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/invoice.dart';
import 'package:esports_battlefield_arena/models/username.dart';
import 'package:esports_battlefield_arena/models/nickname.dart';
import 'package:esports_battlefield_arena/models/player.dart';
import 'package:esports_battlefield_arena/models/team.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/models/tournament_participant.dart';
import 'package:esports_battlefield_arena/models/user.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/auth.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/game_database/apex_legend/apex_legend.dart';
import 'package:esports_battlefield_arena/services/game_database/valorant/valorant.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/services/payment/stripe.dart';
import 'package:esports_battlefield_arena/utils/date.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:esports_battlefield_arena/utils/regex_validation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stacked/stacked.dart';

class TournamentRegistrationViewModel extends FutureViewModel<void> {
  final AppRouter _router = locator<AppRouter>();
  final _log = locator<LogService>();
  final Database _database = locator<Database>();
  final Auth _auth = locator<Auth>();
  final Payment _stripePaymentService = locator<Payment>();
  final ValorantDatabase _valorantDatabase = locator<ValorantDatabase>();
  final ApexLegendDatabase _apexlegendDatabase = locator<ApexLegendDatabase>();

  //permanent variable
  final List<String> platformList =
      ApexLegendPlatform.values.map((e) => e.name).toList();

  //Email Controller
  List<String> _emailController = [];
  List<bool> _isEmailValid = [];
  List<bool> _isEmailAlreadyRegisted = [];
  List<bool> _isUsernameValid = [];
  List<User> _userListState = [];

  //Verification purposes
  List<String> _usernameList = [];
  List<String> _usernameId = [];
  List<String> _tagline = [];
  List<int> _selectedPlatformIndex = [];

  //state
  String _teamName = '';
  String _teamCountry = '';

  //getter
  String get getTeamName => _teamName;
  get getTeamCountry => _teamCountry;
  List<User> get getUserList => _userListState;
  List<String> get getEmailController => _emailController;
  List<bool> get getIsEmailValid => _isEmailValid;
  List<bool> get getIsEmailAlreadyRegisted => _isEmailAlreadyRegisted;
  List<bool> get getIsUsernameValid => _isUsernameValid;
  List<int> get getSelectedPlatformIndex => _selectedPlatformIndex;

  void updateTeamName(String teamName) {
    _teamName = teamName;
  }

  void updateTeamCountry(String countryName, String countryCode) {
    _teamCountry = countryName;
  }

  void updateSelectedPlatformIndex(int? value, int index) {
    if (value == null) return;
    _selectedPlatformIndex[index] = value;
    _log.debug(
        'selected platform:${platformList[_selectedPlatformIndex[index]]}');
    notifyListeners();
  }

  Future<void> updatePlayerEmail(String email, int index) async {
    _emailController[index] = email;
    _isEmailValid[index] = RegexValidation.validateEmail(email);
    if (_isEmailValid[index]) {
      _isEmailAlreadyRegisted[index] = await checkPlayerExistByEmail(email);
    }
    notifyListeners();
    _log.debug('index $index: ${_emailController[index]}');
  }

  Future<bool> checkPlayerExistByEmail(String email) async {
    try {
      _log.debug(email);
      Map<String, dynamic>? userData = await _database.getByQuery(
          ['email', 'role'],
          [email, UserRole.player.name],
          FirestoreCollections.users);
      _log.debug(userData.toString());
      if (userData == null) {
        return false;
      } else {
        _userListState.add(User.fromJson(userData));
        return true;
      }
    } on Failure catch (e) {
      _log.debug(e.toString());
      return false;
    }
  }

  bool checkIfAllUsernameIsVerified() {
    for (int i = 0; i < _userListState.length; i++) {
      if (_isUsernameValid[i] == false) {
        return false;
      }
    }
    return true;
  }

  registerTournament(String tournamentId, context, int totalEmailCount,
      {bool isSolo = false}) async {
    try {
      if (_userListState.length != totalEmailCount ||
          _teamName.isEmpty ||
          _teamCountry.isEmpty) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Colors.red,
                    ),
                    Text("Please fill in all input"),
                  ],
                ),
              ],
            ),
          ),
        );
        return;
      } else if (!checkIfAllUsernameIsVerified()) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Colors.red,
                    ),
                    Text("Please verify username"),
                  ],
                ),
              ],
            ),
          ),
        );
        return;
      }
      setBusy(true);
      Tournament tournament = Tournament.fromJson(
          await _database.get(tournamentId, FirestoreCollections.tournament));

      bool userIsAlreadyRegister =
          await validateIfInputUserRegister(tournamentId);

      if (tournament.currentParticipant.length <= tournament.maxParticipants &&
          !userIsAlreadyRegister) {
        //create a memberList object that contains this format
        List<Username> userNameListObject = [];
        for (int i = 0; i < _userListState.length; i++) {
          userNameListObject.add(Username(
            userId: _userListState[i].userId,
            username: _usernameList[i],
            usernameId: _usernameId[i],
          ));
        }

        TournamentParticipant participant = TournamentParticipant(
            participantId: '',
            dateRegister: DateHelper.formatDate(DateTime.now()),
            country: _teamCountry,
            teamName: _teamName,
            memberList: _userListState.map((e) => e.userId).toList(),
            usernameList: userNameListObject.map((e) => e.toJson()).toList(),
            tournamentId: tournament.tournamentId,
            seeding: 0,
            isSolo: isSolo,
            hasPay: false);

        String? participantId = await _database.add(
            participant.toJson(), FirestoreCollections.tournamentParticipant);

        if (participantId != null) {
          participant = TournamentParticipant(
            participantId: participantId,
            dateRegister: DateHelper.formatDate(DateTime.now()),
            country: _teamCountry,
            teamName: _teamName,
            memberList: _userListState.map((e) => e.userId).toList(),
            usernameList: userNameListObject.map((e) => e.toJson()).toList(),
            tournamentId: tournament.tournamentId,
            seeding: 0,
            isSolo: isSolo,
            hasPay: false,
          );
        }

        bool hasPay =
            await makePayment(tournament.entryFee, participant, context);
        if (hasPay) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      Text("Register Successfull"),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        // _router.pop
        _router.popUntilRouteWithName(HomeRoute.name);
      } else if (tournament.currentParticipant.length >=
          tournament.maxParticipants) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Colors.red,
                    ),
                    Text("Tournament is full"),
                  ],
                ),
              ],
            ),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Colors.red,
                    ),
                    Text("You already registered"),
                  ],
                ),
              ],
            ),
          ),
        );
      }
      setBusy(false);
    } on Failure catch (e) {
      _log.debug(e.toString());
    }
  }

  Future<bool> validateIfInputUserRegister(String tournamentId) async {
    //get all tournament participant with the tournament id
    List<Map<String, dynamic>> tournamentParticipantData =
        await _database.getAllByQuery(
      ['tournamentId'],
      [tournamentId],
      FirestoreCollections.tournamentParticipant,
    );

    // loop for each participant to check if the participant already registered
    for (int i = 0; i < tournamentParticipantData.length; i++) {
      for (int j = 0; j < _userListState.length; j++) {
        if (tournamentParticipantData[i]['memberList']
            .contains(_userListState[j].userId)) {
          return true;
        }
      }
    }
    return false;
  }

  Future<bool> makePayment(
      double tournamentFee, TournamentParticipant participant, context) async {
    try {
      //create invoice
      Invoice invoice = Invoice(
        tournamentId: participant.tournamentId,
        amount: tournamentFee,
        paidBy: '',
        belongsTo: participant.participantId,
        paymentReferenceId: '',
        paidCompleted: false,
        date: '',
        time: '',
      );
      String? invoiceId =
          await _database.add(invoice.toJson(), FirestoreCollections.invoice);

      //create payment Intent by requesting a new payment intent from the package services
      Map<String, dynamic> paymentIntent =
          await _stripePaymentService.createPaymentIntent(
              email: _auth.getCurrentUserEmail()!,
              amount: tournamentFee.toString());

      //init payment sheet using the payment intent
      await _stripePaymentService.initPaymentSheet(paymentIntent);

      //display payment sheet and let user make a payment
      bool paymentComplete = await _stripePaymentService.displayPaymentSheet();

      if (paymentComplete) {
        //updateInvoice
        await _database.update(
            invoiceId!,
            {
              'paidCompleted': true,
              'paidBy': _auth.currentUser(),
              'date': DateHelper.formatDate(DateTime.now()),
              'time': DateHelper.formatTime(DateTime.now()),
              'paymentReferenceId': paymentIntent['paymentIntentId']
            },
            FirestoreCollections.invoice);

        //update tournament participant
        await _database.update(participant.participantId, {'hasPay': true},
            FirestoreCollections.tournamentParticipant);

        //update tournament current participantList
        Tournament tournament = Tournament.fromJson(await _database.get(
            participant.tournamentId, FirestoreCollections.tournament));
        tournament.currentParticipant.add(participant.participantId);
        await _database.update(tournament.tournamentId, tournament.toJson(),
            FirestoreCollections.tournament);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    Text("Payment Successfull"),
                  ],
                ),
              ],
            ),
          ),
        );
      } else {
        //cancel the payment Intent
        await _stripePaymentService
            .cancelPayment(paymentIntent['paymentIntentId']);

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.cancel_rounded,
                      color: Colors.red,
                    ),
                    Flexible(
                      child: Text(
                        "Payment Failed, Please pay again in the invoice sections",
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      return paymentComplete;
    } on StripeException catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.red,
                  ),
                  Text(e.error.message!),
                ],
              ),
            ],
          ),
        ),
      );
      _log.debug(e.toString());
      return false;
    } catch (e) {
      // Failure(e.error, e.error.message, "tournament_registration_viewmodel.dart");
      _log.debug(e.toString());
      return false;
    }
  }

  @override
  Future<void> futureToRun() async {
    _isEmailValid = [true, false, false, false, false];
    _isEmailAlreadyRegisted = [true, false, false, false, false];
    _isUsernameValid = [false, false, false, false, false];
    _usernameList = ['', '', '', '', ''];
    _usernameId = ['', '', '', '', ''];
    _tagline = ['', '', '', '', ''];
    _selectedPlatformIndex = [0, 0, 0];
    //add current user to the state
    _userListState = [
      User.fromJson(
          await _database.get(_auth.currentUser()!, FirestoreCollections.users))
    ];
    // _userListState.add();
    _emailController = [_auth.getCurrentUserEmail()!, '', '', '', ''];
    return Future.value();
  }

  void updateUsername(String username, int index) {
    _usernameList[index] = username;
  }

  void updateTaglineOrPlatform(String tagline, int index) {
    _tagline[index] = tagline;
  }

  verifyPlayerUsername(String game, int index, context) async {
    try {
      _log.debug('game: $game');
      if (_usernameList[index].isEmpty) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    ),
                    Text("Please fill username"),
                  ],
                ),
              ],
            ),
          ),
        );

        return;
      }
      if (game == GameType.ApexLegend.name) {
        // apex game
        _log.debug(
            'username: ${_usernameList[index]} platform: ${platformList[_selectedPlatformIndex[index]]}');
        Map<String, dynamic> response = await _apexlegendDatabase.verifyPlayer(
            _usernameList[index], platformList[_selectedPlatformIndex[index]]);
        if (response['status'] == true) {
          _isUsernameValid[index] = true;
          _usernameId[index] = response['data']['uid'];
          notifyListeners();
        } else {
          _isUsernameValid[index] = false;
          _usernameId[index] = '';
          notifyListeners();
        }
      } else {
        //valorant game
        _log.debug(
            'username: ${_usernameList[index]} tagline: ${_tagline[index]}');
        if (_tagline[index].isEmpty || _tagline[index].length < 4) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ),
                      Text("Please fill in tagline"),
                    ],
                  ),
                ],
              ),
            ),
          );
          return;
        }
        Map<String, dynamic> data = await _valorantDatabase.verifyPlayer(
            _usernameList[index], _tagline[index]);
        if (data['status'] == true) {
          _usernameId[index] = data['data']['puuid'];
          _isUsernameValid[index] = true;
          notifyListeners();
        } else {
          _isUsernameValid[index] = false;
          _usernameId[index] = '';
          notifyListeners();
        }
      }
    } on Failure catch (e) {
      _log.debug(e.toString());
    } catch (e) {
      _log.debug(e.toString());
    }
  }
}
