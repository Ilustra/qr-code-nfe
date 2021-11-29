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
      'http://192.168.1.15:3000/notas/dashotas/6006e22185e1c7001e4766af'));

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
                        height: 300,
                        child: Card(
                          margin: const EdgeInsets.all(8.0),
                          elevation: 3,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: DeveloperChart(
                                    data: snapshot.data!,
                                  ),
                                ),
                                Text(
                                  '\$ ' + getTotal(snapshot.data),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.blueGrey,
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
                      )
                    ],
                  ),
                  ItemList(items: snapshot.data!)
                ]);
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
    return ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Center(
          child: Card(
            margin: EdgeInsets.all(4.0),
            elevation: 2,
            child: ListTile(
              leading: Container(
                margin: const EdgeInsets.all(10.0),
                color: items[index].color,
                width: 10,
              ),
              title: Text(
                items[index].getName(),
              ),
              trailing: Text(
                items[index].getTotal(),
              ),
            ),
          ),
        );
      },
    );
  }
}
