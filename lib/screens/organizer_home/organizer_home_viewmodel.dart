import 'package:esports_battlefield_arena/app/app.dart';
import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/User.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/auth.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/utils/date.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class OrganizerHomeViewModel extends BaseViewModel {
  final AppRouter _router = locator<AppRouter>();
  final _log = locator<LogService>();
  AppRouter _appRouter = locator<AppRouter>();
  Auth _auth = locator<Auth>();
  Database _database = locator<Database>();
  bool isPlayer = false;

  //Permanent Variables
  final List<String> _gameList = GameType.values.map((e) => e.name).toList();
  final List<String> _participationTypeList =
      ParticipationType.values.map((e) => e.name).toList();

  List<String> get gameList => _gameList;
  List<String> get participationTypeList => _participationTypeList;

  //Temporary state
  String _title = '';
  String _description = '';
  double _prizePool = 0;
  double _entryFee = 0;
  DateTime? _startDate;
  DateTime? _endDate;
  int _gameSelectedIndex = 0;
  int _modeSelectedIndex = 0;
  int _maxParticipant = 0;
  int _memberPerTeam = 0;
  List<String> _ruleList = [''];

  //getter
  String get title => _title;
  String get description => _description;
  double get prizePool => _prizePool;
  double get entryFee => _entryFee;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  int get gameSelectedIndex => _gameSelectedIndex;
  int get modeSelectedIndex => _modeSelectedIndex;
  int get maxParticipant => _maxParticipant;
  int get memberPerTeam => _memberPerTeam;
  List<String> get ruleList => _ruleList;

  //setters
  void updateTournamentTitle(String title) {
    _title = title;
  }

  void updateTournamentDescription(String description) {
    _description = description;
  }

  void updateTournamentPrizePool(String prizePool) {
    if (prizePool.isEmpty) return;
    _prizePool = double.parse(prizePool);
  }

  void updateTournamentFee(String fee) {
    _entryFee = double.parse(fee);
  }

  void updateStartDate(DateTime selectedDate) {
    _startDate = selectedDate;
  }

  void updateEndDate(DateTime selectedDate) {
    _endDate = selectedDate;
  }

  void updateGameSelectedIndex(int? index) {
    _gameSelectedIndex = index!;
    notifyListeners();
  }

  void updateModeSelectedIndex(int? index) {
    _modeSelectedIndex = index!;
    notifyListeners();
  }

  void updateMaxParticipants(String maxParticipant) {
    _maxParticipant = int.parse(maxParticipant);
  }

  void updateMemberPerTeam(String maxMember) {
    _memberPerTeam = int.parse(maxMember);
  }

  void addNewRule() {
    ruleList.add('');
    notifyListeners();
  }

  void updateTournamentRule(String rule, int index) {
    _ruleList[index] = rule;
  }

  void disposeState() {
    _title = '';
    _description = '';
    _prizePool = 0.00;
    _entryFee = 0.00;
    _startDate = null;
    _endDate = null;
    _gameSelectedIndex = 0;
    _modeSelectedIndex = 0;
    _maxParticipant = 0;
    _memberPerTeam = 0;
    _ruleList = [''];
    notifyListeners();
  }

  //Business Logic
  Future<void> createTournament(context) async {
    try {
      setBusy(true);
      _log.info(
          'Title : $_title \n Description: $_description \n Prize Pool: $_prizePool \n Entry Fee: $_entryFee \n Start Date: $_startDate \n End Date: $_endDate \n Game: ${_gameList[_gameSelectedIndex]} \n Mode: ${_participationTypeList[_modeSelectedIndex]} \n Max Participant: $_maxParticipant \n Member Per Team: $_memberPerTeam \n Rules: $_ruleList');
      if (_startDate == null ||
          _endDate == null ||
          _startDate!.isAfter(_endDate!) ||
          _title.isEmpty ||
          _description.isEmpty ||
          _prizePool == 0 ||
          _entryFee == 0 ||
          _maxParticipant == 0 ||
          _memberPerTeam == 0 ||
          (ruleList.length == 1 && ruleList[0].isEmpty)) {
        //show error dialog
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.error,
                      color: kcTertiaryColor,
                    ),
                    SizedBox(
                      width: 200,
                      child:
                          Text("Register failed, please fill in all details"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        return;
      }

      final Tournament tournament = Tournament(
        title: _title,
        rules: _ruleList,
        description: _description,
        prizePool: _prizePool,
        entryFee: _entryFee,
        startDate: DateHelper.formatDate(_startDate!),
        endDate: DateHelper.formatDate(_endDate!),
        maxParticipants: _maxParticipant,
        maxMemberPerTeam: _memberPerTeam,
        game: _gameList[_gameSelectedIndex],
        status: GameStatus.pending.name,
        matchList: [],
        organizerId: _auth.currentUser()!,
        currentParticipant: [],
        isSolo: _participationTypeList[_modeSelectedIndex] == 'solo',
      );

      await _database.add(tournament.toJson(), FirestoreCollections.tournament);
      disposeState();
      setBusy(false);
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.check_circle,
                    color: kcPrimaryDarkerColor,
                  ),
                  SizedBox(
                    width: 200,
                    child: Text("Register sucessfully"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      // Need to push to organizer created tournament list
      // _router.popAndPush('organizer_home');
    } on Failure catch (failure) {
      _log.debug(failure.toString());
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error,
                    color: kcTertiaryColor,
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(failure.message!),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      _log.debug(e.toString());
    }
  }
}
