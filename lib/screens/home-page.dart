import 'package:app1/screens/login-page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int respuesta = 0;
  TextEditingController numero1Ctrl = TextEditingController();
  TextEditingController numero2Ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calcular nivel Conti."),
        ),
        body: Column(
          children: [
            Text("Primer numero"),
            TextField(
              controller: numero1Ctrl,
            ),
            Text("Segundo numero"),
            TextField(
              controller: numero2Ctrl,
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () => operacion("suma"), child: Icon(Icons.add)),
                ElevatedButton(
                    onPressed: () => operacion("resta"),
                    child: Icon(Icons.remove)),
                ElevatedButton(
                    onPressed: () => operacion("multiplicacion"),
                    child: Icon(Icons.close)),
                ElevatedButton(
                    onPressed: () => operacion("division"), child: Text("/")),
              ],
            ),
            SizedBox(height: 40),
            Text("respuesta"),
            Text("$respuesta")
          ],
        ));
  }

  void operacion(String operacion) {
    int numero1 = int.parse(numero1Ctrl.text);
    int numero2 = int.parse(numero2Ctrl.text);
    print(numero1);
    print(numero2);
    int res = 0;
    switch (operacion) {
      case "suma":
        res = numero1 + numero2;
        break;
      case "resta":
        res = numero1 - numero2;
        break;
      case "division":
        res = (numero1 / numero2).toInt();
        break;
      case "multiplicacion":
        res = numero1 * numero2;
        break;
      default:
        res = -1000;
    }
    setState(() {
      this.respuesta = res;
    });
  }

  void irALogin(BuildContext context) {
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (ctx) => LoginPage()));
    Navigator.of(context).pushNamed("login");
  }
}
