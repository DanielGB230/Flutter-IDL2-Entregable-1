import 'package:app1/routes.dart';
import 'package:flutter/material.dart';
// import 'package:app1/screens/landing_tabs.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Flutter Hello World',
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
        // useMaterial3: false,
        primarySwatch: Colors.blue,
      ),
      routes: appRoutes,
      initialRoute: "pokedex",
      // A widget which will be started on application startup
      //home: HomePage(),
    );
  }
}
