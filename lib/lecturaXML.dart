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
  runApp(const LecturaXML());
}

class LecturaXML extends StatelessWidget {
  const LecturaXML({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const LecturadeXML(title: 'Lectura de archivos XML'),
    ); //Material App
  }
}

class LecturadeXML extends StatefulWidget {
  const LecturadeXML({super.key, required this.title});
  final String title;
  @override
  State<LecturadeXML> createState() => _LecturaXML();
}

class _LecturaXML extends State<LecturadeXML> {
  List<Comida> comidas = [];
  List<Planta> plantas = [];

  //Future<RssFeed>? future;
  @override
  void initState() {
    super.initState();
    _leerComidas();
    // _leerPlantas();
  }

  Future<void> _leerComidas() async {
    final data = await DefaultAssetBundle.of(context)
        .loadString('documentos/comida.xml');
    final document = xml.XmlDocument.parse(data);
    final elementos = document.findAllElements('food');

    setState(() {
      comidas = elementos.map((elemento) {
        final nombre = elemento.findElements('name').first.text;
        final precio = double.parse(elemento.findElements('price').single.text);
        final descripcion = elemento.findElements('description').single.text;
        final calorias =
            int.parse(elemento.findElements('calories').single.text);
        final imagen = elemento.findElements('image').single.text;
        return Comida(
            nombre: nombre,
            precio: precio,
            descripcion: descripcion,
            calorias: calorias,
            imagen: imagen);
      }).toList();
    });
  }

  Future<void> _leerPlantas() async {
    final data = await DefaultAssetBundle.of(context)
        .loadString('documentos/Planta.xml');
    final document = xml.XmlDocument.parse(data);
    final elementos = document.findAllElements('PLANT');

    setState(() {
      plantas = elementos.map((elemento) {
        final nombre = elemento.findElements('COMMON').first.text;
        final String botanical = elemento.findElements('BOTANICAL').single.text;
        final String zona = elemento.findElements('ZONE').single.text;
        final String light = elemento.findElements('LIGHT').single.text;
        final double precio =
            double.parse(elemento.findElements('PRICE').single.text);
        final int disponibilidad =
            int.parse(elemento.findElements('AVAILABILITY').single.text);
        final String imagen = elemento.findElements('IMAGE').single.text;

        return Planta(
            nombre: nombre,
            botanical: botanical,
            zona: zona,
            light: light,
            precio: precio,
            disponibilidad: disponibilidad,
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
      //_plantas(),
    );

    //_cuerpo());
  }

  Widget _bodyComida() {
    return ListView.builder(
      itemCount: comidas.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(4.0),
          child: Card(
              child: ListTile(
            title: Text(comidas[index].nombre,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Nombre: ${comidas[index].nombre}'),
                  Text('Precio: ${comidas[index].precio} €'),
                  Text('Descripción: ${comidas[index].calorias}'),
                  Text('Calorías: ${comidas[index].calorias} kcal'),
                  Container(
                      width: 110.0,
                      height: 110.0,
                      child: Image(image: NetworkImage(comidas[index].imagen)
                          //fit: BoxFit.cover,
                          )),
                  //Image(image: NetworkImage(comidas[index].imagen)),
                ]),
          )),
        );
      },
    );
  }

  // The UI displays the correct number of food items from the 'comidas' list
}
