import 'dart:convert';

import 'package:primera_aplicacion/Pais.dart';

import 'network.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

void main() {
  runApp(const LecturaPaises());
}

class LecturaPaises extends StatelessWidget {
  const LecturaPaises({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const LecturadePaises(title: 'Lectura de archivos XML'),
    ); //Material App
  }
}

class LecturadePaises extends StatefulWidget {
  const LecturadePaises({super.key, required this.title});
  final String title;
  @override
  State<LecturadePaises> createState() => _LecturaPaises();
}

class _LecturaPaises extends State<LecturadePaises> {
//  Future<List<Pais>> _listadoPaises;

  Future<List<Pais>> _getPaises() async {
    final response =
        await http.get(Uri.parse('https://restcountries.com/v2/all'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((paisData) => Pais(
              nombre: paisData['name'],
              capital: paisData['capital'] ?? '',
              urlbandera: paisData['flags']['png']))
          .toList();
    } else {
      throw Exception("Error de Conexión");
    }
  }

  @override
  void initState() {
    super.initState();
    //_listadoPaises = _getPaises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Lectura API - Paises"),
        ),
        body: FutureBuilder<List<Pais>>(
            future: _getPaises(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final paises = snapshot.data!;
                return ListView.builder(
                  itemCount: paises.length,
                  itemBuilder: (context, index) {
                    final pais = paises[index];
                    return Card(
                      color: Colors.lightBlue.shade100,
                      child: ListTile(
                        leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(pais.urlbandera)),
                        title: Text(pais.nombre),
                        subtitle: Text(pais.capital),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const SizedBox.shrink();
            }));
  }
  //build Context
}
