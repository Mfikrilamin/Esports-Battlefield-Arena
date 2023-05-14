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
  late String _paymentReferenceId;

  String get invoiceId => _invoiceId;
  String get tournamentId => _tournamentId;
  double get amount => _amount;
  String get date => _date;
  String get time => _time;
  String get paidBy => _paidBy;
  bool get isPaid => _paidCompleted;
  String get belongsTo => _belongsTo;
  String get paymentReferenceId => _paymentReferenceId;

  Invoice({
    String invoiceId = '',
    String tournamentId = '',
    double amount = 0.0,
    String date = '',
    String time = '',
    String paidBy = '',
    bool paidCompleted = false,
    String belongsTo = '',
    String paymentReferenceId = '',
  })  : _invoiceId = invoiceId,
        _tournamentId = tournamentId,
        _amount = amount,
        _date = date,
        _time = time,
        _paidBy = paidBy,
        _paidCompleted = paidCompleted,
        _belongsTo = belongsTo,
        _paymentReferenceId = paymentReferenceId;

  Invoice.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('invoiceId') &&
        map.containsKey('tournamentId') &&
        map.containsKey('amount') &&
        map.containsKey('date') &&
        map.containsKey('time') &&
        map.containsKey('paidBy') &&
        map.containsKey('paidCompleted') &&
        map.containsKey('belongsTo') &&
        map.containsKey('paymentReferenceId')) {
      _invoiceId = map['invoiceId'] ?? '';
      _tournamentId = map['tournamentId'] ?? '';
      _amount = map['amount'] ?? 0.0;
      _date = map['date'] ?? '';
      _time = map['time'] ?? '';
      _paidBy = map['paidBy'] ?? '';
      _paidCompleted = map['paidCompleted'] ?? false;
      _belongsTo = map['belongsTo'] ?? '';
      _paymentReferenceId = map['paymentReferenceId'] ?? '';
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
      'paymentReferenceId': _paymentReferenceId,
    };
  }

  Invoice copyWith(Map<String, dynamic> map) {
    return Invoice.fromJson(map);
  }
}
