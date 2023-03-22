import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  String _title = 'Home View';
  int _counter = 0;

  int get counter => _counter;
  String get title => '$_title $_counter';

  void updateTitle() {
    _title = 'New Title';
    notifyListeners();
  }

  void updateCounter() {
    _counter++;
    notifyListeners();
  }
}
