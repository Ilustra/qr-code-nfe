class Produto {
  final String nome;
  final int quantidade;
  final String UN;
  final double valor;
  final double total;
  final String empresa;

  Produto({
    required this.nome,
    required this.quantidade,
    required this.UN,
    required this.valor,
    required this.total,
    required this.empresa,
  });

  factory Produto.fromJson(dynamic json) {
    return Produto(
      nome: json['nome'],
      quantidade: json['quantidade'].toInt(),
      UN: json['UN'],
      valor: json['valor'].toDouble(),
      total: json['total'].toDouble(),
      empresa: json['empresa'],
    );
  }
  String getTotal() {
    return '' + (total).toString();
  }

  String getValor() {
    return '' + (valor).toString();
  }
}
