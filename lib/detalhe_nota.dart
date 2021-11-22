import 'dart:convert';

import 'package:app_qrcode_login/bussines/notas.dart';
import 'package:app_qrcode_login/bussines/produto.dart';
import 'package:app_qrcode_login/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<List<Produto>> fetchProdutos(String list) async {
  return compute(parseProduto, list);
}

List<Produto> parseProduto(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<Produto>((json) => Produto.fromJson(
          jsonDecode(responseBody).cast<Map<String, dynamic>>()))
      .toList();
}

class DetalheNota extends StatelessWidget {
  final Nota nota;
  const DetalheNota({Key? key, required this.nota}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nota.getName()),
      ),
      body: SingleChildScrollView(
        child: DataTableWidget(produto: nota.produtos),
      ),
    );
  }
}

class SSS extends StatelessWidget {
  const SSS({Key? key, required this.produto}) : super(key: key);

  final Produto produto;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            margin: const EdgeInsets.all(5.0),
            child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            child: Text('${produto.nome}'),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[Text(produto.getTotal())],
                      ),
                    ],
                  ),
                ))));
  }
}

class ItemList extends StatelessWidget {
  const ItemList({Key? key, required this.produto}) : super(key: key);

  final Produto produto;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            margin: const EdgeInsets.all(5.0),
            child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            child: Text('${produto.nome}'),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[Text(produto.getTotal())],
                      ),
                    ],
                  ),
                ))));
  }
}

class DataTableWidget extends StatelessWidget {
  const DataTableWidget({Key? key, required this.produto}) : super(key: key);
  final List<Produto> produto;

//  DataTableWidget(this.listOfColumns);     // Getting the data from outside, on initialization
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Nome')),
        DataColumn(label: Text('Qtd')),
        DataColumn(label: Text('Valor')),
        DataColumn(label: Text('Total')),
      ],
      rows:
          produto // Loops through dataColumnText, each iteration assigning the value to element
              .map(
                ((element) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text(element.nome)),
                        DataCell(Text(element.quantidade.toString())),
                        DataCell(Text(element.getValor())),
                        DataCell(Text(element
                            .getTotal())), //Extracting from Map element the value
                      ],
                    )),
              )
              .toList(),
    );
  }
}
