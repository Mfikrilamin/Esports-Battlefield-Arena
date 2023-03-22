class Organizer {
  late String _userId;
  late String _organizerName;

  String get organizerName => _organizerName;
  String get userId => _userId;

  Organizer({
    String userId = '',
    String organizerName = '',
  })  : _organizerName = organizerName,
        _userId = userId;

  Organizer.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('userId') && map.containsKey('organizerName')) {
      _userId = map['userId'] ?? '';
      _organizerName = map['organizerName'] ?? '';
    } else {
      throw ArgumentError('Required keys are missing from the User model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': _userId,
      'organizerName': _organizerName,
    };
  }

  Organizer copyWith(Map<String, dynamic> map) {
    return Organizer.fromJson(map);
  }
}
