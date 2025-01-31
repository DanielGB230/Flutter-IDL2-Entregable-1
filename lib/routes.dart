import 'package:app1/models/user.dart';
import 'package:app1/screens/home-page.dart';
import 'package:app1/screens/login-page.dart';
import 'package:app1/screens/minipokedex.dart';
import 'package:app1/screens/profile-page.dart';
import 'package:app1/screens/recovery-password.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    "home": (_) => HomePage(),
    "login": (_) => LoginPage(),
    "recovery-password": (_) => RecoveryPasswordPage(),
    "profile": (context) => ProfilePage(
        user: ModalRoute.of(context)!.settings.arguments as AppUser),
    "pokedex": (_) => MiniPokedexPage(),
  };
}
