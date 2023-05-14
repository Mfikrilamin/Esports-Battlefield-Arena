class Invoice {
  late String _invoiceId;
  late String _tournamentId;
  late double _amount;
  late String _date;
  late String _time;
  late bool _paidCompleted;
  //User or participant who paid
  late String _paidBy;
  // Invoice belongs to which participant
  late String _belongsTo;

  String get invoiceId => _invoiceId;
  String get tournamentId => _tournamentId;
  double get amount => _amount;
  String get date => _date;
  String get time => _time;
  String get paidBy => _paidBy;
  bool get isPaid => _paidCompleted;
  String get belongsTo => _belongsTo;

  Invoice({
    String invoiceId = '',
    String tournamentId = '',
    double amount = 0.0,
    String date = '',
    String time = '',
    String paidBy = '',
    bool paidCompleted = false,
    String belongsTo = '',
  })  : _invoiceId = invoiceId,
        _tournamentId = tournamentId,
        _amount = amount,
        _date = date,
        _time = time,
        _paidBy = paidBy,
        _paidCompleted = paidCompleted,
        _belongsTo = belongsTo;

  Invoice.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('invoiceId') &&
        map.containsKey('tournamentId') &&
        map.containsKey('amount') &&
        map.containsKey('date') &&
        map.containsKey('time') &&
        map.containsKey('paidBy') &&
        map.containsKey('paidCompleted') &&
        map.containsKey('belongsTo')) {
      _invoiceId = map['invoiceId'] ?? '';
      _tournamentId = map['tournamentId'] ?? '';
      _amount = map['amount'] ?? 0.0;
      _date = map['date'] ?? '';
      _time = map['time'] ?? '';
      _paidBy = map['paidBy'] ?? '';
      _paidCompleted = map['paidCompleted'] ?? false;
      _belongsTo = map['belongsTo'] ?? '';
    } else {
      throw ArgumentError('Required keys are missing from the Invoice model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceId': _invoiceId,
      'tournamentId': _tournamentId,
      'amount': _amount,
      'date': _date,
      'time': _time,
      'paidBy': _paidBy,
      'paidCompleted': _paidCompleted,
      'belongsTo': _belongsTo,
    };
  }

  Invoice copyWith(Map<String, dynamic> map) {
    return Invoice.fromJson(map);
  }
}
