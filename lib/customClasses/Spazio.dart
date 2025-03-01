class Spazio {
  int? id;
  final String? nomeSpazio;
  final String? ipEsterno;
  final String? ipInterno;
  final int? ipUtilizzato;

  Spazio(
      {this.id,
      this.nomeSpazio,
      this.ipEsterno,
      this.ipInterno,
      this.ipUtilizzato});

  factory Spazio.fromJson(Map<String, dynamic> json) => Spazio(
        nomeSpazio: json['nomeSpazio'],
        ipEsterno: json['ipEsternoSpazio'],
        ipInterno: json['ipInternoSpazio'],
        ipUtilizzato: int.parse(json['isIpInterno']),
      );

  Map<String, dynamic> toJson() => {
        'nomeSpazio': nomeSpazio,
        'ipEsternoSpazio': ipEsterno,
        'ipInternoSpazio': ipInterno,
        'isIpInterno': ipUtilizzato,
      };

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'nomeSpazio': nomeSpazio,
      'ipEsternoSpazio': ipEsterno,
      'ipInternoSpazio': ipInterno,
      'isIpInterno': ipUtilizzato
    };
    return map;
  }

  factory Spazio.fromMap(Map<String, dynamic> map) => Spazio(
        id: map['id'],
        nomeSpazio: map['nomeSpazio'],
        ipEsterno: map['ipEsternoSpazio'],
        ipInterno: map['ipInternoSpazio'],
        ipUtilizzato: map['isIpInterno'],
      );
}
