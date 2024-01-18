import 'package:primera_aplicacion/comida.dart';
import 'package:primera_aplicacion/planta.dart';
import 'package:primera_aplicacion/receta.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:webfeed/domain/rss_item.dart';
import 'network.dart';
import 'package:xml/xml.dart' as xml;

import 'package:flutter/material.dart';
//import 'package:flutter_text_box/flutter_text_box.dart';

void main() {
  runApp(const LecturaReceta());
}

class LecturaReceta extends StatelessWidget {
  const LecturaReceta({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const LecturadeReceta(title: 'Lectura de archivos XML'),
    ); //Material App
  }
}

class LecturadeReceta extends StatefulWidget {
  const LecturadeReceta({super.key, required this.title});
  final String title;
  @override
  State<LecturadeReceta> createState() => _LecturaReceta();
}

class _LecturaReceta extends State<LecturadeReceta> {
  //List<Comida> comidas = [];
  //List<Planta> plantas = [];
  List<Receta> recetas = [];

  //Future<RssFeed>? future;
  @override
  void initState() {
    super.initState();
    _leerRecetas();
  }

  Future<void> _leerRecetas() async {
    final data = await DefaultAssetBundle.of(context)
        .loadString('documentos/receta.xml');
    final document = xml.XmlDocument.parse(data);
    final elementos = document.findAllElements('receta');

    setState(() {
      recetas = elementos.map((elemento) {
        final tipo = elemento.findElements('tipo').single.text;
        final dificultad = elemento.findElements('dificultad').single.text;
        final nombre = elemento.findElements('nombre').single.text;
        final ingredientes = elemento.findElements('ingredientes').single.text;
        final pasos = elemento.findElements('pasos').single.text;
        final calorias =
            int.parse(elemento.findElements('calorias').single.text);

        final elaboracion = elemento.findElements('elaboracion').single.text;

        final tiempo = elemento.findElements('tiempo').single.text;
        final imagen = elemento.findElements('image').single.text;
        return Receta(
            tipo: tipo,
            dificultad: dificultad,
            nombre: nombre,
            ingredientes: ingredientes,
            pasos: pasos,
            calorias: calorias,
            elaboracion: elaboracion,
            tiempo: tiempo,
            imagen: imagen);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _bodyComida(),
    );

    //_cuerpo());
  }

  Widget _bodyComida() {
    return ListView.builder(
      itemCount: recetas.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(4.0),
          child: Card(
              child: ListTile(
            title: Text(recetas[index].nombre,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //  Text('Tipo: ${recetas[index].tipo}'),
              Text('Dificultad: ${recetas[index].dificultad}'),
              //  Text('Ingredientes: ${recetas[index].ingredientes}'),
              Text('Pasos: ${recetas[index].pasos}'),
              Text('Calorias: ${recetas[index].calorias}'),
              Text('Elaboración : ${recetas[index].elaboracion}'),
              Text('Tiempo: ${recetas[index].tiempo}'),
              const SizedBox(
                height: 40,
              ),
              Container(
                /*  width: 150.0,
                height: 170.0, */
                child: Center(
                    child: Image(image: NetworkImage(recetas[index].imagen)
                        //fit: BoxFit.cover,
                        )),
              )

              //Image(image: NetworkImage(comidas[index].imagen)),
            ]),
          )),
        );
      },
    );
  }

  // The UI displays the correct number of food items from the 'comidas' list
}
