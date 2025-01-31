import 'package:flutter/material.dart';

import '../models/user.dart';

class ProfilePage extends StatelessWidget {
  AppUser user;
  ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagina perfil."),
      ),
      body: Text("perfil de ${user.names}"),
    );
  }
}
