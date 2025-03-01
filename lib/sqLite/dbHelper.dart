import 'dart:async';
import 'dart:io' as io;
import 'package:domotica_mimmo/customClasses/Oggetto.dart';
import 'package:domotica_mimmo/customClasses/Stanza.dart';
import 'package:domotica_mimmo/models/OggettiData.dart';
import 'package:domotica_mimmo/models/SpaziData.dart';
import 'package:domotica_mimmo/models/StanzeData.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:domotica_mimmo/customClasses/Spazio.dart';
import 'package:provider/provider.dart';

class DBHelper {
  static const String DB_NAME = 'Domo99.db';
  static const String TABLESPAZI = 'SpaziUtenti';
  static const String TABLESTANZE = 'StanzeUtenti';
  static const String TABLEOGGETTI = 'OggettiUtenti';

  static Database? _db;
  //tabella spazi
  static const String IDSPAZIO = 'id';
  static const String SPACENAME = 'nomeSpazio';
  static const String INTIP = 'ipInternoSpazio';
  static const String EXTIP = 'ipEsternoSpazio';
  static const String ISINT = 'isIpInterno';

  //tabella stanze
  static const String PARENTSPACENAME = 'nomeSpazioParente';
  static const String IDSTANZA = 'id';
  static const String ROOMNAME = 'nomeStanza';
  static const String ROOMTYPE = 'tipoStanza';

