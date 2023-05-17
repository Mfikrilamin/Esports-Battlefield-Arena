import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/utils/date.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:stacked/stacked.dart';
// import 'package:observable_ish/observable_ish.dart';

class TournamentService with ReactiveServiceMixin {
  TournamentService() {
    listenToReactiveValues([
      _editFlag,
      _title,
      _description,
      _prizePool,
      _entryFee,
      _startDate,
      _endDate,
      _gameSelectedIndex,
      _modeSelectedIndex,
      _maxParticipant,
      _memberPerTeam,
      _ruleList,
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
  ReactiveValue<int> _modeSelectedIndex = ReactiveValue<int>(0);
  ReactiveValue<int> _maxParticipant = ReactiveValue<int>(0);
  ReactiveValue<int> _memberPerTeam = ReactiveValue<int>(0);
  ReactiveValue<List<String>> _ruleList = ReactiveValue<List<String>>(['']);

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
  int get memberPerTeam => _memberPerTeam.value;
  List<String> get ruleList => _ruleList.value;

  //business process
  void updateTournament(Tournament tournament) {
    _tournamentId.value = tournament.tournamentId;
    _editFlag.value = true;
    _title.value = tournament.title;
    _description.value = tournament.description;
    _prizePool.value = tournament.prizePool;
    _entryFee.value = tournament.entryFee;
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
    notifyListeners();
  }
}
