import 'package:stacked/stacked.dart';

class ReactiveViewModel extends BaseViewModel {
  String? _title;
  String? get title => _title;
  void updateString(String value) {
    _title = value;
    notifyListeners();
  }
}
