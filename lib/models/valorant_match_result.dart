class ValorantMatchResult {
  late String _resultId;
  late String _matchId;
  late String _lobbyId;
  late int _gameNumber;
  late String _teamA;
  late String _teamB;
  late String _winner;
  late String _loser;
  late String _teamAScore;
  late String _teamBScore;
  late bool _isCompleted;
  late List<dynamic> _playerStats;

  // late List<Map<String, dynamic>> _results;
  // late String _participantId;
  // late int _roundWon;
  // late bool _isWinner;

  String get resultId => _resultId;
  String get matchId => _matchId;
  String get lobbyId => _lobbyId;
  String get teamA => _teamA;
  String get teamB => _teamB;
  int get gameNumber => _gameNumber;
  String get winner => _winner;
  String get loser => _loser;
  String get teamAScore => _teamAScore;
  String get teamBScore => _teamBScore;
  bool get isCompleted => _isCompleted;
  List<dynamic> get playerStats => _playerStats;
  // List<Map<String, dynamic>> get results => _results;
  // String get participantId => _participantId;
  // int get roundWon => _roundWon;
  // bool get isWinner => _isWinner;

  ValorantMatchResult({
    String resultId = '',
    String matchId = '',
    String lobbyId = '',
    int gameNumber = 0,
    String teamA = '',
    String teamB = '',
    String winner = '',
    String loser = '',
    String teamAScore = '',
    String teamBScore = '',
    bool isCompleted = false,
    List<dynamic> playerStats = const [],
    // List<Map<String, dynamic>> results = const [],
  })  : _resultId = resultId,
        _matchId = matchId,
        _lobbyId = lobbyId,
        _gameNumber = gameNumber,
        _teamA = teamA,
        _teamB = teamB,
        _winner = winner,
        _loser = loser,
        _teamAScore = teamAScore,
        _teamBScore = teamBScore,
        _isCompleted = isCompleted,
        _playerStats = playerStats;

  // _results = results;
  // _participantId = participantId,
  // _roundWon = roundWon,
  // _isWinner = isWinner;

  ValorantMatchResult.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('resultId') &&
            map.containsKey('matchId') &&
            map.containsKey('lobbyId') &&
            map.containsKey('gameNumber') &&
            map.containsKey('teamA') &&
            map.containsKey('teamB') &&
            map.containsKey('winner') &&
            map.containsKey('loser') &&
            map.containsKey('teamAScore') &&
            map.containsKey('teamBScore') &&
            map.containsKey('isCompleted') &&
            map.containsKey('playerStats')
        // map.containsKey('resultList')
        // map.containsKey('participantId') &&
        // map.containsKey('roundWon') &&
        // map.containsKey('isWinner')
        ) {
      _resultId = map['resultId'] ?? '';
      _matchId = map['matchId'] ?? '';
      _lobbyId = map['lobbyId'] ?? '';
      _gameNumber = map['gameNumber'] ?? 0;
      _teamA = map['teamA'] ?? '';
      _teamB = map['teamB'] ?? '';
      _winner = map['winner'] ?? '';
      _loser = map['loser'] ?? '';
      _teamAScore = map['teamAScore'] ?? '';
      _teamBScore = map['teamBScore'] ?? '';
      _isCompleted = map['isCompleted'] ?? false;
      _playerStats = map['playerStats'] ?? [];
      // _results = map['resultList'] ?? [];
      // _participantId = map['participantId'] ?? '';
      // _roundWon = map['roundWon'] ?? 0;
      // _isWinner = map['isWinner'] ?? false;
    } else {
      throw ArgumentError('Required keys are missing from the User model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'resultId': _resultId,
      'matchId': _matchId,
      'lobbyId': _lobbyId,
      'gameNumber': _gameNumber,
      'teamA': _teamA,
      'teamB': _teamB,
      'winner': _winner,
      'loser': _loser,
      'teamAScore': _teamAScore,
      'teamBScore': _teamBScore,
      'isCompleted': _isCompleted,
      'playerStats': _playerStats,
      // 'resultList': _results,
      // 'participantId': _participantId,
      // 'roundWon': _roundWon,
      // 'isWinner': _isWinner,
    };
  }

  ValorantMatchResult copyWith(Map<String, dynamic> map) {
    return ValorantMatchResult.fromJson(map);
  }
}
