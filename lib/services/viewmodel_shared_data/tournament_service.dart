import 'dart:developer';
import 'dart:io';

import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/apex_match.dart';
import 'package:esports_battlefield_arena/models/apex_match_result.dart';
import 'package:esports_battlefield_arena/models/player.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/models/tournament_participant.dart';
import 'package:esports_battlefield_arena/models/valorant_match.dart';
import 'package:esports_battlefield_arena/models/valorant_match_result.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/utils/date.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:stacked/stacked.dart';
// import 'package:observable_ish/observable_ish.dart';

class TournamentService with ReactiveServiceMixin {
  final Database _database = locator<Database>();
  TournamentService() {
    listenToReactiveValues([
      _editFlag,
      _tournament,
      _title,
      _description,
      _prizePool,
      _entryFee,
      _startDate,
      _endDate,
      _gameSelectedIndex,
      _modeSelectedIndex,
      _maxParticipant,
      _participantsId,
      _memberPerTeam,
      _gamePerMatch,
      _ruleList,
      _participantsInformation,
      _players,
      _leaderboardGame,
      _roundExpanded,
      _matchExpanded,
      _carousellSelectedIndex,
      _valorantMatches,
      _apexMatches,
      _valorantResults,
      _apexResults
    ]);
  }
  ReactiveValue<bool> _editFlag = ReactiveValue<bool>(false);
  //Temporary state
  ReactiveValue<String> _tournamentId = ReactiveValue<String>('');
  ReactiveValue<String> _title = ReactiveValue<String>('');
  ReactiveValue<String> _description = ReactiveValue<String>('');
  ReactiveValue<double> _prizePool = ReactiveValue<double>(0);
  ReactiveValue<double> _entryFee = ReactiveValue<double>(0);
  ReactiveValue<DateTime?> _startDate = ReactiveValue<DateTime?>(null);
  ReactiveValue<DateTime?> _endDate = ReactiveValue<DateTime?>(null);
  ReactiveValue<int> _gameSelectedIndex = ReactiveValue<int>(0);
  ReactiveValue<int> _modeSelectedIndex = ReactiveValue<int>(1);
  ReactiveValue<int> _maxParticipant = ReactiveValue<int>(0);
  ReactiveValue<List<dynamic>> _participantsId =
      ReactiveValue<List<dynamic>>([]);
  ReactiveValue<int> _memberPerTeam = ReactiveValue<int>(0);
  ReactiveValue<int> _gamePerMatch = ReactiveValue<int>(0);
  ReactiveValue<List<String>> _ruleList = ReactiveValue<List<String>>(['']);

  //Participant information screen
  ReactiveValue<Tournament> _tournament =
      ReactiveValue<Tournament>(Tournament());
  ReactiveValue<List<TournamentParticipant>> _participantsInformation =
      ReactiveValue<List<TournamentParticipant>>([]);
  ReactiveValue<List<List<Player>>> _players =
      ReactiveValue<List<List<Player>>>([]);

  //Leadboard screen
  ReactiveValue<String> _leaderboardGame = ReactiveValue<String>('');
  ReactiveValue<List<bool>> _roundExpanded = ReactiveValue<List<bool>>([]);
  ReactiveValue<List<List<bool>>> _matchExpanded =
      ReactiveValue<List<List<bool>>>([[]]);
  ReactiveValue<List<List<int>>> _carousellSelectedIndex =
      ReactiveValue<List<List<int>>>([[]]);
  ReactiveValue<List<List<ValorantMatch>>> _valorantMatches =
      ReactiveValue<List<List<ValorantMatch>>>([]);
  ReactiveValue<List<List<ApexMatch>>> _apexMatches =
      ReactiveValue<List<List<ApexMatch>>>([]);
  ReactiveValue<List<Map<String, List<ValorantMatchResult>>>> _valorantResults =
      ReactiveValue<List<Map<String, List<ValorantMatchResult>>>>([]);
  ReactiveValue<List<Map<String, List<ApexMatchResult>>>> _apexResults =
      ReactiveValue<List<Map<String, List<ApexMatchResult>>>>([]);

  //setter
  void updateTournamentTitle(String title) {
    _title.value = title;
  }

  void updateTournamentDescription(String description) {
    _description.value = description;
  }

  void updateTournamentPrizePool(String prizePool) {
    if (prizePool.isEmpty) return;
    _prizePool.value = double.parse(prizePool);
  }

  void updateTournamentFee(String fee) {
    _entryFee.value = double.parse(fee);
  }

  void updateStartDate(DateTime selectedDate) {
    _startDate.value = selectedDate;
  }

