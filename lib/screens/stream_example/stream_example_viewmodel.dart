import 'package:stacked/stacked.dart';

class StreamExampleViewModel extends StreamViewModel<int> {
  String get title => 'Stream Example in seconds \n $data';
  bool _otherSources = false;

  @override
  Stream<int> get stream =>
      _otherSources ? epochUpdates() : epochUpdatesFaster();

  void swapSources() {
    _otherSources = !_otherSources;
    notifySourceChanged();
  }

  Stream<int> epochUpdates() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield DateTime.now().millisecondsSinceEpoch;
    }
  }

  Stream<int> epochUpdatesFaster() async* {
    while (true) {
      await Future.delayed(const Duration(microseconds: 1));
      yield DateTime.now().millisecondsSinceEpoch;
    }
  }
}
