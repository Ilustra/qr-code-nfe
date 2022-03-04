// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'package:app_qrcode_login/bussines/notas.dart';

import 'package:app_qrcode_login/detalhe_nota.dart';
import 'package:app_qrcode_login/service/NotasService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';

class Notas extends StatefulWidget {
 
  static const routeName = '/home';
  const Notas({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _Notas createState() => _Notas();
}

class _Notas extends State<Notas> {

  bool _showFab = true;
  bool _showNotch = true;
  FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.endDocked;

  String message = '';
  String exMessage(value) {
    return value.toString();
  }

  late NotasService nota = new NotasService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + ''),
      ),
      body: FutureBuilder<List<Nota>>(
        future: nota.findAll(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return ItemList(items: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ItemList extends StatelessWidget {
  const ItemList({Key? key, required this.items}) : super(key: key);

  final List<Nota> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Center(
            child: Card(
                margin: const EdgeInsets.all(5.0),
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetalheNota(nota: items[index])),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  items[index].getNameReducer(),
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .apply(fontSizeFactor: 1.3),
                                ),
                              ),
                              Container(
                                child: Text(
                                  DateFormat("dd 'de' MMMM 'de' yyyy'")
                                      .format(items[index].getDate()),
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .apply(fontSizeFactor: 1.0),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                items[index].getTotal(),
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                        ],
                      ),
                    ))));
      },
    );
  }
}