  void updateEndDate(DateTime selectedDate) {
    _endDate.value = selectedDate;
  }

  void updateCarousellSelectedIndex(int roundIndex, int groupIndex, int index) {
    _carousellSelectedIndex.value[roundIndex][groupIndex] = index;
    notifyListeners();
  }

  void updateGameSelectedIndex(int? index) {
    _gameSelectedIndex.value = index!;
    notifyListeners();
  }

  void updateModeSelectedIndex(int? index) {
    _modeSelectedIndex.value = index!;
    notifyListeners();
  }

  void updateMaxParticipant(String maxParticipant) {
    _maxParticipant.value = int.parse(maxParticipant);
  }

  void updateMemberPerTeam(String memberPerTeam) {
    _memberPerTeam.value = int.parse(memberPerTeam);
    notifyListeners();
  }

  void updateGamePerMatch(String gamePerMatch) {
    _gamePerMatch.value = int.parse(gamePerMatch);
  }

  void updateRule(String rule, int index) {
    _ruleList.value[index] = rule;
  }

  void addRule() {
    _ruleList.value.add('');
    notifyListeners();
  }

  void removeRule(int index) {
    _ruleList.value.removeAt(index);
    notifyListeners();
  }

  //getters
  bool get editFlag => _editFlag.value;
  String get tournamentId => _tournamentId.value;
  String get title => _title.value;
  String get description => _description.value;
  double get prizePool => _prizePool.value;
  double get entryFee => _entryFee.value;
  DateTime? get startDate => _startDate.value;
  DateTime? get endDate => _endDate.value;
  int get gameSelectedIndex => _gameSelectedIndex.value;
  int get modeSelectedIndex => _modeSelectedIndex.value;
  int get maxParticipant => _maxParticipant.value;
  List<TournamentParticipant> get participantsInformation =>
      _participantsInformation.value;
  List<List<Player>> get players => _players.value;
  int get memberPerTeam => _memberPerTeam.value;
  int get gamePerMatch => _gamePerMatch.value;
  List<String> get ruleList => _ruleList.value;

  //leaderboard screen
  String get leaderboardGame => _leaderboardGame.value;
  List<bool> get roundExpanded => _roundExpanded.value;
  List<List<bool>> get matchExpanded => _matchExpanded.value;
  List<List<int>> get carousellSelectedIndex => _carousellSelectedIndex.value;
  List<List<ValorantMatch>> get valorantMatches => _valorantMatches.value;
  List<List<ApexMatch>> get apexMatches => _apexMatches.value;
  List<Map<String, List<ValorantMatchResult>>> get valorantResults =>
      _valorantResults.value;
  List<Map<String, List<ApexMatchResult>>> get apexResults =>
      _apexResults.value;

  //business process
  void updateTournament(Tournament tournament) {
    _tournamentId.value = tournament.tournamentId;
    _editFlag.value = true;
    _title.value = tournament.title;
    _description.value = tournament.description;
    _prizePool.value = tournament.prizePool;
    _entryFee.value = tournament.entryFee;
    _gamePerMatch.value = tournament.gamePerMatch;
    _startDate.value = DateHelper.formatString(tournament.startDate);
    _endDate.value = DateHelper.formatString(tournament.endDate);
    switch (tournament.game == GameType.ApexLegend.name) {
      case true:
        _gameSelectedIndex.value = 1;
        break;
      case false:
        _gameSelectedIndex.value = 0;
        break;
    }
    switch (tournament.isSolo) {
      case true:
        _modeSelectedIndex.value = 0;
        break;
      case false:
        _modeSelectedIndex.value = 1;
        break;
    }
    _maxParticipant.value = tournament.maxParticipants;
    _memberPerTeam.value = tournament.maxMemberPerTeam;
    _ruleList.value = tournament.rules;
    notifyListeners();
  }

  void disposeTournament() {
    _tournamentId.value = '';
    _editFlag.value = false;
    _title.value = '';
    _description.value = '';
    _prizePool.value = 0.00;
    _entryFee.value = 0.00;
    _startDate.value = null;
    _endDate.value = null;
    _gameSelectedIndex.value = 0;
    _modeSelectedIndex.value = 0;
    _maxParticipant.value = 0;
    _memberPerTeam.value = 0;
    _ruleList.value = [''];
    _participantsId.value = [];
    _participantsInformation.value = [];
    _players.value = [];
    notifyListeners();
  }

