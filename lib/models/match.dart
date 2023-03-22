class Match {
  late String _matchId;
  late String _tournamentId;
  late String _startTime;
  late String _endTime;
  late bool _hasCompleted;
  late List<String> _resultList;

  String get tournamentId => _tournamentId;
  String get matchId => _matchId;
  String get startTime => _startTime;
  String get endTime => _endTime;
  bool get hasCompleted => _hasCompleted;
  List<String> get resultList => _resultList;

  Match({
    String tournamentId = '',
    String matchId = '',
    String startTime = '',
    String endTime = '',
    bool hasCompleted = false,
    List<String> resultList = const [],
  })  : _tournamentId = tournamentId,
        _matchId = matchId,
        _startTime = startTime,
        _endTime = endTime,
        _hasCompleted = hasCompleted,
        _resultList = resultList;

  Match.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('tournamentId') &&
        map.containsKey('matchId') &&
        map.containsKey('startTime') &&
        map.containsKey('endTime') &&
        map.containsKey('hasCompleted') &&
        map.containsKey('resultList')) {
      _tournamentId = map['tournamentId'] ?? '';
      _matchId = map['matchId'] ?? '';
      _startTime = map['startTime'] ?? '';
      _endTime = map['endTime'] ?? '';
      _hasCompleted = map['hasCompleted'] ?? false;
      _resultList = map['resultList'] ?? [];
    } else {
      throw ArgumentError('Required keys are missing from the User model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'tournamentId': _tournamentId,
      'matchId': _matchId,
      'startTime': _startTime,
      'endTime': _endTime,
      'hasCompleted': _hasCompleted,
      'resultList': _resultList,
    };
  }

  Match copyWith(Map<String, dynamic> map) {
    return Match.fromJson(map);
  }
}
