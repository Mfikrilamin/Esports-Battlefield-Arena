import 'package:stacked/stacked.dart';

class FutureExampleViewModel extends FutureViewModel<String> {
  Future<String> getDataFromServer() async {
    await Future.delayed(Duration(seconds: 2));
    throw Exception('Error getting data from server');
  }

  @override
  Future<String> futureToRun() => getDataFromServer();

  @override
  void onError(error) {
    // super.onError(error);
  }
}
