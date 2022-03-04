import 'dart:convert';
import 'dart:html';

import 'package:app_qrcode_login/bussines/notas.dart';
import 'package:app_qrcode_login/service/service/crud_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../flutter_login.dart';


class Authentication {
   

  Future<String?> _loginUser(context, LoginData data) async {
    try {

      var methods = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }


}