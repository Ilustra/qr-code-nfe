// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:convert';
import 'package:intl/intl.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Card(
              child: Container(
                width: 500,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(nota.nome,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                      Text('CNPJ: ' + nota.cnpj),
                    ],
                  ),
                ),
              ),
            ),
            DataTableWidget(produto: nota.produtos),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Subtotal: ',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        Text(nota.getSubtotal(),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Desconto: ',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        Text(nota.getDesconto(),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // ignore: prefer_const_constructors
                        Text('Total: ',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        Text(nota.getTotal(),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ],
                    ),
                    Text(
                        'emissao: ' +
                            DateFormat("dd 'de' MMMM 'de' yyyy'").format(
                              nota.getDate(),
                            ),
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey)),
                    Text('Tributos: ' + nota.getTributos(),
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
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
                        DataCell(Text(element.getQuantidade())),
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
