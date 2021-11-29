import 'package:app_qrcode_login/authentication_firebase_logic.dart';
import 'package:app_qrcode_login/dashboard_screen.dart';
import 'package:app_qrcode_login/home.dart';
import 'package:app_qrcode_login/login_screen.dart';
import 'package:app_qrcode_login/scan_screen.dart';
import 'package:app_qrcode_login/transition_route_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.orange),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple)
            .copyWith(secondary: Colors.orange),
      ),
      darkTheme: ThemeData.dark(),
      navigatorObservers: [TransitionRouteObserver()],
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        DashboardScreen.routeName: (context) => DashboardScreen(
              title: '',
            ),
      },
    );
  }
}
