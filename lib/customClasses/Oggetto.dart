import 'package:flutter/material.dart';

class Oggetto {
  int? id;
  final String? nomeOggetto;
  final String? tipoOggetto;
  final String? spazioParente;
  final String? stanzaParente;
  final String? ipInterno;
  final String? ipEsterno;
  final String? estensione;
  final String? risposta;
  Color colore = Colors.red;

  Oggetto({
    this.id,
    this.nomeOggetto,
    this.tipoOggetto,
    this.spazioParente,
    this.stanzaParente,
    this.ipInterno,
    this.ipEsterno,
    this.estensione,
    this.risposta,
  });

  factory Oggetto.fromJson(Map<String, dynamic> json) => Oggetto(
        nomeOggetto: json['nomeOggetto'],
        tipoOggetto: json['tipoOggetto'],
        spazioParente: json['nomeSpazioParente'],
        stanzaParente: json['nomeStanzaParente'],
        ipInterno: json['ipInternoOggetto'],
        ipEsterno: json['ipEsternoOggetto'],
        estensione: json['estensioneOggetto'],
        risposta: json['rispostaOggetto'],
      );

  factory Oggetto.fromMap(Map<String, dynamic> map) => Oggetto(
        id: map['id'],
        nomeOggetto: map['nomeOggetto'],
        tipoOggetto: map['tipoOggetto'],
        spazioParente: map['nomeSpazioParente'],
        stanzaParente: map['nomeStanzaParente'],
        ipInterno: map['ipInternoOggetto'],
        ipEsterno: map['ipEsternoOggetto'],
        estensione: map['estensioneOggetto'],
        risposta: map['rispostaOggetto'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'nomeOggetto': nomeOggetto,
      'tipoOggetto': tipoOggetto,
      'nomeSpazioParente': spazioParente,
      'nomeStanzaParente': stanzaParente,
      'ipInternoOggetto': ipInterno,
      'ipEsternoOggetto': ipEsterno,
      'estensioneOggetto': estensione,
      'rispostaOggetto': risposta,
    };
    return map;
  }
}
