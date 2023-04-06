import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:rive/rive.dart';

class RiveAsset {
  final String src;
  final String artBoard;
  final String stateMachineName;
  MenuState? state;
  late SMIBool? input;

  RiveAsset(this.src,
      {required this.artBoard,
      required this.stateMachineName,
      this.state,
      this.input});

  set setInput(SMIBool status) {
    input = status;
  }
}

class RiveUtils {
  StateMachineController getRiveController(Artboard artboard,
      {stateMachineName = 'State Machine 1'}) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, stateMachineName);
    artboard.addController(controller!);
    return controller;
  }
}
