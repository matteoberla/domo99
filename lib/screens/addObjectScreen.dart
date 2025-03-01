// ignore_for_file: unnecessary_import

import 'package:domotica_mimmo/components/TextFieldBottomSheet.dart';
import 'package:domotica_mimmo/components/tipologieStanzeOggetti.dart';
import 'package:domotica_mimmo/customClasses/NetworkHelper.dart';
import 'package:domotica_mimmo/customClasses/Oggetto.dart';
import 'package:domotica_mimmo/customClasses/SelectTypeWidget.dart';
import 'package:domotica_mimmo/models/SpaziData.dart';
import 'package:domotica_mimmo/models/StanzeData.dart';
import 'package:domotica_mimmo/sqLite/dbHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

class AddObjectScreen extends StatefulWidget {
  @override
  _AddObjectScreenState createState() => _AddObjectScreenState();
}

class _AddObjectScreenState extends State<AddObjectScreen> {
  SelectTypeWidget selectTypeWidget = SelectTypeWidget();
  DBHelper dbHelper = DBHelper();
  NetworkHelper networkHelper = NetworkHelper();
  String nomeOggetto = '';
  String tipoOggetto = tipiOggetti.first;
  String ipInterno = '';
  String ipEsterno = '';
  String estensione = '';
  String risposta = '';

  void onChangedCallback(String tipo) {
    setState(() {
      tipoOggetto = tipo;
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
            'Nuovo oggetto',
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.lightBlueAccent,
            ),
          ),
          TextFieldBottomSheet(
            hintText: 'Nome del nuovo oggetto',
            onChanged: (newValue) {
              setState(() {
                nomeOggetto = newValue;
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
                    onChangedCallback, tipiOggetti.indexOf(tipoOggetto))
                : selectTypeWidget.androidDropdownObject(
                    tipoOggetto, onChangedCallback),
          ),
          TextFieldBottomSheet(
            hintText:
                'Ip interno: ${context.read<SpaziData>().spazioSelected.ipInterno}',
            onChanged: (newValue) {
              setState(() {
                ipInterno = newValue;
              });
            },
          ),
          TextFieldBottomSheet(
            hintText:
                'Ip esterno: ${context.read<SpaziData>().spazioSelected.ipEsterno}',
            onChanged: (newValue) {
              setState(() {
                ipEsterno = newValue;
              });
            },
          ),
          TextFieldBottomSheet(
            hintText: 'Estensione ip',
            onChanged: (newValue) {
              setState(() {
                estensione = newValue;
              });
            },
          ),
          TextFieldBottomSheet(
            hintText: 'Risposta dal sito',
            onChanged: (newValue) {
              setState(() {
                risposta = newValue;
              });
            },
          ),
          TextButton(
            child: Text(
              'Aggiungi',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
            ),
            onPressed: () async {
              Oggetto nuovoOggetto = Oggetto(
                  spazioParente:
                      context.read<SpaziData>().spazioSelected.nomeSpazio,
                  stanzaParente:
                      context.read<StanzeData>().stanzaSelected.nomeStanza,
                  nomeOggetto: nomeOggetto,
                  tipoOggetto: tipoOggetto,
                  ipInterno: ipInterno == ''
                      ? context.read<SpaziData>().spazioSelected.ipInterno
                      : ipInterno,
                  ipEsterno: ipEsterno == ''
                      ? context.read<SpaziData>().spazioSelected.ipEsterno
                      : ipEsterno,
                  estensione: estensione,
                  risposta: risposta);
              await dbHelper.saveOggetto(nuovoOggetto);

              bool added = true;
//              bool added = await networkHelper.addObjectSuccess(
//                  user: widget.nomeUtente,
//                  parentSpace: widget.spazioParente,
//                  parentRoom: widget.stanzaParente,
//                  objectName: nomeOggetto,
//                  objectType: tipoOggetto,
//                  internalIp: ipInterno == '' ? widget.ipInterno : ipInterno,
//                  externalIp: ipEsterno == '' ? widget.ipEsterno : ipEsterno,
//                  extension: estensione,
//                  responseSite: risposta);

              if (added) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
