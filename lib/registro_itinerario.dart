import 'dart:io';
import 'package:primera_aplicacion/db.dart';
import 'package:sqflite/sqflite.dart';
import 'registros.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart'
    as dtPicker;

import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_text_box/flutter_text_box.dart';

/* void main() {
  runApp(const RegistroItinerario());
} */

class RegistroItinerario extends StatelessWidget {
  final Function(Map<String, dynamic>) onSave;

  //const RegistroItinerario({super.key, onSave});

  const RegistroItinerario({Key? key, required this.onSave}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),

      home: RegistroForm(
        title: 'Crear Registros de Itinerario',
        onSave: onSave,
      ),

      //home: const RegistroForm(title: 'Crear Registros de Itinerario'),
    );
  }
}

class RegistroForm extends StatefulWidget {
  //const RegistroForm ({super.key, required this.title});

  final Function(Map<String, dynamic>) onSave;

  const RegistroForm({required this.onSave, required this.title});

  final String title;

  @override
  State<RegistroForm> createState() => _RegistroFormState();
}

class _RegistroFormState extends State<RegistroForm> {
  TextEditingController _nombreController = TextEditingController();
  String _diaIngreso = '';
  String _horaEntrada = '';
  String _horaSalida = '';
  String _horaComida = '';
  TextEditingController _observacionesController = TextEditingController();

  //List<Registros> registros = [];
  // Registros _registro = Registros();
  Map<String, dynamic> _registro = {};

  final key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Agrega tu imagen local
                Image.asset(
                  'images/registroo.jpg', // Reemplaza con la ruta de tu imagen
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16.0),
                // Agrega tus cajas de texto aquí
                const Text(
                  'Registrar el itinerario de una mascota a detalle',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Por favor, llene los campos correspondientes para que se pueda registrar de forma existosa el itinerario de la mascota correspondiente',
                  style: TextStyle(fontSize: 16.0),
                ),
                // Agrega más cajas de texto según sea necesario
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 203, 208, 209),
                  Color.fromARGB(255, 224, 228, 191)
                ],
              ),
            ),
            child: Center(
              child: Container(
                  width: 700,
                  height: 750,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nombreController,
                          decoration:
                              const InputDecoration(labelText: 'Nombre'),
                        ),
                        const SizedBox(height: 16.0),
                        InkWell(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Día de Ingreso',
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(_diaIngreso),
                                const Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        InkWell(
                          onTap: () {
                            _selectTime('entrada');
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Hora de Entrada',
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(_horaEntrada),
                                const Icon(Icons.access_time),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        InkWell(
                          onTap: () {
                            _selectTime('salida');
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Hora de Salida',
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(_horaSalida),
                                const Icon(Icons.access_time),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        InkWell(
                          onTap: () {
                            _selectTime('comida');
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Hora de Comida',
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(_horaComida),
                                const Icon(Icons.access_time),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _observacionesController,
                          maxLines: 3,
                          decoration:
                              const InputDecoration(labelText: 'Observaciones'),
                        ),
                        const SizedBox(height: 32.0),
                        Center(
                          child: SizedBox(
                            width: 200.0,
                            child: ElevatedButton(
                              onPressed: () {
                                _saveRegistro();
                                widget.onSave(_registro);
                                Navigator.pop(context,
                                    _registro); // Devuelve los datos del nuevo registro
                              },
                              child: const Text('Registrar'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),

      // Contenedor con imagen local y cajas de texto
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    dtPicker.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2020, 1, 1),
      maxTime: DateTime(2030, 12, 31),
      onChanged: (date) {
        // No es necesario manejar cambios de fecha en este ejemplo
      },
      onConfirm: (date) {
        setState(() {
          _diaIngreso = '${date.year}-${date.month}-${date.day}';
        });
      },
      currentTime: DateTime.now(),
      locale: dtPicker.LocaleType.es,
    );
  }

  Future<void> _selectTime(String field) async {
    dtPicker.DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      onChanged: (time) {
        // No es necesario manejar cambios de hora en este ejemplo
      },
      onConfirm: (time) {
        setState(() {
          String formattedTime =
              '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
          switch (field) {
            case 'entrada':
              _horaEntrada = formattedTime;
              break;
            case 'salida':
              _horaSalida = formattedTime;
              break;
            case 'comida':
              _horaComida = formattedTime;
              break;
          }
        });
      },
      currentTime: DateTime.now(),
      locale: dtPicker.LocaleType.es,
    );
  }

  void _saveRegistro() async {
    // Crear un mapa con los datos del registro
    _registro = {
      'nombre': _nombreController.text,
      'dia_ingreso': _diaIngreso,
      'hora_entrada': _horaEntrada,
      'hora_salida': _horaSalida,
      'hora_comida': _horaComida,
      'observaciones': _observacionesController.text,
    };

    // Guardar el registro en la base de datos utilizando DatabaseHelper
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.insertRegistro(_registro);
    widget.onSave(_registro);

    // Verificar si _registro tiene elementos
    if (_registro.isNotEmpty) {
      print("Hay elementos");

      // Mostrar un mensaje de éxito utilizando SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registro guardado correctamente'),
          action: SnackBarAction(
            label: 'Ok :)',
            onPressed: () {
              // Puedes añadir alguna acción si es necesario
            },
          ),
        ),
      );

      // Retornar a la pantalla principal después de un breve período de tiempo
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pop(context, _registro);
        }
      });
    } else {
      // Manejar la situación en la que no hay elementos en _registro
      print("No hay elementos en _registro");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al guardar el registro.'),
        ),
      );
    }

    // Cerrar la pantalla actual
  }
}