  Future<void> getAllParticipantInformation(Tournament tournament) async {
    log('this is running');
    log(tournament.tournamentId);
    log(tournament.currentParticipant.toString());

    _tournament.value = tournament;
    List<TournamentParticipant> participantList = [];

    for (String id in tournament.currentParticipant) {
      List<String> playerIdList = [];
      log('the loop is running');
      log(id);
      TournamentParticipant participant = TournamentParticipant.fromJson(
          await _database.get(id, FirestoreCollections.tournamentParticipant));
      participantList.add(participant);
      playerIdList.addAll(participant.memberList.cast<String>());
      List<Player> playerList = [];
      for (String id in playerIdList) {
        Player player = Player.fromJson(
            await _database.get(id, FirestoreCollections.player));
        playerList.add(player);
      }
      _players.value.add(playerList);
    }
    _participantsInformation.value = participantList;
    log('players: ${_players.value.toString()}');
    log('participantInformation: ${_participantsInformation.value.toString()}');
    notifyListeners();
  }

  Future<void> refreshParticipantInformation() async {
    _players.value = [];
    _participantsInformation.value = [];
    log('this is running');
    List<TournamentParticipant> participantList = [];

    for (String id in _tournament.value.currentParticipant) {
      List<String> playerIdList = [];
      log('the loop is running');
      log(id);
      TournamentParticipant participant = TournamentParticipant.fromJson(
          await _database.get(id, FirestoreCollections.tournamentParticipant));
      participantList.add(participant);
      playerIdList.addAll(participant.memberList.cast<String>());
      List<Player> playerList = [];
      for (String id in playerIdList) {
        Player player = Player.fromJson(
            await _database.get(id, FirestoreCollections.player));
        playerList.add(player);
      }
      _players.value.add(playerList);
    }
    _participantsInformation.value = participantList;
    log('players: ${_players.value.toString()}');
    log('participantInformation: ${_participantsInformation.value.toString()}');
    notifyListeners();
  }

  Future<void> getLeaderboardResult(Tournament tournament) async {
    try {
      _leaderboardGame.value = tournament.game;
      if (tournament.game == GameType.ApexLegend.name) {
        //get all match in the tournament and store it
        List<Map<String, dynamic>> matchesData = await _database.getAllByQuery(
            ['tournamentId'],
            [tournament.tournamentId],
            FirestoreCollections.apexMatch);
        List<ApexMatch> apexMatches =
            matchesData.map((e) => ApexMatch.fromJson(e)).toList();
        apexMatches.sort((a, b) {
          int roundCompare = a.round.compareTo(b.round);
          if (roundCompare != 0) {
            return roundCompare;
          }

          return a.group.compareTo(b.group);
        });
        log(apexMatches.toString());

        int round = 1;
        int resultIndex = 0;
        //get all result in the tournament and store it
        Map<String, List<ApexMatchResult>> tempApexMatchResult = {};
        List<ApexMatch> tempApexMatch = [];
        for (ApexMatch apexMatch in apexMatches) {
          List<Map<String, dynamic>> resultsData = await _database
              .getAllByQuery(['matchId'], [apexMatch.matchId],
                  FirestoreCollections.apexMatchResult);
          List<ApexMatchResult> apexMatchResults =
              resultsData.map((e) => ApexMatchResult.fromJson(e)).toList();
          apexMatchResults.sort((a, b) => a.gameNumber.compareTo(b.gameNumber));
          if (apexMatch.round > round) {
            round = apexMatch.round;
            _apexMatches.value.add(tempApexMatch);
            _apexResults.value.add(tempApexMatchResult);
            tempApexMatchResult = {};
            tempApexMatch = [];
            resultIndex = 0;
            tempApexMatch.add(apexMatch);
            tempApexMatchResult.putIfAbsent(
                resultIndex.toString(), () => apexMatchResults);
            resultIndex++;
          } else {
            tempApexMatchResult.putIfAbsent(
                resultIndex.toString(), () => apexMatchResults);
            resultIndex++;
            tempApexMatch.add(apexMatch);
          }
        }
        _apexMatches.value.add(tempApexMatch);
        _apexResults.value.add(tempApexMatchResult);

        //initialize the match state
        _roundExpanded.value =
            List.generate(round, (roundIndex) => false, growable: false);
        _matchExpanded.value = List.generate(
            round,
            (roundIndex) => List.generate(
                _apexResults.value[roundIndex].length, (index) => false));
        _carousellSelectedIndex.value = List.generate(
            round,
            (roundIndex) => List.generate(
                _apexResults.value[roundIndex].length, (index) => 0));
        log('round expanded : ${_roundExpanded.value.toString()}');
        // log('match expanded : ${_matchExpanded.value.toString()}');
        log('carousel selected index : ${_carousellSelectedIndex.value.toString()}');
        log('Match : ${_apexMatches.value.toString()}');
        log('Result : ${_apexResults.value.toString()}');
      } else if (tournament.game == GameType.Valorant.name) {
        //get all match in the tournament and store it
        List<Map<String, dynamic>> matchesData = await _database.getAllByQuery(
            ['tournamentId'],
            [tournament.tournamentId],
            FirestoreCollections.valorantMatch);
        List<ValorantMatch> valorantMatches =
            matchesData.map((e) => ValorantMatch.fromJson(e)).toList();

        //sort the match by round and match
        valorantMatches.sort((a, b) {
          int roundCompartison = a.round.compareTo(b.round);
          if (roundCompartison != 0) {
            return roundCompartison;
          }
          return a.match.compareTo(b.match);
        });

        int maxRound = 1;
        int resultIndex = 0;
        //get all result in the tournament and store it
        Map<String, List<ValorantMatchResult>> temp = {};
        List<ValorantMatch> tempMatch = [];
        for (ValorantMatch valorantMatch in valorantMatches) {
          List<Map<String, dynamic>> resultsData = await _database
              .getAllByQuery(['matchId'], [valorantMatch.matchId],
                  FirestoreCollections.valorantMatchResult);
          List<ValorantMatchResult> results =
              resultsData.map((e) => ValorantMatchResult.fromJson(e)).toList();
          if (valorantMatch.round > maxRound) {
            //if round is different, add the hashMap to the list
            maxRound = valorantMatch.round;
            _valorantResults.value.add(temp);
            _valorantMatches.value.add(tempMatch);
            tempMatch = [];
            temp = {};
            resultIndex = 0;
            tempMatch.add(valorantMatch);
            temp.putIfAbsent(resultIndex.toString(), () => results);
            resultIndex++;
          } else {
            //if round is the same, add the match and result to the hashMap
            tempMatch.add(valorantMatch);
            temp.putIfAbsent(resultIndex.toString(), () => results);
            resultIndex++;
          }
        }

        _valorantResults.value.add(temp);
        _valorantMatches.value.add(tempMatch);

        //initialize the match state
        _roundExpanded.value =
            List.generate(maxRound, (index) => false, growable: false);
        _matchExpanded.value = List.generate(
            maxRound,
            (roundIndex) => List.generate(
                _valorantResults.value[roundIndex].length, (index) => false));
        log('round expanded : ${_roundExpanded.value.toString()}');
        log('match expanded : ${_matchExpanded.value.toString()}');
        log('Match : ${_valorantMatches.value.toString()}');
        log('Result : ${_valorantResults.value.toString()}');
      } else {
        // not valid game
      }
      notifyListeners();
    } catch (e) {
      log('error in getLeaderboardResult');
      log(e.toString());
    }
  }

