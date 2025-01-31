import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class DetallePokemon extends StatelessWidget {
  final String pokemonUrl;

  const DetallePokemon({Key? key, required this.pokemonUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detalles del Pokémon",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueGrey[900], // Azul marino oscuro
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Regresar a la pantalla anterior
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueGrey[900]!, // Azul marino oscuro
              Colors.blueGrey[800]!, // Azul marino un poco más claro
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder(
          future: fetchPokemonDetails(pokemonUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error al cargar los detalles",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text(
                  "No hay datos disponibles",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            } else {
              final pokemonDetails = snapshot.data as Map<String, dynamic>;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Imagen del Pokémon
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[800]!.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Image.network(
                        pokemonDetails["sprites"]["front_default"],
                        width: 300, // Aumenté el ancho de la imagen
                        height: 300, // Aumenté el alto de la imagen
                        fit: BoxFit.cover, // Ajusta la imagen al contenedor
                      ),
                    ),
                    SizedBox(height: 20),
                    // Nombre del Pokémon
                    Text(
                      pokemonDetails["name"].toString().toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Detalles (Altura y Peso)
                    Container(
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
                            "Altura: ${pokemonDetails["height"]}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Peso: ${pokemonDetails["weight"]}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Habilidades
                    Container(
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
                          ...pokemonDetails["abilities"].map<Widget>((ability) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                "- ${ability["ability"]["name"]}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchPokemonDetails(String url) async {
    final dio = Dio();
    final response = await dio.get(url);
    return response.data;
  }
}