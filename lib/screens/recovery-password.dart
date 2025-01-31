import 'package:app1/screens/home-page.dart';
import 'package:flutter/material.dart';

class RecoveryPasswordPage extends StatelessWidget {
  const RecoveryPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Recuperar contraseña"),
        ),
        body: Column(
          children: [
            Text("LOGIN"),
            ElevatedButton(
                onPressed: () => irAHome(context), child: Text("volver a home"))
          ],
        ));
  }

  void irAHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => HomePage()), (route) => false);
  }
}
