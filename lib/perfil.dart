import 'dart:convert';
import 'package:app_qrcode_login/bussines/cadastro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  Future<Cadastro> fetchCadastro(http.Client client) async {
    final response = await client.get(Uri.parse(
        'http://192.168.1.15:3000/cadastro/6006e22185e1c7001e4766af'));
    if (response.statusCode == 200) {
      return Cadastro.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
        ),
        body: FutureBuilder<Cadastro>(
          future: fetchCadastro(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              return ItemCadastro(cadastro: snapshot.data!);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

class ItemCadastro extends StatelessWidget {
  final Cadastro cadastro;
  final TextEditingController textFirstname = TextEditingController();

  ItemCadastro({Key? key, required this.cadastro}) : super(key: key) {
    textFirstname.text = cadastro.firstName;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            margin: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: ListView(
                children: <Widget>[
                  Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: TextField(
                          controller: textFirstname,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nome',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}
