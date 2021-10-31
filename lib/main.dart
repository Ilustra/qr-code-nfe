import 'package:app_qrcode_login/authentication_firebase_logic.dart';
import 'package:app_qrcode_login/login_screen.dart';
import 'package:app_qrcode_login/screen/scan_screen.dart';
import 'package:app_qrcode_login/transition_route_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

// Create a reference to the cities collection

void main() async {
  // Modify from here
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => MyApp(),
    ),
  );
  // to here.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Despensa',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      navigatorObservers: [TransitionRouteObserver()],
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        QRViewExample.routeName: (context) => QRViewExample(),
      },
    );
  }
}
