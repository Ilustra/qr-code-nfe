class Cadastro {
  final String user;
  final String firstName;
  final String lastName;
  final String ddd;
  final String phone;
  final String cep;
  final String localidade;
  final String bairro;
  final String uf;

  Cadastro({
    required this.user,
    required this.firstName,
    required this.lastName,
    required this.ddd,
    required this.phone,
    required this.cep,
    required this.localidade,
    required this.bairro,
    required this.uf,
  });

  factory Cadastro.fromJson(Map<String, dynamic> json) {
    return Cadastro(
      user: json['user'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      ddd: json['ddd'],
      phone: json['phone'],
      cep: json['cep'],
      localidade: json['localidade'],
      bairro: json['bairro'],
      uf: json['uf'],
    );
  }
}
