class Nickname {
  late String _userId;
  late String _nickName;

  String get nickName => _nickName;
  String get userId => _userId;

  Nickname({
    String nickName = '',
    String userId = '',
  })  : _nickName = nickName,
        _userId = userId;

  Nickname.fromJson(Map<String, dynamic> map){
    if (map.containsKey('nickName') && map.containsKey('userId')) {
      _nickName = map['nickName'] ?? '';
      _userId = map['userId'] ?? '';
    } else {
      throw ArgumentError('Required keys are missing from the User model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'nickName': _nickName,
      'userId': _userId,
    };
  }

  Nickname copyWith(Map<String, dynamic> map) {
    return Nickname.fromJson(map);
  }
}
