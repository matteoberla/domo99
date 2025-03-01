// ignore_for_file: unnecessary_import

import 'package:domotica_mimmo/components/TextFieldBottomSheet.dart';
import 'package:domotica_mimmo/components/tipologieStanzeOggetti.dart';
import 'package:domotica_mimmo/customClasses/NetworkHelper.dart';
import 'package:domotica_mimmo/customClasses/SelectTypeWidget.dart';
import 'package:domotica_mimmo/customClasses/Stanza.dart';
import 'package:domotica_mimmo/models/StanzeData.dart';
import 'package:domotica_mimmo/sqLite/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

class ModifyDeleteRoomScreen extends StatefulWidget {
  @override
  _ModifyDeleteRoomScreenState createState() => _ModifyDeleteRoomScreenState();
}

class _ModifyDeleteRoomScreenState extends State<ModifyDeleteRoomScreen> {
  SelectTypeWidget selectTypeWidget = SelectTypeWidget();
  DBHelper dbHelper = DBHelper();
  NetworkHelper networkHelper = NetworkHelper();
  String newNomeStanza = '';
  String newTipoStanza = tipiStanze.first;

  @override
  void initState() {
    super.initState();
    newTipoStanza = context.read<StanzeData>().stanzaToModify.tipoStanza ?? "";
  }

  void onChangedCallback(String tipo) {
    setState(() {
      newTipoStanza = tipo;
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
            'Modifica o elimina stanza',
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.lightBlueAccent,
            ),
          ),
          TextFieldBottomSheet(
            hintText:
                'Nuovo nome: ${context.read<StanzeData>().stanzaToModify.nomeStanza}',
            initialText: context.read<StanzeData>().stanzaToModify.nomeStanza,
            onChanged: (newValue) {
              setState(() {
                newNomeStanza = newValue;
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
                ? selectTypeWidget.iOSPickerRoom(
                    onChangedCallback, tipiStanze.indexOf(newTipoStanza))
                : selectTypeWidget.androidDropdownRoom(
                    newTipoStanza, onChangedCallback),
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
                  Stanza stanzaAggiornata = Stanza(
                      id: context.read<StanzeData>().stanzaToModify.id,
                      spazioParente: context
                          .read<StanzeData>()
                          .stanzaToModify
                          .spazioParente,
                      nomeStanza: newNomeStanza == ''
                          ? context.read<StanzeData>().stanzaToModify.nomeStanza
                          : newNomeStanza,
                      tipoStanza: newTipoStanza == ''
                          ? context.read<StanzeData>().stanzaToModify.nomeStanza
                          : newTipoStanza);
                  if (newNomeStanza != '') {
                    await dbHelper.updateObjectsNames(stanzaAggiornata);
                  }
                  await dbHelper.updateStanza(stanzaAggiornata);
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
                  await dbHelper.deleteStanza(
                      context.read<StanzeData>().stanzaToModify.id ?? 0,
                      context.read<StanzeData>().stanzaToModify.spazioParente ??
                          "",
                      context.read<StanzeData>().stanzaToModify.nomeStanza ??
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
