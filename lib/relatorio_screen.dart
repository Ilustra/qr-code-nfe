import 'dart:convert';
import 'dart:math';
import 'package:app_qrcode_login/bussines/chart_month.dart';
import 'package:app_qrcode_login/bussines/notas.dart';
import 'package:app_qrcode_login/detalhe_nota.dart';
import 'package:app_qrcode_login/relatorio_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class RelatorioScren extends StatefulWidget {
  @override
  _RelatorioScren createState() => _RelatorioScren();
}

Future<List<Nota>> fecthNotas(
    http.Client client, String start, String end, String userId) async {
  final response = await client.post(
      Uri.parse('http://192.168.1.16:3000/notas/month/'),
      body: {'userId': userId, 'start': start, 'end': end});

  if (response.statusCode == 200) {
    return compute(parseItem, response.body);
  } else {
    throw Exception(response.statusCode);
  }
}

// A function that converts a response body into a List<Photo>.
List<Nota> parseItem(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Nota>((json) => Nota.fromJson(json)).toList();
}

class _RelatorioScren extends State<RelatorioScren> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Relatório'),
        ),
        body: FutureBuilder<List<Nota>>(
          future: fecthNotas(http.Client(), '1-1-2020', '12-30-2024',
              "6006e22185e1c7001e4766af"),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              return ItemNota(notas: snapshot.data!);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

class ItemNota extends StatefulWidget {
  final notas;
  ItemNota({Key? key, required this.notas}) : super(key: key) {}
  @override
  _ItemNota createState() => _ItemNota();
}

class _ItemNota extends State<ItemNota> {
  DateTime _date = DateTime(2021, 1, 1);
  late List<Nota> _notas = widget.notas;
  late DateTime startDate = DateTime(2021, 1, 1);
  late DateTime endDate = DateTime(2021, 1, 1);

  void _selectStartDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000, 1),
      lastDate: DateTime(2040, 7),
      helpText: 'Selecione uma data',
    );

    setState(() {
      startDate = newDate!;
    });
  }

  void _selectEnddate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000, 1),
      lastDate: DateTime(2040, 7),
      helpText: 'Selecione uma data',
    );

    setState(() {
      endDate = newDate!;
    });
  }

  late AnimationController controller;
  bool statusProgress = false;
  void _filtrarNotas(String _id) async {
    var _start = "" +
        startDate.month.toString() +
        "-" +
        startDate.day.toString() +
        "-" +
        startDate.year.toString();
    var _end = "" +
        endDate.month.toString() +
        "-" +
        endDate.day.toString() +
        "-" +
        endDate.year.toString();
    setState(() {
      statusProgress = true;
    });
    await fecthNotas(http.Client(), _start, _end, _id)
        .then(
          (value) => {
            setState(() {
              statusProgress = false;
              _notas = value;
            }),
          },
        )
        .catchError((onError) => {
              setState(() {
                statusProgress = false;
              }),
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('error: '),
                action: SnackBarAction(
                  label: 'Ok',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              ))
            });
  }

  formatMoeda(double valor) {
    final formatter = new NumberFormat("#,###.##");
    double value = valor;
    return formatter.format(value);
  }

  String getTotal(List<Nota> nota_) {
    var total = 0.0;
    if (nota_.length > 0)
      for (Nota item in nota_) {
        total += item.total;
      }
    return '' + formatMoeda(total).toString();
  }

  List<ChartRelatorio> chartRelatorio(List<Nota> nota_) {
    List<ChartRelatorio> list = [];

    var date_ = DateTime.parse(nota_[0].emissao);

    Color colors = Colors.primaries[Random().nextInt(Colors.primaries.length)];

    late ChartRelatorio newObject = ChartRelatorio(
        year: date_.year,
        month: date_.month,
        total: nota_[0].total,
        barColor: charts.ColorUtil.fromDartColor(colors));

    list.add(newObject);

    for (Nota item in nota_) {
      var i = 0;
      var date_ = DateTime.parse(item.emissao);
      if (list[0].month == date_.month) {
        newObject.somaTotal(item.total);
      } else {
        late ChartRelatorio newObject = ChartRelatorio(
            year: date_.year,
            month: date_.month,
            total: item.total,
            barColor: charts.ColorUtil.fromDartColor(colors));
        list.add(newObject);
        i++;
      }
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    if (statusProgress) {
      return Center(
          child: Column(
        children: <Widget>[CircularProgressIndicator(), Text('Aguarde...')],
      ));
    } else {
      return SafeArea(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                if (statusProgress)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(DateFormat("'De:' dd/MM/yyyy").format(startDate)),
                    IconButton(
                      icon: const Icon(Icons.event),
                      tooltip: 'Buscar',
                      onPressed: _selectStartDate,
                    ),
                    Text(DateFormat("'até:' dd/MM/yyyy").format(endDate)),
                    IconButton(
                      icon: const Icon(Icons.event),
                      tooltip: 'Buscar',
                      onPressed: _selectEnddate,
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      tooltip: 'Buscar',
                      onPressed: () {
                        _filtrarNotas('6006e22185e1c7001e4766af');
                      },
                    ),
                  ],
                ),
                Container(
                  height: 400,
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: RelatorioChart(
                              data: chartRelatorio(_notas),
                            ),
                          ),
                          Text(
                            '\$ ' + getTotal(_notas),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.normal,
                                fontFamily: 'Open Sans',
                                fontSize: 32),
                          ),
                          Text(
                            'total',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.blueGrey[500],
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontFamily: 'Open Sans',
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: _notas.length,
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
                                            DetalheNota(nota: _notas[index])),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              _notas[index]
                                                      .getName()
                                                      .substring(0, 20) +
                                                  '...',
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style
                                                      .apply(
                                                          fontSizeFactor: 1.3),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              DateFormat(
                                                      "dd 'de' MMMM 'de' yyyy'")
                                                  .format(
                                                      _notas[index].getDate()),
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style
                                                      .apply(
                                                          fontSizeFactor: 1.0),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            _notas[index].getTotal(),
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
                ))
              ],
            )),
      );
    }
  }
}
