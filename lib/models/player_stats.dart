class PlayerStats {
  late String _playerStatsId;
  late String _participantId;
  late String _username;
  late String _playerId;
  late String _matchId;
  late String _resultId;
  late int _kills;
  late int _assists;
  late int _deaths;

  String get playerStatsId => _playerStatsId;
  String get participantId => _participantId;
  String get username => _username;
  String get playerId => _playerId;
  String get matchId => _matchId;
  String get resultId => _resultId;
  int get kills => _kills;
  int get assists => _assists;
  int get deaths => _deaths;

  PlayerStats({
    String playerStatsId = '',
    String participantId = '',
    String username = '',
    String playerId = '',
    String matchId = '',
    String resultId = '',
    int kills = 0,
    int assists = 0,
    int deaths = 0,
  })  : _playerStatsId = playerStatsId,
        _participantId = participantId,
        _username = username,
        _playerId = playerId,
        _matchId = matchId,
        _resultId = resultId,
        _kills = kills,
        _assists = assists,
        _deaths = deaths;

  PlayerStats.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('playerStatsId') &&
        map.containsKey('participantId') &&
        map.containsKey('username') &&
        map.containsKey('playerId') &&
        map.containsKey('matchId') &&
        map.containsKey('resultId') &&
        map.containsKey('kills') &&
        map.containsKey('assists') &&
        map.containsKey('deaths')) {
      _playerStatsId = map['playerStatsId'] ?? '';
      _participantId = map['participantId'] ?? '';
      _username = map['username'] ?? '';
      _playerId = map['playerId'] ?? '';
      _matchId = map['matchId'] ?? '';
      _resultId = map['resultId'] ?? '';
      _kills = map['kills'] ?? '';
      _assists = map['assists'] ?? '';
      _deaths = map['deaths'] ?? '';
    } else {
      throw ArgumentError('Required keys are missing from the User model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'playerStatsId': _playerStatsId,
      'participantId': _participantId,
      'username': _username,
      'playerId': _playerId,
      'matchId': _matchId,
      'resultId': _resultId,
      'kills': _kills,
      'assists': _assists,
      'deaths': _deaths,
    };
  }

  PlayerStats copyWith(Map<String, dynamic> map) {
    return PlayerStats.fromJson(map);
  }
}
