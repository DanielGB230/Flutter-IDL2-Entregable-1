import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class DetallePokemon extends StatelessWidget {
  final String pokemonUrl;

  const DetallePokemon({Key? key, required this.pokemonUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "Detalles del Pokémon",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.purple[800],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple[500]!,
            Colors.blue[500]!,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: FutureBuilder<Map<String, dynamic>>(
        future: fetchPokemonDetails(pokemonUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          } else if (snapshot.hasError) {
            return _buildErrorMessage("Error al cargar los detalles");
          } else if (!snapshot.hasData) {
            return _buildErrorMessage("No hay datos disponibles");
          } else {
            return _buildPokemonDetails(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildPokemonDetails(Map<String, dynamic> pokemonDetails) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildPokemonImage(pokemonDetails["sprites"]["front_default"]),
          const SizedBox(height: 20),
          _buildPokemonName(pokemonDetails["name"]),
          const SizedBox(height: 20),
          _buildDetailCard("Altura", pokemonDetails["height"].toString()),
          const SizedBox(height: 20),
          _buildDetailCard("Peso", pokemonDetails["weight"].toString()),
          const SizedBox(height: 20),
          _buildTypes(pokemonDetails["types"]),
          const SizedBox(height: 20),
          _buildAbilities(pokemonDetails["abilities"]),
          const SizedBox(height: 20),
          _buildStats(pokemonDetails["stats"]),
        ],
      ),
    );
  }

  Widget _buildPokemonImage(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[800]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Image.network(
        imageUrl,
        width: 300,
        height: 300,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildPokemonName(String name) {
    return Text(
      name.toUpperCase(),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDetailCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: $value",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildTypes(List<dynamic> types) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tipos:",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...types.map<Widget>((type) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                "- ${type["type"]["name"]}",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAbilities(List<dynamic> abilities) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Habilidades:",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...abilities.map<Widget>((ability) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                "- ${ability["ability"]["name"]}",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildStats(List<dynamic> stats) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Estadísticas:",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...stats.map<Widget>((stat) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                "${stat["stat"]["name"]}: ${stat["base_stat"]}",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> fetchPokemonDetails(String url) async {
    final dio = Dio();
    final response = await dio.get(url);
    return response.data;
  }
}
