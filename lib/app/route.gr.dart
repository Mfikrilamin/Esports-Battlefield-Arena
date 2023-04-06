// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;

import '../screens/Example/example.dart' as _i7;
import '../screens/future_example/future_example_view.dart' as _i5;
import '../screens/partial_build_view/partial_build_view.dart' as _i3;
import '../screens/home/home_view.dart' as _i1;
import '../screens/reactive_example/reactive_build_view.dart' as _i4;
import '../screens/profile/profile_view.dart' as _i11;
import '../screens/sign_in/signin_view.dart' as _i2;
import '../screens/sign_up/sign_up_next_screen.dart' as _i10;
import '../screens/sign_up/signup_screen.dart' as _i9;
import '../screens/stream_example/stream_example_view.dart' as _i6;
import '../screens/testing/testing_viewmodel.dart' as _i8;

class AppRouter extends _i12.RootStackRouter {
  AppRouter([_i13.GlobalKey<_i13.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i12.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.HomeView(),
      );
    },
    SignInRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.SignInView(),
      );
    },
    PartialBuildsRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.PartialBuildsView(),
      );
    },
    ReactiveRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.ReactiveView(),
      );
    },
    FutureExampleRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.FutureExampleView(),
      );
    },
    StreamExampleRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.StreamExampleView(),
      );
    },
    ExampleRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.ExampleView(),
      );
    },
    TestingRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i8.TestingView(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.SignUpView(),
      );
    },
    SignUpNextRoute.name: (routeData) {
      return _i12.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i10.SignUpNextView(),
      );
    },
  };

  @override
  List<_i12.RouteConfig> get routes => [
        _i12.RouteConfig(
          HomeRoute.name,
          path: '/',
        ),
        _i12.RouteConfig(
          SignInRoute.name,
          path: '/sign-in-view',
        ),
        _i12.RouteConfig(
          PartialBuildsRoute.name,
          path: '/partial-builds-view',
        ),
        _i12.RouteConfig(
          ReactiveRoute.name,
          path: '/reactive-view',
        ),
        _i12.RouteConfig(
          FutureExampleRoute.name,
          path: '/future-example-view',
        ),
        _i12.RouteConfig(
          StreamExampleRoute.name,
          path: '/stream-example-view',
        ),
        _i12.RouteConfig(
          ExampleRoute.name,
          path: '/example-view',
        ),
        _i12.RouteConfig(
          TestingRoute.name,
          path: '/testing-view',
        ),
        _i12.RouteConfig(
          SignUpRoute.name,
          path: '/sign-up-view',
        ),
        _i12.RouteConfig(
          SignUpNextRoute.name,
          path: '/sign-up-next-view',
        ),
        _i12.RouteConfig(
          SettingRoute.name,
          path: '/setting-view',
        ),
      ];
}

/// generated route for
/// [_i1.HomeView]
class HomeRoute extends _i12.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i2.SignInView]
class SignInRoute extends _i12.PageRouteInfo<void> {
  const SignInRoute()
      : super(
          SignInRoute.name,
          path: '/sign-in-view',
        );

  static const String name = 'SignInRoute';
}

/// generated route for
/// [_i3.PartialBuildsView]
class PartialBuildsRoute extends _i12.PageRouteInfo<void> {
  const PartialBuildsRoute()
      : super(
          PartialBuildsRoute.name,
          path: '/partial-builds-view',
        );

  static const String name = 'PartialBuildsRoute';
}

/// generated route for
/// [_i4.ReactiveView]
class ReactiveRoute extends _i12.PageRouteInfo<void> {
  const ReactiveRoute()
      : super(
          ReactiveRoute.name,
          path: '/reactive-view',
        );

  static const String name = 'ReactiveRoute';
}

/// generated route for
/// [_i5.FutureExampleView]
class FutureExampleRoute extends _i12.PageRouteInfo<void> {
  const FutureExampleRoute()
      : super(
          FutureExampleRoute.name,
          path: '/future-example-view',
        );

  static const String name = 'FutureExampleRoute';
}

/// generated route for
/// [_i6.StreamExampleView]
class StreamExampleRoute extends _i12.PageRouteInfo<void> {
  const StreamExampleRoute()
      : super(
          StreamExampleRoute.name,
          path: '/stream-example-view',
        );

  static const String name = 'StreamExampleRoute';
}

/// generated route for
/// [_i7.ExampleView]
class ExampleRoute extends _i12.PageRouteInfo<void> {
  const ExampleRoute()
      : super(
          ExampleRoute.name,
          path: '/example-view',
        );

  static const String name = 'ExampleRoute';
}

/// generated route for
/// [_i8.TestingView]
class TestingRoute extends _i12.PageRouteInfo<void> {
  const TestingRoute()
      : super(
          TestingRoute.name,
          path: '/testing-view',
        );

  static const String name = 'TestingRoute';
}

/// generated route for
/// [_i9.SignUpView]
class SignUpRoute extends _i12.PageRouteInfo<void> {
  const SignUpRoute()
      : super(
          SignUpRoute.name,
          path: '/sign-up-view',
        );

  static const String name = 'SignUpRoute';
}

/// generated route for
/// [_i10.SignUpNextView]
class SignUpNextRoute extends _i12.PageRouteInfo<void> {
  const SignUpNextRoute()
      : super(
          SignUpNextRoute.name,
          path: '/sign-up-next-view',
        );

  static const String name = 'SignUpNextRoute';
}

/// generated route for
/// [_i11.SettingView]
class SettingRoute extends _i12.PageRouteInfo<void> {
  const SettingRoute()
      : super(
          SettingRoute.name,
          path: '/setting-view',
        );

  static const String name = 'SettingRoute';
}
