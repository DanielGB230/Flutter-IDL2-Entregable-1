// minipokedex.dart
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
      appBar: AppBar(title: Text("Pokedex")),
      body: stateController(state, context),
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
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade800,
            Colors.purple.shade600,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            SizedBox(height: 20), // Espacio adicional antes del indicador
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Color del indicador en blanco
            ),
          ],
        ),
      ),
    );
  }
  Widget error(BuildContext context) {
    return Center(
      child: Text("ERROR!!! NOS VAMOS A MORIR"),
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
              height: 120,
              child: Row(
                children: [
                  Image.network(
                    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pkmnId}.png",
                    width: 120,
                  ),
                  SizedBox(width: 20),
                  Text(
                    pokemon["name"],
                    style: TextStyle(fontSize: 18),
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

/* funcional */