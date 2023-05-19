class TournamentParticipant {
  late String _participantId;
  late String _dateRegister;
  late String _tournamentId;
  // late String _participatedBy;
  late String _teamName;
  late String _country;
  late List<dynamic> _memberList;
  late List<dynamic> _usernameList;
  late int _seeding;
  //Check whether the team participant register as a solo or team
  late bool _isSolo;
  //Indicator flag to check if the participant has pay the fee
  late bool _hasPay;

  String get participantId => _participantId;
  String get dateRegister => _dateRegister;
  String get tournamentId => _tournamentId;
  // String get participatedBy => _participatedBy;
  String get teamName => _teamName;
  String get country => _country;
  List<dynamic> get memberList => _memberList;
  List<dynamic> get usernameList => _usernameList;
  int get seeding => _seeding;
  bool get isSolo => _isSolo;
  bool get hasPay => _hasPay;

  TournamentParticipant({
    String participantId = '',
    String dateRegister = '',
    String tournamentId = '',
    // String participatedBy = '',
    String teamName = '',
    String country = '',
    List<dynamic> memberList = const [],
    List<dynamic> usernameList = const [],
    int seeding = 0,
    bool isSolo = false,
    bool hasPay = false,
  })  : _participantId = participantId,
        _dateRegister = dateRegister,
        _tournamentId = tournamentId,
        // _participatedBy = participatedBy,
        _teamName = teamName,
        _country = country,
        _usernameList = usernameList,
        _memberList = memberList,
        _seeding = seeding,
        _isSolo = isSolo,
        _hasPay = hasPay;

  TournamentParticipant.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('participantId') &&
        map.containsKey('dateRegister') &&
        map.containsKey('tournamentId') &&
        // map.containsKey('participatedBy') &&
        map.containsKey('teamName') &&
        map.containsKey('country') &&
        map.containsKey('memberList') &&
        map.containsKey('usernameList') &&
        map.containsKey('seeding') &&
        map.containsKey('isSolo') &&
        map.containsKey('hasPay')) {
      _participantId = map['participantId'];
      _dateRegister = map['dateRegister'];
      _tournamentId = map['tournamentId'];
      // _participatedBy = map['participatedBy'];
      _teamName = map['teamName'];
      _country = map['country'];
      _memberList = map['memberList'];
      _usernameList = map['usernameList'];
      _seeding = map['seeding'];
      _isSolo = map['isSolo'];
      _hasPay = map['hasPay'];
    } else {
      throw ArgumentError('Required keys are missing from the User model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'participantId': _participantId,
      'dateRegister': _dateRegister,
      'tournamentId': _tournamentId,
      // 'participatedBy': _participatedBy,
      'teamName': _teamName,
      'country': _country,
      'memberList': _memberList,
      'usernameList': _usernameList,
      'seeding': _seeding,
      'isSolo': _isSolo,
      'hasPay': _hasPay,
    };
  }

  TournamentParticipant copyWith(Map<String, dynamic> map) {
    return TournamentParticipant.fromJson(map);
  }
}