  //tabella oggetti
  //PARENTSPACENAME
  static const String IDOGGETTO = 'id';
  static const String PARENTROOMNAME = 'nomeStanzaParente';
  static const String OBJECTNAME = 'nomeOggetto';
  static const String OBJECTTYPE = 'tipoOggetto';
  static const String INTIPOBJ = 'ipInternoOggetto';
  static const String EXTIPOBJ = 'ipEsternoOggetto';
  static const String ESTOBJ = 'estensioneOggetto';
  static const String RISOBJ = 'rispostaOggetto';

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $TABLESPAZI (
    $IDSPAZIO INTEGER PRIMARY KEY,
    $SPACENAME text,
    $INTIP text,
    $EXTIP text,
    $ISINT tinyint(1) DEFAULT '1'
    )''');

    await db.execute('''CREATE TABLE $TABLESTANZE (
    $IDSTANZA INTEGER PRIMARY KEY,
    $PARENTSPACENAME text,
    $ROOMNAME text,
    $ROOMTYPE text
    )''');

    await db.execute('''CREATE TABLE $TABLEOGGETTI (
    $IDOGGETTO INTEGER PRIMARY KEY,
    $PARENTSPACENAME text,
    $PARENTROOMNAME text,
    $OBJECTNAME text,
    $OBJECTTYPE text,
    $INTIPOBJ text,
    $EXTIPOBJ text,
    $ESTOBJ text,
    $RISOBJ text
    )''');
  }

  //SPAZI
  Future<Spazio> saveSpazio(Spazio spazio) async {
    var dbClient = await db;
    spazio.id = await dbClient.insert(TABLESPAZI, spazio.toMap());

    /*await dbClient.transaction((txn) async {
      var query =
          '''INSERT INTO $TABLESPAZI ($SPACENAME, $INTIP, $EXTIP, $ISINT) VALUES ('" +
              spazio.nomeSpazio +
              "','" +
              spazio.ipInterno +
              "','" +
              spazio.ipEsterno +
              "'," +
              spazio.ipUtilizzato.toString() +
              ")''';
      return await txn.rawInsert(query);
    });*/
    return spazio;
  }

  Future<List<Spazio>> getSpazi(BuildContext context) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient
        .query(TABLESPAZI, columns: [IDSPAZIO, SPACENAME, INTIP, EXTIP, ISINT]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLESPAZI");
    List<Spazio> spazi = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        spazi.add(Spazio.fromMap(maps[i]));
      }
    }
    context.read<SpaziData>().updateListSpazi(spazi);
    return spazi;
  }

  Future<int> deleteSpazio(int id, String spaceName) async {
    var dbClient = await db;
    //elimino oggetti e stanze legate allo spazio
    await dbClient.delete(TABLESPAZI, where: '$IDSPAZIO = ?', whereArgs: [id]);
    await dbClient.delete(TABLESTANZE,
        where: '$PARENTSPACENAME = ?', whereArgs: [spaceName]);
    await dbClient.delete(TABLEOGGETTI,
        where: '$PARENTSPACENAME = ?', whereArgs: [spaceName]);
    return 1;
  }

  Future<int> updateSpazio(Spazio spazio) async {
    var dbClient = await db;
    return await dbClient.update(TABLESPAZI, spazio.toMap(),
        where: '$IDSPAZIO = ?', whereArgs: [spazio.id]);
  }

  Future<int> updateRoomsObjectsNames(Spazio spazio) async {
    var dbClient = await db;
    await dbClient.rawUpdate(
        "UPDATE $TABLESTANZE SET $PARENTSPACENAME = ? WHERE $PARENTSPACENAME=(SELECT $SPACENAME FROM $TABLESPAZI WHERE $IDSPAZIO= ?)",
        [spazio.nomeSpazio, spazio.id]);
    await dbClient.rawUpdate(
        "UPDATE $TABLEOGGETTI SET $PARENTSPACENAME = ? WHERE $PARENTSPACENAME=(SELECT $SPACENAME FROM $TABLESPAZI WHERE $IDSPAZIO= ?)",
        [spazio.nomeSpazio, spazio.id]);
    return 1;
  }

  Future<int> updateObjectsIp(Spazio spazio) async {
    var dbClient = await db;

    await dbClient.rawUpdate(
        "UPDATE $TABLEOGGETTI SET $INTIPOBJ = ?, $EXTIPOBJ = ? WHERE $INTIPOBJ=(SELECT $INTIP FROM $TABLESPAZI WHERE $IDSPAZIO= ?) AND $EXTIPOBJ=(SELECT $EXTIP FROM $TABLESPAZI WHERE $IDSPAZIO= ?)",
        [spazio.ipInterno, spazio.ipEsterno, spazio.id, spazio.id]);
    return 1;
  }

  //STANZE

  Future<Stanza> saveStanza(Stanza stanza) async {
    var dbClient = await db;
    stanza.id = await dbClient.insert(TABLESTANZE, stanza.toMap());
    if (stanza.tipoStanza == 'Allarme' ||
        stanza.tipoStanza == 'Cancello' ||
        stanza.tipoStanza == 'Irrigazione') {
      List<Map> maps = await dbClient.query(TABLESPAZI,
          columns: [
            INTIP,
            EXTIP,
          ],
          where: '$SPACENAME= ?',
          whereArgs: [stanza.spazioParente]);

      Oggetto oggettoAutomatico = Oggetto(
        spazioParente: stanza.spazioParente,
        stanzaParente: stanza.nomeStanza,
        nomeOggetto:
            stanza.tipoStanza == 'Cancello' ? 'Apri/Chiudi' : 'Acceso/Spento',
        tipoOggetto: stanza.tipoStanza == 'Cancello'
            ? 'Cancello'
            : (stanza.tipoStanza == 'Allarme' ? 'Sirena' : 'Irrigatore'),
        ipInterno: maps[0]['ipInternoSpazio'],
        ipEsterno: maps[0]['ipEsternoSpazio'],
        estensione: '',
        risposta: '',
      );
      await dbClient.insert(TABLEOGGETTI, oggettoAutomatico.toMap());
    }
    /*await dbClient.transaction((txn) async {
      var query =
          '''INSERT INTO $TABLESPAZI ($SPACENAME, $INTIP, $EXTIP, $ISINT) VALUES ('" +
              spazio.nomeSpazio +
              "','" +
              spazio.ipInterno +
              "','" +
              spazio.ipEsterno +
              "'," +
              spazio.ipUtilizzato.toString() +
              ")''';
      return await txn.rawInsert(query);
    });*/
    return stanza;
  }

  Future<List<Stanza>> getStanze(
      BuildContext context, String parentName) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(TABLESTANZE,
        columns: [IDSTANZA, PARENTSPACENAME, ROOMNAME, ROOMTYPE],
        where: '$PARENTSPACENAME = ?',
        whereArgs: [parentName]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLESTANZE");
    List<Stanza> stanze = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        stanze.add(Stanza.fromMap(maps[i]));
      }
    }
    context.read<StanzeData>().updateListStanze(stanze);
    return stanze;
  }

  Future<int> deleteStanza(int id, String parentName, String roomName) async {
    var dbClient = await db;
    await dbClient.delete(TABLESTANZE,
        where: '$IDSTANZA = ? AND $PARENTSPACENAME = ?',
        whereArgs: [id, parentName]);
    await dbClient.delete(TABLEOGGETTI,
        where: '$PARENTSPACENAME = ? AND $PARENTROOMNAME = ?',
        whereArgs: [parentName, roomName]);
    return 1;
  }

  Future<int> updateStanza(Stanza stanza) async {
    var dbClient = await db;
    return await dbClient.update(TABLESTANZE, stanza.toMap(),
        where: '$IDSTANZA = ?', whereArgs: [stanza.id]);
  }

  Future<int> updateObjectsNames(Stanza stanza) async {
    var dbClient = await db;

    await dbClient.rawUpdate(
        "UPDATE $TABLEOGGETTI SET $PARENTROOMNAME = ? WHERE $PARENTROOMNAME=(SELECT $ROOMNAME FROM $TABLESTANZE WHERE $IDSTANZA= ?)",
        [stanza.nomeStanza, stanza.id]);
    return 1;
  }

  //OGGETTI

  Future<Oggetto> saveOggetto(Oggetto oggetto) async {
    var dbClient = await db;
    oggetto.id = await dbClient.insert(TABLEOGGETTI, oggetto.toMap());
    /*await dbClient.transaction((txn) async {
      var query =
          '''INSERT INTO $TABLESPAZI ($SPACENAME, $INTIP, $EXTIP, $ISINT) VALUES ('" +
              spazio.nomeSpazio +
              "','" +
              spazio.ipInterno +
              "','" +
              spazio.ipEsterno +
              "'," +
              spazio.ipUtilizzato.toString() +
              ")''';
      return await txn.rawInsert(query);
    });*/
    return oggetto;
  }

  Future<List<Oggetto>> getOggetti(
      BuildContext context, String parentSpace, String parentRoom) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(TABLEOGGETTI,
        columns: [
          IDOGGETTO,
          PARENTSPACENAME,
          PARENTROOMNAME,
          OBJECTNAME,
          OBJECTTYPE,
          INTIPOBJ,
          EXTIPOBJ,
          ESTOBJ,
          RISOBJ
        ],
        where: '$PARENTSPACENAME = ? AND $PARENTROOMNAME = ?',
        whereArgs: [parentSpace, parentRoom]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLESTANZE");
    List<Oggetto> oggetti = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        oggetti.add(Oggetto.fromMap(maps[i]));
      }
    }
    context.read<OggettiData>().updateListOggetti(oggetti);
    return oggetti;
  }

  Future<int> deleteOggetto(
      int id, String parentSpace, String parentRoom) async {
    var dbClient = await db;
    return await dbClient.delete(TABLEOGGETTI,
        where: '$IDSTANZA = ? AND $PARENTSPACENAME = ? AND $PARENTROOMNAME = ?',
        whereArgs: [id, parentSpace, parentRoom]);
  }

  Future<int> updateOggetto(Oggetto oggetto) async {
    var dbClient = await db;
    return await dbClient.update(TABLEOGGETTI, oggetto.toMap(),
        where: '$IDSTANZA = ?', whereArgs: [oggetto.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
