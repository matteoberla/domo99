// ignore_for_file: unnecessary_import

import 'package:domotica_mimmo/components/TextFieldBottomSheet.dart';
import 'package:domotica_mimmo/components/tipologieStanzeOggetti.dart';
import 'package:domotica_mimmo/customClasses/NetworkHelper.dart';
import 'package:domotica_mimmo/customClasses/Oggetto.dart';
import 'package:domotica_mimmo/customClasses/SelectTypeWidget.dart';
import 'package:domotica_mimmo/models/OggettiData.dart';
import 'package:domotica_mimmo/sqLite/dbHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

class ModifyDeleteObjectScreen extends StatefulWidget {
  @override
  _ModifyDeleteObjectScreenState createState() =>
      _ModifyDeleteObjectScreenState();
}

class _ModifyDeleteObjectScreenState extends State<ModifyDeleteObjectScreen> {
  SelectTypeWidget selectTypeWidget = SelectTypeWidget();
  DBHelper dbHelper = DBHelper();
  NetworkHelper networkHelper = NetworkHelper();
  String newNomeOggetto = '';
  String newTipoOggetto = tipiOggetti.first;
  String newIpInterno = '';
  String newIpEsterno = '';
  String newEstensione = '';
  String newRisposta = '';

  @override
  void initState() {
    super.initState();
    newTipoOggetto =
        context.read<OggettiData>().oggettoToModify.tipoOggetto ?? "";
  }

  void onChangedCallback(String tipo) {
    setState(() {
      newTipoOggetto = tipo;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(30.0),
      decoration: BoxDecoration(
          color: isDark ? Colors.black87 : Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0))),
      child: Column(
        children: [
          Text(
            'Modifica o elimina oggetto',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.lightBlueAccent,
            ),
          ),
          TextFieldBottomSheet(
            hintText:
                'Nuovo nome: ${context.read<OggettiData>().oggettoToModify.nomeOggetto}',
            initialText:
                context.read<OggettiData>().oggettoToModify.nomeOggetto,
            onChanged: (newValue) {
              setState(() {
                newNomeOggetto = newValue;
              });
            },
          ),
          Container(
            height: 50,
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              color: Colors.lightBlueAccent,
            ),
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Platform.isIOS
                ? selectTypeWidget.iOSPickerObject(
                    onChangedCallback, tipiOggetti.indexOf(newTipoOggetto))
                : selectTypeWidget.androidDropdownObject(
                    newTipoOggetto, onChangedCallback),
          ),
          TextFieldBottomSheet(
            hintText:
                'Nuovo ip interno: ${context.read<OggettiData>().oggettoToModify.ipInterno}',
            initialText: context.read<OggettiData>().oggettoToModify.ipInterno,
            onChanged: (newValue) {
              setState(() {
                newIpInterno = newValue;
              });
            },
          ),
          TextFieldBottomSheet(
            hintText:
                'Nuovo ip esterno: ${context.read<OggettiData>().oggettoToModify.ipEsterno}',
            initialText: context.read<OggettiData>().oggettoToModify.ipEsterno,
            onChanged: (newValue) {
              setState(() {
                newIpEsterno = newValue;
              });
            },
          ),
          TextFieldBottomSheet(
            hintText:
                'Nuova estensione: ${context.read<OggettiData>().oggettoToModify.estensione}',
            initialText: context.read<OggettiData>().oggettoToModify.estensione,
            onChanged: (newValue) {
              setState(() {
                newEstensione = newValue;
              });
            },
          ),
          TextFieldBottomSheet(
            hintText:
                'Nuova risposta: ${context.read<OggettiData>().oggettoToModify.risposta}',
            initialText: context.read<OggettiData>().oggettoToModify.risposta,
            onChanged: (newValue) {
              setState(() {
                newRisposta = newValue;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Text(
                  'Aggiorna',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                ),
                onPressed: () async {
                  Oggetto oggettoAggiornato = Oggetto(
                      id: context.read<OggettiData>().oggettoToModify.id,
                      spazioParente: context
                          .read<OggettiData>()
                          .oggettoToModify
                          .spazioParente,
                      stanzaParente: context
                          .read<OggettiData>()
                          .oggettoToModify
                          .stanzaParente,
                      nomeOggetto: newNomeOggetto == ''
                          ? context
                              .read<OggettiData>()
                              .oggettoToModify
                              .nomeOggetto
                          : newNomeOggetto,
                      tipoOggetto: newTipoOggetto == ''
                          ? context
                              .read<OggettiData>()
                              .oggettoToModify
                              .tipoOggetto
                          : newTipoOggetto,
                      ipInterno: newIpInterno == ''
                          ? context
                              .read<OggettiData>()
                              .oggettoToModify
                              .ipInterno
                          : newIpInterno,
                      ipEsterno: newIpEsterno == ''
                          ? context
                              .read<OggettiData>()
                              .oggettoToModify
                              .ipEsterno
                          : newIpEsterno,
                      estensione: newEstensione == ''
                          ? context
                              .read<OggettiData>()
                              .oggettoToModify
                              .estensione
                          : newEstensione,
                      risposta: newRisposta == ''
                          ? context.read<OggettiData>().oggettoToModify.risposta
                          : newRisposta);
                  await dbHelper.updateOggetto(oggettoAggiornato);
                  bool updated = true;

                  if (updated) {
                    Navigator.pop(context);
                  }
                },
              ),
              SizedBox(
                width: 20.0,
              ),
              TextButton(
                child: Text(
                  'Elimina',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                ),
                onPressed: () async {
                  dbHelper.deleteOggetto(
                      context.read<OggettiData>().oggettoSelected.id ?? 0,
                      context
                              .read<OggettiData>()
                              .oggettoSelected
                              .spazioParente ??
                          "",
                      context
                              .read<OggettiData>()
                              .oggettoSelected
                              .stanzaParente ??
                          "");
                  bool deleted = true;

                  if (deleted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
