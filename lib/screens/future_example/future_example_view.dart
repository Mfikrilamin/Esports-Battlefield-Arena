import 'package:esports_battlefield_arena/screens/future_example/future_example_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class FutureExampleView extends StatelessWidget {
  const FutureExampleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //This will make the builder get call once
    //Only built once and not rebuilt if notifyListeners is called
    return ViewModelBuilder<FutureExampleViewModel>.reactive(
      viewModelBuilder: () => FutureExampleViewModel(),
      builder: (context, model, child) {
        print('Rebuilding the FutureExampleView');
        return Scaffold(
          body:
              // model.hasError
              //     ? Container(
              //         color: Colors.red,
              //         alignment: Alignment.center,
              //         child: Text(
              //           'An error occured: ${model.modelError}',
              //           style: const TextStyle(color: Colors.white, fontSize: 25),
              //         ),
              //       )
              //     :
              Center(
            child: (model.isBusy
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(model.data ?? 'No data'),
                      const _ErrorMessage(),
                    ],
                  )),
          ),
        );
      },
    );
  }
}

class _ErrorMessage extends ViewModelWidget<FutureExampleViewModel> {
  const _ErrorMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, FutureExampleViewModel viewModel) {
    return viewModel.hasError
        ? Container(
            color: Colors.red,
            alignment: Alignment.center,
            child: Text(
              'An error occured: ${viewModel.modelError}',
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
          )
        : Container();
  }
}
