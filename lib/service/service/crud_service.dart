
import 'package:app_qrcode_login/service/interceptor/Interceptor.dart';

import 'Crud.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

class CrudService<T> extends Crud   {
  
  final String baseUrl;
  String API = 'http://192.168.1.12:3000';

  CrudService(this.baseUrl);

  final http.Client _client = InterceptedClient.build(
    interceptors: [HttpInterceptor()],
  );

  @override
  Future<String> getAll()  async {
    final response = await _client.get(Uri.parse(API +''+ baseUrl));
    return response.body;
  }



}

