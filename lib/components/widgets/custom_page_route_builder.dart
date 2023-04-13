import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class CustomRoute1 extends PageRouteInfo {
  final String name;
  final Widget page;

  const CustomRoute1({required this.name, required this.page}) : super(name);
  @override
  Route<dynamic> buildPageRoute(BuildContext context) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
