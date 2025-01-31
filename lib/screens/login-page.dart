import 'package:app1/models/user.dart';
import 'package:app1/screens/profile-page.dart';
import 'package:app1/screens/recovery-password.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Inicio de sesion"),
        ),
        body: Column(
          children: [
            Text("LOGIN"),
            ElevatedButton(
                onPressed: () => irARecoveryPassword(context),
                child: Text("Recuperar contraseña")),
            ElevatedButton(
                onPressed: () => irAPerfil(context),
                child: Text("Iniciar sesion"))
          ],
        ));
  }

  void irARecoveryPassword(BuildContext context) {
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (ctx) => RecoveryPasswordPage()));

    Navigator.of(context).pushNamed("recovery-password");
  }

  void irAPerfil(BuildContext context) {
    // LOGin
    Future.delayed(Duration(seconds: 4), () {
      AppUser myProfile = AppUser(id: 1, names: "jonas", document: "12324343");
      //Navigator.of(context).pushReplacement(
      //    MaterialPageRoute(builder: (ctx) => ProfilePage(user: myProfile)));

      Navigator.of(context)
          .pushReplacementNamed("profile", arguments: myProfile);
    });
  }
}
