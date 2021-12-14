import 'package:app_qrcode_login/bussines/produto.dart';

class Nota {
  final String nome;
  final String createdAt;
  final double total;
  final String numero;

  final String id;
  final String cnpj;
  final String rua;

  final String localidade;
  final String uf;
  final String bairro;

  final double tributos;
  final double descontos;
  final double subTotal;
  final String emissao;
  final List<Produto> produtos;

  Nota({
    required this.nome,
    required this.createdAt,
    required this.total,
    required this.numero,
    required this.id,
    required this.cnpj,
    required this.rua,
    required this.localidade,
    required this.uf,
    required this.bairro,
    required this.tributos,
    required this.descontos,
    required this.subTotal,
    required this.produtos,
    required this.emissao,
  });

  factory Nota.fromJson(Map<String, dynamic> json) {
    var tagObjsJson = json['produtos'] as List;
    List<Produto> _tags =
        tagObjsJson.map((tagJson) => Produto.fromJson(tagJson)).toList();
    return Nota(
        nome: json['nome'],
        createdAt: json['createdAt'],
        total: json['total'],
        numero: json['numero'],
        id: json['_id'],
        cnpj: json['cnpj'],
        rua: json['rua'],
        localidade: json['localidade'],
        uf: json['uf'],
        bairro: json['bairro'],
        tributos: json['tributos'].toDouble(),
        descontos: json['descontos'].toDouble(),
        subTotal: json['subTotal'].toDouble(),
        emissao: json['emissao'] as String,
        produtos: _tags);
  }

  String getName() {
    return '' + nome;
  }

  String getTotal() {
    return 'R\$ ' + total.toString();
  }

  DateTime getDate() {
    return DateTime.parse(createdAt);
  }
}
