class ApexMatch {
  late String _matchId;
  late String _nextMatchId;
  late String _tournamentId;
  late String _lobbyId;
  late String _game;
  late int _round;
  late int _group;
  late String _date;
  late String _startTime;
  late String _endTime;
  late bool _hasCompleted;
  late List<String> _teamList;
  late List<String> _resultList;

  String get tournamentId => _tournamentId;
  String get matchId => _matchId;
  String get nextMatchId => _nextMatchId;
  String get lobbyId => _lobbyId;
  String get game => _game;
  int get round => _round;
  int get group => _group;
  String get date => _date;
  String get startTime => _startTime;
  String get endTime => _endTime;
  bool get hasCompleted => _hasCompleted;
  List<String> get teamList => _teamList;
  List<String> get resultList => _resultList;

  ApexMatch({
    String tournamentId = '',
    String matchId = '',
    String nextMatchId = '',
    String game = '',
    int round = 0,
    int group = 0,
    String date = '',
    String startTime = '',
    String endTime = '',
    bool hasCompleted = false,
    List<String> teamList = const [],
    List<String> resultList = const [],
  })  : _tournamentId = tournamentId,
        _matchId = matchId,
        _nextMatchId = nextMatchId,
        _game = game,
        _round = round,
        _group = group,
        _date = date,
        _startTime = startTime,
        _endTime = endTime,
        _hasCompleted = hasCompleted,
        _teamList = teamList,
        _resultList = resultList;

  ApexMatch.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('tournamentId') &&
        map.containsKey('matchId') &&
        map.containsKey('nextMatchId') &&
        map.containsKey('game') &&
        map.containsKey('round') &&
        map.containsKey('group') &&
        map.containsKey('date') &&
        map.containsKey('startTime') &&
        map.containsKey('endTime') &&
        map.containsKey('hasCompleted') &&
        map.containsKey('teamList') &&
        map.containsKey('resultList')) {
      _tournamentId = map['tournamentId'] ?? '';
      _matchId = map['matchId'] ?? '';
      _nextMatchId = map['nextMatchId'] ?? '';
      _game = map['game'] ?? '';
      _round = map['round'] ?? 0;
      _group = map['group'] ?? 0;
      _date = map['date'] ?? '';
      _startTime = map['startTime'] ?? '';
      _endTime = map['endTime'] ?? '';
      _hasCompleted = map['hasCompleted'] ?? false;
      _teamList = map['teamList'].cast<String>().toList() ?? [];
      _resultList = map['resultList'].cast<String>().toList() ?? [];
    } else {
      throw ArgumentError('Required keys are missing from the ApexMatch model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'tournamentId': _tournamentId,
      'matchId': _matchId,
      'nextMatchId': _nextMatchId,
      'game': _game,
      'round': _round,
      'group': _group,
      'date': _date,
      'startTime': _startTime,
      'endTime': _endTime,
      'hasCompleted': _hasCompleted,
      'teamList': _teamList,
      'resultList': _resultList,
    };
  }

  ApexMatch copyWith(Map<String, dynamic> map) {
    return ApexMatch.fromJson(map);
  }
}
