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
      title: Text(
        "Detalles del Pokémon",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.blue[900],
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue[700]!,
            Colors.blue[800]!,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: FutureBuilder<Map<String, dynamic>>(
        future: fetchPokemonDetails(pokemonUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
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
        style: TextStyle(color: Colors.white, fontSize: 18),
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
          SizedBox(height: 20),
          _buildPokemonName(pokemonDetails["name"]),
          SizedBox(height: 20),
          _buildDetailCard("Altura", pokemonDetails["height"].toString()),
          SizedBox(height: 20),
          _buildDetailCard("Peso", pokemonDetails["weight"].toString()),
          SizedBox(height: 20),
          _buildTypes(pokemonDetails["types"]),
          SizedBox(height: 20),
          _buildAbilities(pokemonDetails["abilities"]),
          SizedBox(height: 20),
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
      padding: EdgeInsets.all(16),
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
      style: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDetailCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: $value",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildTypes(List<dynamic> types) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tipos:",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          ...types.map<Widget>((type) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                "- ${type["type"]["name"]}",
                style: TextStyle(color: Colors.white, fontSize: 16),
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Habilidades:",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          ...abilities.map<Widget>((ability) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                "- ${ability["ability"]["name"]}",
                style: TextStyle(color: Colors.white, fontSize: 16),
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Estadísticas:",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          ...stats.map<Widget>((stat) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                "${stat["stat"]["name"]}: ${stat["base_stat"]}",
                style: TextStyle(color: Colors.white, fontSize: 16),
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
