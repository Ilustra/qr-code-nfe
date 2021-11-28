import 'package:app_qrcode_login/constants.dart';
import 'package:app_qrcode_login/flutter_login.dart';
import 'package:app_qrcode_login/home.dart';
import 'package:app_qrcode_login/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  ///realizar login from firebase
  Future<String?> _loginUser(context, LoginData data) async {
    try {
      // Add from here
      // to here.
      var methods = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );

      return null;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e.message;
    }
  }

  ///
  Future<String?> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(name)) {
        return 'Ops! sintimos muito mas essa funcionalidade ainda está sendo implementada';
      }
      return 'Ops! sintimos muito mas essa funcionalidade ainda está sendo implementada';
    });
  }

  //
  Future<String?> registerAccount(
    String email,
    String displayName,
    String password,
  ) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateProfile(displayName: displayName);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: Constants.appName,
      // logo: 'assets/images/icon.png',
      logoTag: Constants.logoTag,
      titleTag: Constants.titleTag,
      navigateBackAfterRecovery: true,
      /* loginProviders: [
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: () async {
            print('start google sign in');
            await Future.delayed(loginTime);
            print('stop google sign in');
            return '';
          },
        ),
      ],*/
      userValidator: (value) {
        if (!value!.contains('@') || !value.endsWith('.com'))
          return "Email must contain '@' and end with '.com'";
        return null;
      },
      displayNameValidator: (value) {
        if (value!.isEmpty) return 'Name is empty';
        return null;
      },
      passwordValidator: (value) {
        if (value!.isEmpty) return 'Password is empty';
        return null;
      },
      onLogin: (loginData) {
        print('Informações do login');
        return _loginUser(context, loginData);
      },
      onSignup: (loginData) {
        print('Signup info');
        return registerAccount(
            loginData.name, loginData.displayName, loginData.password);
      },
      onSubmitAnimationCompleted: () {
        /*Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => DashboardScreen(),
        ));*/
      },
      onRecoverPassword: (name) {
        print('Recover password info');
        print('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
    );
  }
}
