import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'detalle_pokemon.dart'; // Importamos la nueva pantalla

enum HTTP_STATES { INITIAL, LOADING, ERROR, SUCCESS }

class MiniPokedexPage extends StatefulWidget {
  const MiniPokedexPage({Key? key}) : super(key: key);

  @override
  State<MiniPokedexPage> createState() => _MiniPokedexPageState();
}

class _MiniPokedexPageState extends State<MiniPokedexPage> {
  List<Map<String, dynamic>> pkmns = [];
  HTTP_STATES state = HTTP_STATES.INITIAL;

  @override
  void initState() {
    super.initState();
    fetchPokemonData();
  }

  Future<void> fetchPokemonData() async {
    final dio = Dio();
    try {
      final response = await dio.get('https://pokeapi.co/api/v2/pokemon');
      List<Map<String, dynamic>> pkmnsTmp = [];
      for (dynamic el in response.data["results"]) {
        pkmnsTmp.add(el);
      }
      await Future.delayed(Duration(seconds: 3)); // Simular carga
      setState(() {
        pkmns = pkmnsTmp;
        state = HTTP_STATES.SUCCESS;
      });
    } catch (error) {
      setState(() {
        state = HTTP_STATES.ERROR;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: stateController(state, context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Pokedex", style: TextStyle(fontSize: 22)),
      centerTitle: true,
      backgroundColor: Colors.blue[900],
      elevation: 5,
    );
  }

  Widget stateController(HTTP_STATES state, BuildContext context) {
    switch (state) {
      case HTTP_STATES.SUCCESS:
        return bodyWithPkmns(context);
      case HTTP_STATES.ERROR:
        return error(context);
      case HTTP_STATES.INITIAL:
      case HTTP_STATES.LOADING:
      default:
        return loading(context);
    }
  }

  Widget loading(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.purple.shade600],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡HOLA BIENVENIDO!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            Image.asset(
              'assets/images/pokeapi.png', // Reemplaza con la ruta de tu imagen
              width: 200,
              height: 200,
            ),
            SizedBox(height: 16),
            Text(
              'Espera mientras cargamos los recursos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget error(BuildContext context) {
    return Center(
      child: Text(
        "ERROR!!! NOS VAMOS A MORIR",
        style: TextStyle(color: Colors.red, fontSize: 20),
      ),
    );
  }

  Widget bodyWithPkmns(BuildContext context) {
    return ListView.builder(
      itemCount: pkmns.length,
      itemBuilder: (context, index) {
        final pokemon = pkmns[index];
        List<String> strList = (pokemon["url"] as String).split("/");
        String pkmnId = strList[strList.length - 2];
        return Card(
          elevation: 5,
          shadowColor: Colors.black45,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            onTap: () {
              // Navegar a la pantalla de detalles
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetallePokemon(pokemonUrl: pokemon["url"]),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(12),
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Image.network(
                    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pkmnId}.png",
                    width: 100,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        pokemon["name"].toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "ID: #${pkmnId}",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
