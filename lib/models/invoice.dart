class Invoice {
  late String _invoiceId;
  late double _amountPaid;
  late String _datePaid;
  late String _timePaid;
  //User or participant who paid
  late String _paidBy;

  String get invoiceId => _invoiceId;
  double get amountPaid => _amountPaid;
  String get datePaid => _datePaid;
  String get timePaid => _timePaid;
  String get paidBy => _paidBy;

  Invoice({
    String invoiceId = '',
    double amountPaid = 0.0,
    String datePaid = '',
    String timePaid = '',
    String paidBy = '',
  })  : _invoiceId = invoiceId,
        _amountPaid = amountPaid,
        _datePaid = datePaid,
        _timePaid = timePaid,
        _paidBy = paidBy;

  Invoice.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('invoiceId') &&
        map.containsKey('amountPaid') &&
        map.containsKey('datePaid') &&
        map.containsKey('timePaid') &&
        map.containsKey('paidBy')) {
      _invoiceId = map['invoiceId'] ?? '';
      _amountPaid = map['amountPaid'] ?? 0.0;
      _datePaid = map['datePaid'] ?? '';
      _timePaid = map['timePaid'] ?? '';
      _paidBy = map['paidBy'] ?? '';
    } else {
      throw ArgumentError('Required keys are missing from the User model');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceId': _invoiceId,
      'amountPaid': _amountPaid,
      'datePaid': _datePaid,
      'timePaid': _timePaid,
      'paidBy': _paidBy,
    };
  }

  Invoice copyWith(Map<String, dynamic> map) {
    return Invoice.fromJson(map);
  }
}
