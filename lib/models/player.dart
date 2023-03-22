class Player {
  late String _userId;
  late String _firstName;
  late String _lastName;

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get userId => _userId;

  Player({
    String userId = '',
    String firstName = '',
    String lastName = '',
  })  : _userId = userId,
        _firstName = firstName,
        _lastName = lastName;

  Player.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('userId') &&
        map.containsKey('firstName') &&
        map.containsKey('lastName')) {
      _userId = map['userId'] ?? '';
      _firstName = map['firstName'] ?? '';
      _lastName = map['lastName'] ?? '';
    } else {
      throw ArgumentError('Required keys are missing from the User model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': _userId,
      'firstName': _firstName,
      'lastName': _lastName,
    };
  }

  Player copyWith(Map<String, dynamic> map) {
    return Player.fromJson(map);
  }
}
