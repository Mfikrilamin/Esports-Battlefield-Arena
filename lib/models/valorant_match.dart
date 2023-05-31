class ValorantMatch {
  late String _matchId;
  late String _nextMatchId;
  late String _tournamentId;
  late String _lobbyId;
  late String _game;
  late int _round;
  late int _match;
  late String _teamA;
  late String _teamB;
  late String _winner;
  late String _loser;
  late String _teamAScore;
  late String _teamBScore;
  late String _date;
  late String _startTime;
  late String _endTime;
  late bool _hasCompleted;
  late List<String> _resultList;

  String get tournamentId => _tournamentId;
  String get matchId => _matchId;
  String get nextMatchId => _nextMatchId;
  String get lobbyId => _lobbyId;
  String get game => _game;
  int get round => _round;
  int get match => _match;
  String get teamA => _teamA;
  String get teamB => _teamB;
  String get winner => _winner;
  String get loser => _loser;
  String get teamAScore => _teamAScore;
  String get teamBScore => _teamBScore;
  String get date => _date;
  String get startTime => _startTime;
  String get endTime => _endTime;
  bool get hasCompleted => _hasCompleted;
  List<String> get resultList => _resultList;

  ValorantMatch({
    String tournamentId = '',
    String matchId = '',
    String nextMatchId = '',
    String game = '',
    int round = 0,
    int match = 0,
    String teamA = '',
    String teamB = '',
    String winner = '',
    String loser = '',
    String teamAScore = '',
    String teamBScore = '',
    String date = '',
    String startTime = '',
    String endTime = '',
    bool hasCompleted = false,
    List<String> resultList = const [],
  })  : _tournamentId = tournamentId,
        _matchId = matchId,
        _nextMatchId = nextMatchId,
        _game = game,
        _round = round,
        _match = match,
        _teamA = teamA,
        _teamB = teamB,
        _winner = winner,
        _loser = loser,
        _teamAScore = teamAScore,
        _teamBScore = teamBScore,
        _date = date,
        _startTime = startTime,
        _endTime = endTime,
        _hasCompleted = hasCompleted,
        _resultList = resultList;

  ValorantMatch.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('tournamentId') &&
        map.containsKey('matchId') &&
        map.containsKey('nextMatchId') &&
        map.containsKey('game') &&
        map.containsKey('round') &&
        map.containsKey('match') &&
        map.containsKey('teamA') &&
        map.containsKey('teamB') &&
        map.containsKey('winner') &&
        map.containsKey('loser') &&
        map.containsKey('teamAScore') &&
        map.containsKey('teamBScore') &&
        map.containsKey('date') &&
        map.containsKey('startTime') &&
        map.containsKey('endTime') &&
        map.containsKey('hasCompleted') &&
        map.containsKey('resultList')) {
      _tournamentId = map['tournamentId'] ?? '';
      _matchId = map['matchId'] ?? '';
      _nextMatchId = map['nextMatchId'] ?? '';
      _game = map['game'] ?? '';
      _round = map['round'] ?? 0;
      _match = map['match'] ?? 0;
      _teamA = map['teamA'] ?? '';
      _teamB = map['teamB'] ?? '';
      _winner = map['winner'] ?? '';
      _loser = map['loser'] ?? '';
      _teamAScore = map['teamAScore'] ?? '';
      _teamBScore = map['teamBScore'] ?? '';
      _date = map['date'] ?? '';
      _startTime = map['startTime'] ?? '';
      _endTime = map['endTime'] ?? '';
      _hasCompleted = map['hasCompleted'] ?? false;
      _resultList = map['resultList'].cast<String>().toList() ?? [];
    } else {
      throw ArgumentError('Required keys are missing from the User model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'tournamentId': _tournamentId,
      'matchId': _matchId,
      'nextMatchId': _nextMatchId,
      'game': _game,
      'round': _round,
      'match': _match,
      'teamA': _teamA,
      'teamB': _teamB,
      'winner': _winner,
      'loser': _loser,
      'teamAScore': _teamAScore,
      'teamBScore': _teamBScore,
      'date': _date,
      'startTime': _startTime,
      'endTime': _endTime,
      'hasCompleted': _hasCompleted,
      'resultList': _resultList,
    };
  }

  ValorantMatch copyWith(Map<String, dynamic> map) {
    return ValorantMatch.fromJson(map);
  }
}
