import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'detalle_pokemon.dart';

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
      await Future.delayed(const Duration(seconds: 3)); // carga
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
      title: const Text("Pokedex", style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
      centerTitle: true,
      backgroundColor: Colors.deepPurple[800],
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
      ),
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
            const Text(
              '¡HOLA BIENVENIDO!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
                color: Colors.white,
                fontSize: 28,
              ),
            ),
            Image.asset(
              'assets/images/pokeapi.png', 
              width: 180,
              height: 180,
            ),
            const SizedBox(height: 16),
            const Text(
              'Espera mientras cargamos los recursos...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget error(BuildContext context) {
    return const Center(
      child: Text(
        "¡Vaya! Algo salió mal.",
        style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
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
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetallePokemon(pokemonUrl: pokemon["url"]),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Image.network(
                    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pkmnId.png",
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        pokemon["name"].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "ID: #$pkmnId",
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
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
