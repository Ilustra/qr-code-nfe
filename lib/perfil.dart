import 'dart:convert';
import 'package:app_qrcode_login/bussines/cadastro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  Future<Cadastro> fetchCadastro(http.Client client) async {
    final response = await client.get(Uri.parse(
        'http://192.168.1.16:3000/cadastro/6034f57118fb983f1d7efad0'));
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

/// This is the stateful widget that the main application instantiates.
class ItemCadastro extends StatefulWidget {
  final Cadastro cadastro;
  const ItemCadastro({Key? key, required this.cadastro}) : super(key: key);

  @override
  State<ItemCadastro> createState() => _ItemCadastro();
}

class _ItemCadastro extends State<ItemCadastro> with TickerProviderStateMixin {
  late AnimationController controller;
  bool statusProgress = false;
  Cadastro? cadastro;
  final TextEditingController textFirstname = TextEditingController();
  final TextEditingController textLastname = TextEditingController();
  final TextEditingController textPhone = TextEditingController();
  final TextEditingController textDDD = TextEditingController();
  final TextEditingController textCep = TextEditingController();
  final TextEditingController textLocalidade = TextEditingController();
  final TextEditingController textUf = TextEditingController();
  final TextEditingController textBairro = TextEditingController();
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<Cadastro> fetchUpdate(
      http.Client client,
      String user,
      String firstname,
      String lastName,
      String phone,
      String ddd,
      String cep,
      String localidade,
      String uf,
      String bairro) async {
    final response = await client
        .post(Uri.parse('http://192.168.1.16:3000/cadastro/'), body: {
      'user': user,
      'firstName': firstname,
      'lastName': lastName,
      'phone': phone,
      'ddd': ddd,
      'cep': cep,
      'localidade': localidade,
      'uf': uf,
      'bairro': bairro,
    });
    if (response.statusCode == 200) {
      return Cadastro.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    cadastro = widget.cadastro;
    textFirstname.text = widget.cadastro.firstName;
    textLastname.text = widget.cadastro.lastName;
    textPhone.text = widget.cadastro.phone;
    textDDD.text = widget.cadastro.ddd;
    textCep.text = widget.cadastro.cep;
    textLocalidade.text = widget.cadastro.localidade;
    textUf.text = widget.cadastro.uf;
    textBairro.text = widget.cadastro.bairro;
    return Center(
        child:
            /* ,*/
            Card(
                margin: const EdgeInsets.all(16.0),
                child: SafeArea(
                  child: ListView(
                    children: <Widget>[
                      if (statusProgress)
                        LinearProgressIndicator(
                          value: controller.value,
                          semanticsLabel: 'Linear progress indicator',
                        ),
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
                              onPressed: () {
                                setState(() {
                                  statusProgress = true;
                                });
                                fetchUpdate(
                                        http.Client(),
                                        widget.cadastro.user,
                                        textFirstname.text,
                                        textLastname.text,
                                        textPhone.text,
                                        textDDD.text,
                                        textCep.text,
                                        textLocalidade.text,
                                        textUf.text,
                                        textBairro.text)
                                    .then((value) => {
                                          setState(() {
                                            statusProgress = false;
                                          }),
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: const Text(
                                                'Dados atualizados com sucesso'),
                                            action: SnackBarAction(
                                              label: 'Ok',
                                              onPressed: () {
                                                // Some code to undo the change.
                                              },
                                            ),
                                          ))
                                        })
                                    .catchError((onError) => {
                                          setState(() {
                                            statusProgress = false;
                                          }),
                                          // ignore: invalid_return_type_for_catch_error
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: const Text(
                                                'Ops! algo deu errado: '),
                                            action: SnackBarAction(
                                              label: 'Sair',
                                              onPressed: () {
                                                // Some code to undo the change.
                                              },
                                            ),
                                          ))
                                        });
                              },
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
