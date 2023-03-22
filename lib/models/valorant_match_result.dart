class ValorantMatchResult {
  late String _resultId;
  late String _matchId;
  late String _participantId;
  late int _roundWon;
  late bool _isWinner;

  String get resultId => _resultId;
  String get matchId => _matchId;
  String get participantId => _participantId;
  int get roundWon => _roundWon;
  bool get isWinner => _isWinner;

  ValorantMatchResult({
    String resultId = '',
    String matchId = '',
    String participantId = '',
    int roundWon = 0,
    bool isWinner = false,
  })  : _resultId = resultId,
        _matchId = matchId,
        _participantId = participantId,
        _roundWon = roundWon,
        _isWinner = isWinner;

  ValorantMatchResult.fromJson(Map<String, dynamic> map){
    if (map.containsKey('resultId') &&
        map.containsKey('matchId') &&
        map.containsKey('participantId') &&
        map.containsKey('roundWon') &&
        map.containsKey('isWinner')) {
      _resultId = map['resultId'] ?? '';
      _matchId = map['matchId'] ?? '';
      _participantId = map['participantId'] ?? '';
      _roundWon = map['roundWon'] ?? 0;
      _isWinner = map['isWinner'] ?? false;
    } else {
      throw ArgumentError('Required keys are missing from the User model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'resultId': _resultId,
      'matchId': _matchId,
      'participantId': _participantId,
      'roundWon': _roundWon,
      'isWinner': _isWinner,
    };
  }

  ValorantMatchResult copyWith(Map<String, dynamic> map) {
    return ValorantMatchResult.fromJson(map);
  }
}
