class Team {
  late String _teamId;
  late String _teamName;
  late String _teamCountry;
  late List<String> _memberList;

  String get teamName => _teamName;
  String get teamId => _teamId;

  Team({
    String teamId = '',
    String teamName = '',
    String teamCountry = '',
    List<String> memberList = const [],
  })  : _teamId = teamId,
        _teamName = teamName,
        _teamCountry = teamCountry,
        _memberList = memberList;

  Team.fromJson(Map<String, dynamic> map){
    if (map.containsKey('teamId') &&
        map.containsKey('teamName') &&
        map.containsKey('teamCountry') &&
        map.containsKey('memberList')) {
      _teamId = map['teamId'] ?? '';
      _teamName = map['teamName'] ?? '';
      _teamCountry = map['teamCountry'] ?? '';
      _memberList = map['memberList'] ?? [];
    } else {
      throw ArgumentError('Required keys are missing from the User model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'teamId': _teamId,
      'teamName': _teamName,
      'teamCountry': _teamCountry,
      'memberList': _memberList,
    };
  }

  Team copyWith(Map<String, dynamic> map) {
    return Team.fromJson(map);
  }
}
