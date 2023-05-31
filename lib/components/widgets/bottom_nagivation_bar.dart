import 'package:esports_battlefield_arena/screens/home/home_viewmodel.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/box_text.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:esports_battlefield_arena/utils/rive_utils.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class CustomBottomNavigationBar extends StackedHookView<HomeViewModel> {
  final bool isPlayer;
  const CustomBottomNavigationBar(this.isPlayer, {Key? key})
      : super(key: key, reactive: true);

  @override
  Widget builder(BuildContext context, HomeViewModel model) {
    return SafeArea(
      child: Material(
        elevation: 3,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...List.generate(
                isPlayer ? bottomNavs.length : organizerbottomNavs.length,
                (index) => GestureDetector(
                  onTap: () {
                    isPlayer
                        ? bottomNavs[index].input!.change(true)
                        : organizerbottomNavs[index].input!.change(true);
                    if (index != model.selectedIndex) {
                      model.onNavigateBarTapped(index);
                    }
                    Future.delayed(const Duration(seconds: 1), () {
                      isPlayer
                          ? bottomNavs[index].input!.change(false)
                          : organizerbottomNavs[index].input!.change(false);
                      // model.navigateBasedOnBottomBar();
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBar(
                        isActive: index == model.selectedIndex,
                      ),
                      SizedBox(
                        height: 36,
                        width: 36,
                        child: Opacity(
                          opacity: model.selectedIndex == index ? 1 : 0.5,
                          child: !model.isBusy
                              ? RiveAnimation.asset(
                                  isPlayer
                                      ? bottomNavs.first.src
                                      : organizerbottomNavs.first.src,
                                  artboard: isPlayer
                                      ? bottomNavs[index].artBoard
                                      : organizerbottomNavs[index].artBoard,
                                  onInit: (artboard) {
                                    RiveUtils riveUtils = RiveUtils();
                                    StateMachineController controller =
                                        riveUtils.getRiveController(artboard,
                                            stateMachineName: isPlayer
                                                ? bottomNavs[index]
                                                    .stateMachineName
                                                : organizerbottomNavs[index]
                                                    .stateMachineName);
                                    if (isPlayer == true) {
                                      bottomNavs[index].input = controller
                                          .findSMI("active") as SMIBool;
                                    } else {
                                      organizerbottomNavs[index].input =
                                          controller.findSMI("active")
                                              as SMIBool;
                                    }
                                  },
                                )
                              : const CircularProgressIndicator(),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        child: BoxText.caption(isPlayer
                            ? bottomNavs[index].state!.name
                            : organizerbottomNavs[index].state!.name),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: BoxDecoration(
          color: isActive ? kcPrimaryDarkerColor : Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }
}

List<RiveAsset> bottomNavs = [
  RiveAsset('assets/RiveAssets/animated-icon-set.riv',
      artBoard: 'HOME',
      stateMachineName: "HOME_interactivity",
      state: MenuState.Home),
  RiveAsset('assets/RiveAssets/animated-icon-set.riv',
      artBoard: 'LIKE/STAR',
      stateMachineName: "STAR_Interactivity",
      state: MenuState.Leaderboard),
  RiveAsset('assets/RiveAssets/animated-icon-set.riv',
      artBoard: 'TIMER',
      stateMachineName: "TIMER_Interactivity",
      state: MenuState.History),
  RiveAsset('assets/RiveAssets/animated-icon-set.riv',
      artBoard: 'USER',
      stateMachineName: "USER_Interactivity",
      state: MenuState.Profile),
];

List<RiveAsset> organizerbottomNavs = [
  // RiveAsset('assets/RiveAssets/animated-icon-set.riv',
  //     artBoard: 'SETTINGS',
  //     stateMachineName: "SETTINGS_Interactivity",
  //     state: MenuState.Create),
  RiveAsset('assets/RiveAssets/animated-icon-set.riv',
      artBoard: 'REFRESH/RELOAD',
      stateMachineName: "RELOAD_Interactivity",
      state: MenuState.Manage),
  // RiveAsset('assets/RiveAssets/animated-icon-set.riv',
  //     artBoard: 'LIKE/STAR',
  //     stateMachineName: "STAR_Interactivity",
  //     state: MenuState.Leaderboard),
  RiveAsset('assets/RiveAssets/animated-icon-set.riv',
      artBoard: 'USER',
      stateMachineName: "USER_Interactivity",
      state: MenuState.Profile),
];
