class PlayerStats {
  late String _playerId;
  late String _matchId;
  late int _kills;
  late int _assists;
  late int _deaths;

  String get playerId => _playerId;
  String get matchId => _matchId;
  int get kills => _kills;
  int get assists => _assists;
  int get deaths => _deaths;

  PlayerStats({
    String playerId = '',
    String matchId = '',
    int kills = 0,
    int assists = 0,
    int deaths = 0,
  })  : _playerId = playerId,
        _matchId = matchId,
        _kills = kills,
        _assists = assists,
        _deaths = deaths;

  PlayerStats.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('playerId') &&
        map.containsKey('matchId') &&
        map.containsKey('kills') &&
        map.containsKey('assists') &&
        map.containsKey('deaths')) {
      _playerId = map['playerId'] ?? '';
      _matchId = map['matchId'] ?? '';
      _kills = map['kills'] ?? '';
      _assists = map['assists'] ?? '';
      _deaths = map['deaths'] ?? '';
    } else {
      throw ArgumentError('Required keys are missing from the User model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'playerId': _playerId,
      'matchId': _matchId,
      'kills': _kills,
      'assists': _assists,
      'deaths': _deaths,
    };
  }

  PlayerStats copyWith(Map<String, dynamic> map) {
    return PlayerStats.fromJson(map);
  }
}
