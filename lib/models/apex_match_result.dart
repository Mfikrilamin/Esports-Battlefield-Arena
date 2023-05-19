class ApexMatchResult {
  late String _resultId;
  late String _matchId;
  late List<Map<String, dynamic>> _results;
  // late String _participantId;
  // late int _kills;
  // late int _placement;
  // late int _point;

  String get resultId => _resultId;
  String get matchId => _matchId;
  List<Map<String, dynamic>> get results => _results;
  // String get participantId => _participantId;
  // int get kills => _kills;
  // int get placement => _placement;
  // int get point => _point;

  ApexMatchResult({
    String resultId = '',
    String matchId = '',
    List<Map<String, dynamic>> results = const [],
    // String participantId = '',
    // int kills = 0,
    // int placement = 0,
    // int point = 0,
  })  : _resultId = resultId,
        _matchId = matchId,
        _results = results;
  // _participantId = participantId,
  // _kills = kills,
  // _placement = placement,
  // _point = point;

  ApexMatchResult.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('resultId') &&
            map.containsKey('matchId') &&
            map.containsKey('resultList')
        // map.containsKey('participantId') &&
        // map.containsKey('kills') &&
        // map.containsKey('placement') &&
        // map.containsKey('point')
        ) {
      _resultId = map['resultId'] ?? '';
      _matchId = map['matchId'] ?? '';
      _results = map['resultList'] ?? [];
      // _participantId = map['participantId'] ?? '';
      // _kills = map['kills'] ?? 0;
      // _placement = map['placement'] ?? 0;
      // _point = map['point'] ?? 0;
    } else {
      throw ArgumentError('Required keys are missing from the User model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'resultId': _resultId,
      'matchId': _matchId,
      'resultList': _results,
      // 'participantId': _participantId,
      // 'kills': _kills,
      // 'placement': _placement,
      // 'point': _point,
    };
  }

  ApexMatchResult copyWith(Map<String, dynamic> map) {
    return ApexMatchResult.fromJson(map);
  }
}
