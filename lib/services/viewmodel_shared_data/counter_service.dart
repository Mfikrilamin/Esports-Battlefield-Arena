
import 'package:stacked/stacked.dart';
// import 'package:observable_ish/observable_ish.dart';

class CounterService with ReactiveServiceMixin {
  CounterService() {
    listenToReactiveValues([_counter]);
  }
  ReactiveValue<int> _counter = ReactiveValue<int>(0);
  int get counter => _counter.value;

  void incrementCounter() {
    _counter.value++;
  }

  void doubleCounter() {
    _counter.value = _counter.value * 2;
  }
}
