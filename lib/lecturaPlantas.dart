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
  runApp(const LecturaPlantas());
}

class LecturaPlantas extends StatelessWidget {
  const LecturaPlantas({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const LecturadePlantas(title: 'Lectura de archivos XML'),
    ); //Material App
  }
}

class LecturadePlantas extends StatefulWidget {
  const LecturadePlantas({super.key, required this.title});
  final String title;
  @override
  State<LecturadePlantas> createState() => _LecturaPlantas();
}

class _LecturaPlantas extends State<LecturadePlantas> {
  //List<Comida> comidas = [];
  List<Planta> plantas = [];

  //Future<RssFeed>? future;
  @override
  void initState() {
    super.initState();
    //_leerComidas();
    _leerPlantas();
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
      body: _bodyPlantas(),
      //_plantas(),
    );

    //_cuerpo());
  }

  Widget _bodyPlantas() {
    return ListView.builder(
      itemCount: plantas.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(4.0),
          child: Card(
              child: ListTile(
            title: Text(plantas[index].nombre,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Nombre: ${plantas[index].nombre}'),
                  Text('Botanical: ${plantas[index].botanical}'),
                  Text('Zona: ${plantas[index].zona}'),
                  Text('Light: ${plantas[index].light}'),
                  Text('Precio: ${plantas[index].precio} €'),
                  Text('Disponibilidad: ${plantas[index].disponibilidad}'),
                  Container(
                      width: 110.0,
                      height: 115.0,
                      child: Image(image: NetworkImage(plantas[index].imagen))),
                ]),
          )),
        );
      },
    );
  }
}
