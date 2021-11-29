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
  final TextEditingController textLastname = TextEditingController();
  final TextEditingController textPhone = TextEditingController();
  final TextEditingController textDDD = TextEditingController();
  final TextEditingController textCep = TextEditingController();
  final TextEditingController textLocalidade = TextEditingController();
  final TextEditingController textUf = TextEditingController();
  final TextEditingController textBairro = TextEditingController();

  ItemCadastro({Key? key, required this.cadastro}) : super(key: key) {
    textFirstname.text = cadastro.firstName;
    textLastname.text = cadastro.lastName;
    textPhone.text = cadastro.phone;
    textDDD.text = cadastro.ddd;
    textCep.text = cadastro.cep;
    textLocalidade.text = cadastro.localidade;
    textUf.text = cadastro.uf;
    textBairro.text = cadastro.bairro;
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
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: TextField(
                          controller: textFirstname,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nome',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: TextField(
                          controller: textLastname,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Segundo nome',
                          ),
                        ),
                      ),
                      Row(children: [
                        Container(
                          width: 150,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: TextField(
                              controller: textDDD,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'DDD',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: TextField(
                              controller: textPhone,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Telefone',
                              ),
                            ),
                          ),
                        )
                      ]),
                      Row(children: [
                        Container(
                          width: 150,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              controller: textUf,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Uf',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: TextField(
                              controller: textLocalidade,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Cidade',
                              ),
                            ),
                          ),
                        ),
                      ]),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: TextField(
                          controller: textBairro,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Bairro',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Salvar'),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )));
  }
}
