import 'dart:io';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:webfeed/domain/rss_item.dart';
import 'network.dart';

import 'package:flutter/material.dart';

class WindowsRegister extends StatelessWidget {
  const WindowsRegister({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const WindowsRegisterPage(title: 'Ventana de Registro'),
    ); //Material App
  }
}

class WindowsRegisterPage extends StatefulWidget {
  const WindowsRegisterPage({super.key, required this.title});
  final String title;
  @override
  State<WindowsRegisterPage> createState() => _WindowsRegisterPage();
}

class _WindowsRegisterPage extends State<WindowsRegisterPage> {
  Future<RssFeed>? future;
  @override
  void initState() {
    super.initState();
    future = getNews();
    getNews().then((rss) {
      print(rss.title);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body:
            _body() /* const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      ), */
        );
  }

  Widget _body() {
    return FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
          }
          return Container(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ListView.builder(
                itemCount: snapshot.data.items.length + 2,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                      child: Text(snapshot.data.description),
                    );
                  }
                  if (index == 1) {
                    return _bigItem();
                  }
                  return _item(snapshot.data.items[index - 2]);
                },
              ));
        });
  }

  Widget _bigItem() {
    var screenWidth = MediaQuery.of(context).size.width;
    return Stack(alignment: Alignment.center, children: <Widget>[
      Container(
        width: double.infinity,
        height: (screenWidth - 64.0) * 3.0 / 5.0,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: NetworkImage(""),
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
      )
    ]);
  }

  Widget _item(RssItem item) {
    return Card(
        color: Colors.blueGrey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        elevation: 3,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.categories!.first.value,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    Text(item.title!),
                    Text('Autor: ${item.dc!.creator}'),
                  ],
                ),
              ),
              Container(
                  width: 120.0,
                  height: 120.0,
                  child: Image(
                    image: NetworkImage(item.enclosure?.url ??
                        "https://i.blogs.es/d5130c/wallpaper-2.png/1366_2000.jpeg"),
                    fit: BoxFit.cover,
                  ))
            ])));
  }
}
