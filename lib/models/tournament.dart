class Tournament {
  late String _tournamentId;
  late String _title;
  late String _rules;
  late String _description;
  late double _prizePool;
  late String _startDate;
  late String _endDate;
  late int _maxParticipants;
  late String _maxMemberPerTeam;
  late String _organizerId;
  //Store all the matchId in the tournament
  late List<String> _matchList;
  //Store teamId that has register in the tournament
  late List<String> _currentParticipant;
  //Type of tournament, solo or team
  late bool _isSolo;

  String get tournamentId => _tournamentId;
  String get title => _title;
  String get rules => _rules;
  String get description => _description;
  double get prizePool => _prizePool;
  String get startDate => _startDate;
  String get endDate => _endDate;
  String get organizerId => _organizerId;
  int get maxParticipants => _maxParticipants;
  String get maxMemberPerTeam => _maxMemberPerTeam;
  List<String> get matchList => _matchList;
  List<String> get currentParticipant => _currentParticipant;
  bool get isSolo => _isSolo;

  Tournament({
    String tournamentId = '',
    String title = '',
    String rules = '',
    String description = '',
    double prizePool = 0.0,
    String startDate = '',
    String endDate = '',
    int maxParticipants = 0,
    String maxMemberPerTeam = '',
    String organizerId = '',
    List<String> matchList = const [],
    List<String> currentParticipant = const [],
    bool isSolo = false,
  })  : _tournamentId = tournamentId,
        _title = title,
        _rules = rules,
        _description = description,
        _prizePool = prizePool,
        _startDate = startDate,
        _endDate = endDate,
        _maxParticipants = maxParticipants,
        _maxMemberPerTeam = maxMemberPerTeam,
        _organizerId = organizerId,
        _matchList = matchList,
        _currentParticipant = currentParticipant,
        _isSolo = isSolo;

  Tournament.fromJson(Map<String, dynamic> map){
    if (map.containsKey('tournamentId') &&
        map.containsKey('title') &&
        map.containsKey('rules') &&
        map.containsKey('description') &&
        map.containsKey('prizePool') &&
        map.containsKey('startDate') &&
        map.containsKey('endDate') &&
        map.containsKey('maxParticipants') &&
        map.containsKey('maxMemberPerTeam') &&
        map.containsKey('organizerId') &&
        map.containsKey('matchList') &&
        map.containsKey('currentParticipant') &&
        map.containsKey('isSolo')) {
      _tournamentId = map['tournamentId'] ?? '';
      _title = map['title'] ?? '';
      _rules = map['rules'] ?? '';
      _description = map['description'] ?? '';
      _prizePool = map['prizePool'] ?? 0.0;
      _startDate = map['startDate'] ?? '';
      _endDate = map['endDate'] ?? '';
      _maxParticipants = map['maxParticipants'] ?? 0;
      _maxMemberPerTeam = map['maxMemberPerTeam'] ?? '';
      _organizerId = map['organizerId'] ?? '';
      _matchList = map['matchList'] ?? [];
      _currentParticipant = map['currentParticipant'] ?? [];
      _isSolo = map['isSolo'] ?? false;
    } else {
      throw ArgumentError('Required keys are missing from the User model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'tournamentId': _tournamentId,
      'title': _title,
      'rules': _rules,
      'description': _description,
      'prizePool': _prizePool,
      'startDate': _startDate,
      'endDate': _endDate,
      'maxParticipants': _maxParticipants,
      'maxMemberPerTeam': _maxMemberPerTeam,
      'organizerId': _organizerId,
      'matchList': _matchList,
      'currentParticipant': _currentParticipant,
      'isSolo': _isSolo,
    };
  }

  Tournament copyWith(Map<String, dynamic> map) {
    return Tournament.fromJson(map);
  }
}
