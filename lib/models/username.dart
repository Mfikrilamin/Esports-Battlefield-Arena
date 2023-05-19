class Username {
  late String _userId;
  late String _username;
  late String _usernameId;

  String get userId => _userId;
  String get username => _username;
  String get usernameId => _usernameId;

  Username({
    String userId = '',
    String username = '',
    String usernameId = '',
  })  : _userId = userId,
        _username = username,
        _usernameId = usernameId;

  Username.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('userId') &&
        map.containsKey('username') &&
        map.containsKey('usernameId')) {
      _userId = map['userId'] ?? '';
      _username = map['username'] ?? '';
      _usernameId = map['usernameId'] ?? '';
    } else {
      throw ArgumentError('Required keys are missing from the Nickname model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': _userId,
      'username': _username,
      'usernameId': _usernameId,
    };
  }

  Username copyWith(Map<String, dynamic> map) {
    return Username.fromJson(map);
  }
}
