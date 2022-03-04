import 'dart:convert';

import 'package:app_qrcode_login/bussines/dashboard.dart';
import 'package:app_qrcode_login/bussines/notas.dart';
import 'package:app_qrcode_login/service/service/crud_service.dart';
import 'package:flutter/foundation.dart';

class NotasService extends CrudService<Nota>{
   
   NotasService() : super('/notas/6006e22185e1c7001e4766af');
  Future<List<Nota>> findAll() async {
    final response = await super.getAll();
    return compute(parseItem, response);
  }
  // A function that converts a response body into a List<Photo>.
  List<Nota> parseItem(String body) {
  final parsed = jsonDecode(body).cast<Map<String, dynamic>>();

  return parsed.map<Nota>((json) => Nota.fromJson(json)).toList();
  }

}