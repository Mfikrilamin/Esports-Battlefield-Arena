class Invoice {
  late String _invoiceId;
  late double _amount;
  late String _date;
  late String _time;
  //User or participant who paid
  late String _paidBy;

  String get invoiceId => _invoiceId;
  double get amount => _amount;
  String get date => _date;
  String get time => _time;
  String get paidBy => _paidBy;

  Invoice({
    String invoiceId = '',
    double amount = 0.0,
    String date = '',
    String time = '',
    String paidBy = '',
  })  : _invoiceId = invoiceId,
        _amount = amount,
        _date = date,
        _time = time,
        _paidBy = paidBy;

  Invoice.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('invoiceId') &&
        map.containsKey('amount') &&
        map.containsKey('date') &&
        map.containsKey('time') &&
        map.containsKey('paidBy')) {
      _invoiceId = map['invoiceId'] ?? '';
      _amount = map['amount'] ?? 0.0;
      _date = map['date'] ?? '';
      _time = map['time'] ?? '';
      _paidBy = map['paidBy'] ?? '';
    } else {
      throw ArgumentError('Required keys are missing from the User model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceId': _invoiceId,
      'amount': _amount,
      'date': _date,
      'time': _time,
      'paidBy': _paidBy,
    };
  }

  Invoice copyWith(Map<String, dynamic> map) {
    return Invoice.fromJson(map);
  }
}
