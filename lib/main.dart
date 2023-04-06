import 'package:esports_battlefield_arena/app/route.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeServiceLocator();
  runApp(const EsportBattleFieldArena());
}

class EsportBattleFieldArena extends StatelessWidget {
  const EsportBattleFieldArena({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   navigatorKey: StackedService.navigatorKey,
    // );
    return MaterialApp.router(
      // theme: ThemeData(
      //   brightness: Brightness.dark,
      //   primaryColor: Color(0xffB4FC79),
      //   colorScheme: Colros

      //   Color(0xffD1D1D1),
      // ),
      debugShowCheckedModeBanner: false,
      title: 'Esports Battlefield Arena',
      routerDelegate: locator<AppRouter>().delegate(),
      routeInformationParser: locator<AppRouter>().defaultRouteParser(),
      // initialRoute: Routes.homeRoute,
      // onGenerateRoute: Routes.createRoute,
      // onGenerateRoute: Router().onGenerateRoute,
      // home: HomeView(),
      // ignore: prefer_const_literals_to_create_immutables
    );
  }
}
