import 'package:esports_battlefield_arena/models/invoice.dart';
import 'package:stacked/stacked.dart';

class PaymentHistoryViewModel extends BaseViewModel {
  // List<Invoice> _invoiceList = [];

  List<Invoice> _unpaidInvoiceList = [];

  List<Invoice> _invoiceList = [
    Invoice(
      invoiceId: '1',
      date: '12/12/2020',
      time: '12:00 PM',
      amount: 100,
      paidBy: '',
    ),
    Invoice(
      invoiceId: '2',
      date: '12/12/2020',
      time: '12:00 PM',
      amount: 100,
      paidBy: '',
    ),
  ];

  final List<Invoice> _paidInvoiceList = [
    Invoice(
      invoiceId: '3',
      date: '12/12/2020',
      time: '12:00 PM',
      amount: 100,
      paidBy: 'Paid',
    ),
    Invoice(
      invoiceId: '4',
      date: '12/12/2020',
      time: '12:00 PM',
      amount: 100,
      paidBy: 'Paid',
    ),
    Invoice(
      invoiceId: '5',
      date: '12/12/2020',
      time: '12:00 PM',
      amount: 100,
      paidBy: 'Paid',
    ),
  ];

  bool _isSelectedUpcoming = true;

  List<Invoice> get invoiceList => _invoiceList;
  bool get isSelectedUpcoming => _isSelectedUpcoming;

  Future<void> refreshInvoiceList() {
    return Future.delayed(const Duration(seconds: 2));
  }

  onButtonAllTap() {
    _isSelectedUpcoming = false;
    _unpaidInvoiceList = [..._invoiceList];
    _invoiceList = [..._invoiceList, ..._paidInvoiceList];
    notifyListeners();
  }

  onButtonUpcomingTap() {
    _isSelectedUpcoming = true;
    _invoiceList = [..._unpaidInvoiceList];
    notifyListeners();
  }
}
