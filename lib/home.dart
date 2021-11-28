import 'package:app_qrcode_login/dashboard_screen.dart';
import 'package:app_qrcode_login/exemple_cahrts.dart';
import 'package:app_qrcode_login/perfil.dart';
import 'package:app_qrcode_login/nota_screen.dart';
import 'package:app_qrcode_login/scan_screen.dart';
import 'package:flutter/material.dart';

/// This is the main application widget.
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Despensa'),
      ),
      body: Center(
        child: DashboardScreen(
          title: 'Home',
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PerfilScreen()),
                  );
                }),
            ListTile(
                leading: Icon(Icons.receipt),
                title: Text('Notas'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Notas(
                              title: '',
                            )),
                  );
                }),
            ListTile(
                leading: Icon(Icons.show_chart),
                title: Text('Relatório'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Notas(
                              title: '',
                            )),
                  );
                }),
            ListTile(
                leading: Icon(Icons.qr_code_scanner),
                title: Text('Escanear nota'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRViewExample()),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
