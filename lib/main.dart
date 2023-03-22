import 'package:esports_battlefield_arena/app/routes.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/screens/home/home_view.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: Routes.homeRoute,
      onGenerateRoute: Routes.createRoute,
      // onGenerateRoute: Router().onGenerateRoute,
      // home: HomeView(),
      // ignore: prefer_const_literals_to_create_immutables
    );
  }
}
