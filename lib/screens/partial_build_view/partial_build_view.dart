import 'package:esports_battlefield_arena/screens/partial_build_view/partial_build_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class PartialBuildsView extends StatelessWidget {
  const PartialBuildsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //This will make the builder get call once
    //Only built once and not rebuilt if notifyListeners is called
    return ViewModelBuilder<PartialBuildViewModel>.nonReactive(
      viewModelBuilder: () => PartialBuildViewModel(),
      builder: (context, model, child) {
        print('Rebuilding the PartialBuildsView');
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: const <Widget>[
              _StringForm(),
              _TitleAndValue(),
            ],
          ),
        );
      },
    );
  }
}

class _StringForm extends StackedHookView<PartialBuildViewModel> {
  const _StringForm({Key? key}) : super(key: key, reactive: false);

  @override
  Widget builder(BuildContext context, PartialBuildViewModel model) {
    print('Rebuilding the String Form ');
    var text = useTextEditingController();
    return TextField(
      controller: text,
      onChanged: model.updateString,
    );
  }
}

class _TitleAndValue extends ViewModelWidget<PartialBuildViewModel> {
  const _TitleAndValue({Key? key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, PartialBuildViewModel viewModel) {
    print('Rebuilding the Title and Value');
    return Column(
      children: [
        Text(
          viewModel.title ?? 'No title',
          style: const TextStyle(fontSize: 40),
        )
      ],
    );
  }
}
