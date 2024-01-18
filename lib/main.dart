import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_text_box/flutter_text_box.dart';
import 'registro.dart';
import 'lecturaXML.dart';

/*  void main() {
  runApp(const MyApp());
} */

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final key = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.cyan, Colors.green],
          ),
        ),
        child: Center(
          child: Container(
              width: 300,
              height: 450,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Form(
                  key: key,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          '¡Bienvenido de Nuevo! :D',
                          textAlign: TextAlign
                              .center, // Centra el texto horizontalmente
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold, // Aplica negrita al texto
                            fontSize: 18, // Tamaño del texto
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          'Ingrese sus credenciales para iniciar sesión',
                          textAlign: TextAlign
                              .center, // Centra el texto horizontalmente
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold, // Aplica negrita al texto
                            fontSize: 15, // Tamaño del texto
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextBoxIcon(
                          icon: Icons.email_outlined,
                          inputType: TextInputType.emailAddress,
                          label: 'Email',
                          hint: 'Ingrese su email aquí',
                          errorText: 'Este campo es requerido !',
                          onSaved: (String value) {
                            _email = value;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextBoxIcon(
                            icon: Icons.lock_outlined,
                            inputType: TextInputType.number,
                            obscure: true,
                            label: 'Contraseña',
                            hint: 'Ingrese su contraseña aquí',
                            errorText: 'Este campo es requerido !',
                            onSaved: (String value) {
                              _password = value;
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        /* TextButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 18)),
                          onPressed: () => submitForm(),
                          child: const Text('Iniciar Sesión'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                            style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 18)),
                            onPressed: () => salir(),
                            child: const Text('Salir')), */
                        _botones(),
                      ]))),
        ),
      ),
    );
  }

  Widget _botones() {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(onPressed: _ingresar, child: const Text('Ingresar')),
        ElevatedButton(onPressed: _salirr, child: const Text('Salir')),
      ],
    ));
  }

  void _ingresar() {
    const String email = "12345";
    const String password = "12345";

    final state = key.currentState;
    if (state!.validate()) {
      state.save();

      if (_email.isEmpty || _password.isEmpty) {
        // Mostrar un mensaje de error
        print("Error en las credenciales de acceso");
      }

      if (_email == email && _password == password) {
        // Mostrar un mensaje de éxito
        print("Acceso concedido");

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LecturaXML()));
      } else {
        // Mostrar un mensaje de error
        print("Error en las credenciales de acceso");
      }
    }
  }

  void _salirr() {
    // Mostrar un mensaje de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("¿Desea salir de la aplicación?"),
        action: SnackBarAction(
          label: "Salir",
          onPressed: () {
            print("Ha salido del sistema");
            exit(0);
          },
        ),
      ),
    );
  }
}

//Widget _login() {}
