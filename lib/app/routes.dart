import 'package:flutter/widgets.dart';

class Routes {
  static const String homeRoute = '/home';
  static const String registerRoute = '/login';

  static Route<dynamic>? createRoute(settings) {
    switch (settings.name) {
      case homeRoute:
      // return HomeView.route();
    }
    return null;
  }
}
