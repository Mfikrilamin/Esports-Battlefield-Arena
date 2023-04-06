import 'package:esports_battlefield_arena/components/animation/widgets/button_animation.dart';
import 'package:esports_battlefield_arena/screens/testing/testing_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class TestingView extends StatelessWidget {
  // static Route route() => MaterialPageRoute(builder: (_) => const HomeView());
  const TestingView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TestingViewModel>.reactive(
      viewModelBuilder: () => TestingViewModel(),
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(model.title),
              const ButtonAnimation(
                  textBefore: "before click",
                  textAfter: "after click",
                  iconBefore: Icon(Icons.send),
                  iconAfter: Icon(Icons.done)),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            model.navigateToPreviousPage();
          },
        ),
      ),
    );
  }
}
