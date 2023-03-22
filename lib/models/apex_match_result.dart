class ApexMatchResult {
  late String _resultId;
  late String _matchId;
  late String _participantId;
  late int _kills;
  late int _placement;

  String get resultId => _resultId;
  String get matchId => _matchId;
  String get participantId => _participantId;
  int get kills => _kills;
  int get placement => _placement;

  ApexMatchResult({
    String resultId = '',
    String matchId = '',
    String participantId = '',
    int kills = 0,
    int placement = 0,
  })  : _resultId = resultId,
        _matchId = matchId,
        _participantId = participantId,
        _kills = kills,
        _placement = placement;

  ApexMatchResult.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('resultId') &&
        map.containsKey('matchId') &&
        map.containsKey('participantId') &&
        map.containsKey('kills') &&
        map.containsKey('placement')) {
      _resultId = map['resultId'] ?? '';
      _matchId = map['matchId'] ?? '';
      _participantId = map['participantId'] ?? '';
      _kills = map['kills'] ?? 0;
      _placement = map['placement'] ?? 0;
    } else {
      throw ArgumentError('Required keys are missing from the User model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'resultId': _resultId,
      'matchId': _matchId,
      'participantId': _participantId,
      'kills': _kills,
      'placement': _placement,
    };
  }

  ApexMatchResult copyWith(Map<String, dynamic> map) {
    return ApexMatchResult.fromJson(map);
  }
}
