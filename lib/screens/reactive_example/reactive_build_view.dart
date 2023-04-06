import 'package:esports_battlefield_arena/screens/smart_widgets/double_increase_counter.dart';
import 'package:esports_battlefield_arena/screens/smart_widgets/single_increase_counter.dart';
import 'package:flutter/material.dart';

class ReactiveView extends StatelessWidget {
  const ReactiveView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: const [
            SingleIncreaseCounter(),
            SizedBox(width: 50),
            DoubleIncreaseCounter(),
          ],
        ),
      ),
    );
  }
}
