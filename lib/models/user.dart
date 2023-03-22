class User {
  late String _userId;
  late String _country;
  late String _email;
  late String _password;
  late String _address;
  late String _role;

  String get userId => _userId;
  String get country => _country;
  String get email => _email;
  String get password => _password;
  String get address => _address;
  String get role => _role;

  User(
      {String userId = '',
      String country = '',
      String email = '',
      String password = '',
      String address = '',
      String role = ''})
      : _userId = userId,
        _country = country,
        _email = email,
        _password = password,
        _address = address,
        _role = role;

  User.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('userId') &&
        map.containsKey('country') &&
        map.containsKey('email') &&
        map.containsKey('password') &&
        map.containsKey('address') &&
        map.containsKey('role')) {
      _userId = map['userId'] ?? '';
      _country = map['country'] ?? '';
      _email = map['email'] ?? '';
      _password = map['password'] ?? '';
      _address = map['address'] ?? '';
      _role = map['role'] ?? '';
    } else {
      throw ArgumentError('Required keys are missing from the User model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': _userId,
      'country': _country,
      'email': _email,
      'password': _password,
      'address': _address,
      'role': _role,
    };
  }

  User copyWith(Map<String, dynamic> map) {
    return User.fromJson(map);
  }
}
