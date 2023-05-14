import 'package:country_picker/country_picker.dart';
import 'package:esports_battlefield_arena/app/app.dart';
import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/invoice.dart';
import 'package:esports_battlefield_arena/models/player.dart';
import 'package:esports_battlefield_arena/models/team.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/models/tournament_participant.dart';
import 'package:esports_battlefield_arena/models/user.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/auth.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
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

  //Email Controller
  List<String> _emailController = [];
  List<bool> _isEmailValid = [];
  List<bool> _isEmailAlreadyRegisted = [];
  List<User> _userListState = [];

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

  void updateTeamName(String teamName) {
    _teamName = teamName;
  }

  void updateTeamCountry(String countryName, String countryCode) {
    _teamCountry = countryName;
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

  @override
  void dispose() {
    super.dispose();
    _emailController.clear();
  }

  bool validateIfAllInputHasBeenFilled(int emailCount) {
    _log.debug(
        'Valid user count: ${_userListState.length} ----  email count: $emailCount');
    if (_userListState.length != emailCount) {
      notifyListeners();
      return false;
    }
    notifyListeners();
    return true;
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
      }
      setBusy(true);
      Tournament tournament = Tournament.fromJson(
          await _database.get(tournamentId, FirestoreCollections.tournament));

      bool userIsAlreadyRegister =
          await validateIfInputUserRegister(tournamentId);

      if (tournament.currentParticipant.length <= tournament.maxParticipants &&
          !userIsAlreadyRegister) {
        _log.debug('This is excuted');
        TournamentParticipant participant = TournamentParticipant(
            participantId: '',
            dateRegister: DateHelper.formatDate(DateTime.now()),
            country: _teamCountry,
            teamName: _teamName,
            memberList: _userListState.map((user) => user.userId).toList(),
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
            memberList: _userListState.map((user) => user.userId).toList(),
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
        paidCompleted: false,
        date: '',
        time: '',
      );
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
            invoice.invoiceId,
            {
              'paidCompleted': true,
              'paidBy': _auth.currentUser(),
              'date': DateHelper.formatDate(DateTime.now()),
              'time': DateHelper.formatTime(DateTime.now()),
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

  Future<TournamentParticipant> registerParticipant(
      Tournament tournament, bool isSolo) async {
    //if game mode is team, the register team and assign team id to tournamentParticipant
    //else, create tournamentParticipant for every player
    // String? newTeamId;
    // if (!isSolo) {
    //   //create team
    //   //assign team id to tournamentParticipant
    //   Team newTeam = Team(
    //     teamName: _teamName,
    //     teamCountry: _teamCountry,
    //     memberList: _userListState.map((user) => user.userId).toList(),
    //   );
    //   newTeamId =
    //       await _database.add(newTeam.toJson(), FirestoreCollections.team);
    // }
    //register participant to the tournament
    TournamentParticipant participant = TournamentParticipant(
        participantId: '',
        dateRegister: DateHelper.formatDate(DateTime.now()),
        country: _teamCountry,
        teamName: _teamName,
        memberList: _userListState.map((user) => user.userId).toList(),
        tournamentId: tournament.tournamentId,
        seeding: 0,
        isSolo: isSolo,
        hasPay: false);

    await _database.add(
        participant.toJson(), FirestoreCollections.tournamentParticipant);
    return participant;
  }

  @override
  Future<void> futureToRun() async {
    _isEmailValid = [true, false, false, false, false];
    _isEmailAlreadyRegisted = [true, false, false, false, false];
    //add current user to the state
    _userListState = [
      User.fromJson(
          await _database.get(_auth.currentUser()!, FirestoreCollections.users))
    ];
    // _userListState.add();
    _emailController = [_auth.getCurrentUserEmail()!, '', '', '', ''];
    return Future.value();
  }
}
