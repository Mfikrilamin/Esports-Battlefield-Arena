class ApexMatchResult {
  late String _resultId;
  late String _matchId;
  late String _lobbyId;
  late int _gameNumber;
  late bool isCompleted;
  //since one match contain a total of 20 teams
  // _results will contain a list of 20 teams result
  late List<Map<String, dynamic>> _results;
  // _result
  // Key: Value
  // participantId : participantId
  // totalKills : totalKills
  // placement : placement
  // totalPoint : totalPoint
  // seed : seed

  String get resultId => _resultId;
  String get matchId => _matchId;
  String get lobbyId => _lobbyId;
  int get gameNumber => _gameNumber;
  bool get completed => isCompleted;
  List<Map<String, dynamic>> get results => _results;

  ApexMatchResult({
    String resultId = '',
    String matchId = '',
    String lobbyId = '',
    int gameNumber = 0,
    bool completed = false,
    List<Map<String, dynamic>> results = const [],
  })  : _resultId = resultId,
        _matchId = matchId,
        _lobbyId = lobbyId,
        _gameNumber = gameNumber,
        isCompleted = completed,
        _results = results;

  ApexMatchResult.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('resultId') &&
        map.containsKey('matchId') &&
        map.containsKey('lobbyId') &&
        map.containsKey('results') &&
        map.containsKey('gameNumber') &&
        map.containsKey('isCompleted')) {
      _resultId = map['resultId'] ?? '';
      _matchId = map['matchId'] ?? '';
      _lobbyId = map['lobbyId'] ?? '';
      _gameNumber = map['gameNumber'] ?? 0;
      isCompleted = map['isCompleted'] ?? false;
      _results = map['results'].cast<Map<String, dynamic>>().toList() ?? [];
    } else {
      throw ArgumentError(
          'Required keys are missing from the ApexMatchResult model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'resultId': _resultId,
      'matchId': _matchId,
      'lobbyId': _lobbyId,
      'gameNumber': _gameNumber,
      'isCompleted': isCompleted,
      'results': _results,
    };
  }

  ApexMatchResult copyWith(Map<String, dynamic> map) {
    return ApexMatchResult.fromJson(map);
  }
}
