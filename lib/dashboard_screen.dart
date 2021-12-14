import 'dart:convert';
import 'package:app_qrcode_login/bussines/dashboard.dart';
import 'package:app_qrcode_login/bussines/developer_chart.dart';
import 'package:app_qrcode_login/exemple_cahrts.dart';
import 'package:app_qrcode_login/src/providers/login_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

Future<List<Dashboard>> fetchDash(http.Client client) async {
  final response = await client.get(Uri.parse(
      'http://192.168.1.16:3000/notas/dashotas/6006e22185e1c7001e4766af'));

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseDarsh, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Dashboard> parseDarsh(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Dashboard>((json) => Dashboard.fromJson(json)).toList();
}

class DashboardScreen extends StatefulWidget {
  static const routeName = '/home';

  DashboardScreen({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  _DashboardScreen createState() => _DashboardScreen();
}

class _DashboardScreen extends State<DashboardScreen> {
  var total = 0.0;

  formatMoeda(double valor) {
    final formatter = new NumberFormat("#,###.##");
    double value = valor;
    return formatter.format(value);
  }

  String getTotal(items) {
    double total = 0;
    for (Dashboard item in items) total += item.total;
    return formatMoeda(total).toString();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      body: FutureBuilder<List<Dashboard>>(
        future: fetchDash(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: 200,
                      color: Colors.blue.shade700,
                      child: Card(
                        color: Colors.blue,
                        margin: const EdgeInsets.all(8.0),
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'R\$ ' + getTotal(snapshot.data),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Open Sans',
                                    fontSize: 62),
                              ),
                              Text(
                                'valor gasto até o momento',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Open Sans',
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: ItemList(items: snapshot.data!),
                ),
                Expanded(
                  child: DeveloperChart(
                    data: snapshot.data!,
                  ),
                )
              ],
            );
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
  ItemList({Key? key, required this.items}) : super(key: key);

  final List<Dashboard> items;
  List<Dashboard> c = [];

  var total = 0;
  formatMoeda(double valor) {
    final formatter = new NumberFormat("#,###.##");

    double value = valor;

    return formatter.format(value);
  }

  String getTotal() {
    double total = 0;
    for (Dashboard item in items) {
      total += item.total;
    }
    return formatMoeda(total).toString();
  }

  @override
  Widget build(BuildContext context) {
    late List<Dashboard> lista = items;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
            color: Colors.blue.shade600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(0.0),
                  color: items[index].color,
                  height: 5,
                ),
                Text(items[index].getName(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Open Sans',
                        fontSize: 14)),
                Center(
                    child: Text(items[index].getTotal(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Open Sans',
                            fontSize: 22))),
                Container(
                  margin: const EdgeInsets.all(0.0),
                  color: items[index].color,
                  height: 0,
                ),
              ],
            ));
      },
    );
  }
}
