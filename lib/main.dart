import 'dart:io';
import 'package:primera_aplicacion/db.dart';
import 'package:sqflite/sqflite.dart';
import 'registros.dart';

import 'package:flutter/material.dart';
import 'package:flutter_text_box/flutter_text_box.dart';

import 'registro_itinerario.dart';
import 'editar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Modulo de Registro de Itinerarios'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Map<String, dynamic>> _registros = [];

  final key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //_leerComidas();
    _loadRegistros();
  }

  void _guardarNuevoRegistro(Map<String, dynamic> nuevoRegistro) {
    // Aquí puedes realizar acciones adicionales si es necesario
    print("Nuevo registro guardado: $nuevoRegistro");
    _loadRegistros(); // Actualiza la lista de registros
  }

  void _guardarEdicionRegistro(Map<String, dynamic> editedRegistro) {
    // Lógica para guardar el registro editado, si es necesario
    print("Registro editado guardado: $editedRegistro");
  }

  Future<List<Map<String, dynamic>>> _loadRegistros() async {
    try {
      List<Map<String, dynamic>> registros =
          await _databaseHelper.getRegistros();
      return registros;
    } catch (e) {
      print('Error al cargar registros: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contenedor con imagen local y cajas de texto
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Agrega tu imagen local
                Image.asset(
                  'images/principal.jpg', // Reemplaza con la ruta de tu imagen
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16.0),
                // Agrega tus cajas de texto aquí
                const Text(
                  'Bienvenido al Módulo de Registro de Itinerario de mascotas',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Aquí visualizarás el listado de registros de las mascotas ingresadas en la guardería, adicional puedes editar los registros y eliminarlos al lado de cada uno, debajo es´ta el botón para agregar un neuvo registro.',
                  style: TextStyle(fontSize: 16.0),
                ),
                // Agrega más cajas de texto según sea necesario
              ],
            ),
          ),
          // Lista de registros
          Expanded(
            child: FutureBuilder(
              future:
                  _loadRegistros(), // Reemplaza con tu lógica para obtener registros
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: const CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error al cargar registros: ${snapshot.error}'),
                  );
                } else {
                  // Obtiene la lista de registros desde el snapshot
                  List<Map<String, dynamic>> registros =
                      snapshot.data as List<Map<String, dynamic>>;

                  return ListView.builder(
                    itemCount: registros.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> registro = registros[index];

                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text('ID: ${registro['id']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nombre: ${registro['nombre']}'),
                              Text(
                                  'Día de ingreso: ${registro['dia_ingreso']}'),
                              Text(
                                  'Hora de entrada: ${registro['hora_entrada']}'),
                              Text(
                                  'Hora de salida: ${registro['hora_salida']}'),
                              Text(
                                  'Hora de comida: ${registro['hora_comida']}'),
                              Text(
                                  'Observaciones: ${registro['observaciones']}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _editRegistro(registro);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteRegistro(registro['id']);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRegistro,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _addRegistro() async {
    // Navigator.push para ir a la pantalla de formulario y pasar la función de guardado
    final nuevoRegistro = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistroItinerario(onSave: _guardarNuevoRegistro),
      ),
    );

    if (nuevoRegistro != null) {
      // Si se ha guardado un nuevo registro, actualiza la lista
      _loadRegistros();
    }
  }

  Future<void> _editRegistro(Map<String, dynamic> registro) async {
    final editedRegistro = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarItinerario(
            onSave: _guardarEdicionRegistro, registro: registro),
      ),
    );

    if (editedRegistro != null) {
      // Si se ha editado el registro, actualiza la lista
      _loadRegistros();
    }
  }

  Future<void> _deleteRegistro(int id) async {
    bool confirmacion = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Está seguro de que desea eliminar este registro?'),
          actions: [
            TextButton(
              onPressed: () {
                // Si el usuario confirma, Navigator.pop devuelve true
                Navigator.pop(context, true);
              },
              child: Text('Sí'),
            ),
            TextButton(
              onPressed: () {
                // Si el usuario cancela, Navigator.pop devuelve false
                Navigator.pop(context, false);
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );

    // Si el usuario confirmó, procede a eliminar el registro
    if (confirmacion == true) {
      await _databaseHelper.deleteRegistro(id);

      // Actualiza la interfaz inmediatamente
      setState(() {
        _registros.removeWhere((registro) => registro['id'] == id);
      });
      _loadRegistros();
    }
  }
}