  void disposeMatchAndResultInformation() {
    _roundExpanded.value = [];
    _matchExpanded.value = [];
    _apexMatches.value = [];
    _apexResults.value = [];
    _valorantMatches.value = [];
    _valorantResults.value = [];
    notifyListeners();
  }

  void disposeParticipantInformation() {
    _participantsInformation.value = [];
    _players.value = [];
    _tournamentId.value = '';
    notifyListeners();
  }

  Future<void> resetPointKillAndPlacement(
      int roundIndex, int matchIndex, int gameIndex) async {
    try {
      String matchIndexStr = matchIndex.toString();
      ApexMatchResult existingMatchResult = ApexMatchResult.fromJson(
          await _database.get(
              apexResults[roundIndex][matchIndexStr]![gameIndex].resultId,
              FirestoreCollections.apexMatchResult));
      List<Map<String, dynamic>> resultsData =
          apexResults[roundIndex][matchIndexStr]![gameIndex].results;
      // Reupdate back the state with the exisiting data
      for (int teamResultIndex = 0;
          teamResultIndex < resultsData.length;
          teamResultIndex++) {
        // this loop will assign back the existing data to the current state
        // currentState = exisitngData
        apexResults[roundIndex][matchIndexStr]![gameIndex]
                .results[teamResultIndex]['kills'] =
            existingMatchResult.results[teamResultIndex]['kills'];
        apexResults[roundIndex][matchIndexStr]![gameIndex]
                .results[teamResultIndex]['placement'] =
            existingMatchResult.results[teamResultIndex]['placement'];
        apexResults[roundIndex][matchIndexStr]![gameIndex]
                .results[teamResultIndex]['points'] =
            existingMatchResult.results[teamResultIndex]['points'];
      }
      notifyListeners();
    } catch (e) {
      log('error in resetPointKillAndPlacement');
      log(e.toString());
    }
  }
}
