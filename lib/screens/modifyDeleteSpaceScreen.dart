import 'package:domotica_mimmo/components/TextFieldBottomSheet.dart';
import 'package:domotica_mimmo/customClasses/NetworkHelper.dart';
import 'package:domotica_mimmo/customClasses/Spazio.dart';
import 'package:domotica_mimmo/models/SpaziData.dart';
import 'package:domotica_mimmo/sqLite/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModifyDeleteSpaceScreen extends StatefulWidget {
  @override
  _ModifyDeleteSpaceScreenState createState() =>
      _ModifyDeleteSpaceScreenState();
}

class _ModifyDeleteSpaceScreenState extends State<ModifyDeleteSpaceScreen> {
  DBHelper dbHelper = DBHelper();
  NetworkHelper networkHelper = NetworkHelper();
  String newNomeSpazio = '';
  String newIpInterno = '';
  String newIpEsterno = '';
  bool? newUsaIpInterno;

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
            'Modifica o elimina spazio',
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.lightBlueAccent,
            ),
          ),
          TextFieldBottomSheet(
            hintText: 'Nuovo nome: ${context.read<SpaziData>().spazioToModify}',
            initialText: context.read<SpaziData>().spazioToModify.nomeSpazio,
            onChanged: (newValue) {
              setState(() {
                newNomeSpazio = newValue;
              });
            },
          ),
          TextFieldBottomSheet(
            hintText:
                'Nuovo Ip Interno: ${context.read<SpaziData>().spazioToModify.ipInterno}',
            initialText: context.read<SpaziData>().spazioToModify.ipInterno,
            onChanged: (newValue) {
              setState(() {
                newIpInterno = newValue;
              });
            },
          ),
          TextFieldBottomSheet(
            hintText:
                'Nuovo Ip Esterno: ${context.read<SpaziData>().spazioToModify.ipEsterno}',
            initialText: context.read<SpaziData>().spazioToModify.ipEsterno,
            onChanged: (newValue) {
              setState(() {
                newIpEsterno = newValue;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Usa ip interno',
                style: TextStyle(fontSize: 16.0),
              ),
              Checkbox(
                value: newUsaIpInterno == null
                    ? context.read<SpaziData>().spazioToModify.ipUtilizzato == 1
                        ? true
                        : false
                    : newUsaIpInterno,
                onChanged: (newValue) {
                  setState(() {
                    newUsaIpInterno = newValue;
                  });
                },
              )
            ],
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
                  Spazio spazioAggiornato = Spazio(
                      id: context.read<SpaziData>().spazioToModify.id,
                      nomeSpazio: newNomeSpazio == ''
                          ? context.read<SpaziData>().spazioToModify.nomeSpazio
                          : newNomeSpazio,
                      ipInterno: newIpInterno == ''
                          ? context.read<SpaziData>().spazioToModify.ipInterno
                          : newIpInterno,
                      ipEsterno: newIpEsterno == ''
                          ? context.read<SpaziData>().spazioToModify.ipEsterno
                          : newIpEsterno,
                      ipUtilizzato: newUsaIpInterno == null
                          ? (context
                              .read<SpaziData>()
                              .spazioToModify
                              .ipUtilizzato)
                          : (newUsaIpInterno == true ? 1 : 0));
                  if (newNomeSpazio != '') {
                    //aggiorno oggetti e stanze legate
                    await dbHelper.updateRoomsObjectsNames(spazioAggiornato);
                  }
                  if (newIpInterno != '' || newIpEsterno != '') {
                    //aggiorno ip oggetti uguali allo spazio
                    await dbHelper.updateObjectsIp(spazioAggiornato);
                  }

                  await dbHelper.updateSpazio(spazioAggiornato);

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
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () async {
                  await dbHelper.deleteSpazio(
                      context.read<SpaziData>().spazioToModify.id ?? 0,
                      context.read<SpaziData>().spazioToModify.nomeSpazio ??
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
