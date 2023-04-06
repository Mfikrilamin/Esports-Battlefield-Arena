import 'package:esports_battlefield_arena/screens/stream_example/stream_example_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class StreamExampleView extends StatelessWidget {
  const StreamExampleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //This will make the builder get call once
    //Only built once and not rebuilt if notifyListeners is called
    return ViewModelBuilder<StreamExampleViewModel>.reactive(
      viewModelBuilder: () => StreamExampleViewModel(),
      builder: (context, model, child) {
        print('Rebuilding the StreamExampleView');
        return Scaffold(
          body: Center(
            child: Text(model.title),
          ),
          floatingActionButton:
              FloatingActionButton(onPressed: model.swapSources),
        );
      },
    );
  }
}
