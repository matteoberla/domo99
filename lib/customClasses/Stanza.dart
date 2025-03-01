class Stanza {
  Stanza({this.id, this.nomeStanza, this.spazioParente, this.tipoStanza});
  int? id;
  final String? nomeStanza;
  final String? spazioParente;
  final String? tipoStanza;

  factory Stanza.fromJson(Map<String, dynamic> json) => Stanza(
        nomeStanza: json['nomeStanza'],
        spazioParente: json['nomeSpazioParente'],
        tipoStanza: json['tipoStanza'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'nomeStanza': nomeStanza,
      'nomeSpazioParente': spazioParente,
      'tipoStanza': tipoStanza,
    };
    return map;
  }

  factory Stanza.fromMap(Map<String, dynamic> map) => Stanza(
        id: map['id'],
        nomeStanza: map['nomeStanza'],
        spazioParente: map['nomeSpazioParente'],
        tipoStanza: map['tipoStanza'],
      );
}
