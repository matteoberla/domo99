import 'package:domotica_mimmo/customClasses/KeyboardNumber.dart';
import 'package:domotica_mimmo/customClasses/PinNumber.dart';
import 'package:domotica_mimmo/screens/HelpScreen.dart';
import 'package:domotica_mimmo/screens/SpaziScreen.dart';
import 'package:domotica_mimmo/sqLite/dbHelper.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

String avvisoAccesso = 'Pin di accesso';

enum Modalita { accesso, InserimentoVecchioPin, InserimentoNuovoPin }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
          begin: Alignment.topRight,
        )),
        child: OtpScreen(
          isDark: isDark,
        ),
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  OtpScreen({required this.isDark});
  final bool isDark;
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> currentPin = ["", "", "", ""];
  TextEditingController pinOneController = TextEditingController();
  TextEditingController pinTwoController = TextEditingController();
  TextEditingController pinThreeController = TextEditingController();
  TextEditingController pinFourController = TextEditingController();

  Modalita modalitaCorrente = Modalita.accesso;

  var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.transparent),
  );

  int pinIndex = 0;
  String pinSalvato = '';

  @override
  void initState() {
    super.initState();
    initPin();
  }

  void initPin() async {
    pinSalvato = await getCredentials('pin');
    if (pinSalvato == '') {
      pinSalvato = '0000';
    }
  }

  void setCredentials(String pin) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('pin', pin);
  }

  Future<String> getCredentials(String tag) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(tag) ?? '0000';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          buildExtraButton(),
          Expanded(
            child: Container(
              alignment: Alignment(0, 0.5),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildSecurityText(),
                  SizedBox(
                    height: 40.0,
                  ),
                  buildPinRow(),
                ],
              ),
            ),
          ),
          buildNumberPad(),
        ],
      ),
    );
  }

  buildNumberPad() {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                      n: 1,
                      onPressed: () {
                        pinIndexSetup('1');
                      }),
                  KeyboardNumber(
                      n: 2,
                      onPressed: () {
                        pinIndexSetup('2');
                      }),
                  KeyboardNumber(
                      n: 3,
                      onPressed: () {
                        pinIndexSetup('3');
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                      n: 4,
                      onPressed: () {
                        pinIndexSetup('4');
                      }),
                  KeyboardNumber(
                      n: 5,
                      onPressed: () {
                        pinIndexSetup('5');
                      }),
                  KeyboardNumber(
                      n: 6,
                      onPressed: () {
                        pinIndexSetup('6');
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                      n: 7,
                      onPressed: () {
                        pinIndexSetup('7');
                      }),
                  KeyboardNumber(
                      n: 8,
                      onPressed: () {
                        pinIndexSetup('8');
                      }),
                  KeyboardNumber(
                      n: 9,
                      onPressed: () {
                        pinIndexSetup('9');
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 60.0,
                    child: MaterialButton(
                      onPressed: null,
                      child: SizedBox(),
                    ),
                  ),
                  KeyboardNumber(
                      n: 0,
                      onPressed: () {
                        pinIndexSetup('0');
                      }),
                  Container(
                    width: 60.0,
                    child: MaterialButton(
                      height: 60.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      onPressed: () {
                        clearPin();
                      },
                      child: Icon(
                        Icons.cancel,
                        color: widget.isDark ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  clearPin() {
    if (pinIndex == 0) {
      pinIndex = 0;
    } else if (pinIndex == 4) {
      setPin(pinIndex, "");
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    } else {
      setPin(pinIndex, "");
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    }
  }

  clearPad() {
    for (int num = 1; num <= 4; num++) {
      setPin(pinIndex, "");
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    }
  }

  pinIndexSetup(String text) async {
    if (pinIndex == 0) {
      pinIndex = 1;
    } else if (pinIndex < 4) {
      pinIndex++;
    }
    setPin(pinIndex, text);
    currentPin[pinIndex - 1] = text;
    String strPin = "";
    currentPin.forEach((e) {
      strPin += e;
    });
    if (pinIndex == 4) {
      //verificare pin
      if (modalitaCorrente == Modalita.accesso) {
        if (strPin == pinSalvato) {
          setState(() {
            avvisoAccesso = 'Benvenuto';
            clearPad();
          });
          final DBHelper dbHelper = DBHelper();
          await dbHelper.getSpazi(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SpaziScreen();
          }));
        } else {
          setState(() {
            avvisoAccesso = 'Il pin inserito non è corretto';
            clearPad();
          });
        }
        print('pin salvato' + pinSalvato);
        print('il pin è:' + strPin);
      } else if (modalitaCorrente == Modalita.InserimentoVecchioPin) {
        if (strPin == pinSalvato) {
          setState(() {
            avvisoAccesso = 'Inserisci il nuovo pin';
            clearPad();
            modalitaCorrente = Modalita.InserimentoNuovoPin;
          });
        } else {
          setState(() {
            avvisoAccesso = 'Il pin inserito non è corretto';
            clearPad();
          });
        }
      } else if (modalitaCorrente == Modalita.InserimentoNuovoPin) {
        setCredentials(strPin);
        initPin();
        setState(() {
          clearPad();
          modalitaCorrente = Modalita.accesso;
          avvisoAccesso = 'Pin di accesso';
        });
      }
    }
  }

  setPin(int n, String text) {
    switch (n) {
      case 1:
        pinOneController.text = text;
        break;
      case 2:
        pinTwoController.text = text;
        break;
      case 3:
        pinThreeController.text = text;
        break;
      case 4:
        pinFourController.text = text;
        break;
    }
  }

  buildPinRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PinNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: pinOneController,
        ),
        PinNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: pinTwoController,
        ),
        PinNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: pinThreeController,
        ),
        PinNumber(
          outlineInputBorder: outlineInputBorder,
          textEditingController: pinFourController,
        ),
      ],
    );
  }

  buildSecurityText() {
    return Text(
      avvisoAccesso,
      style: TextStyle(
        color: widget.isDark ? Colors.black : Colors.white,
        fontSize: 21.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  buildExtraButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              MaterialButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HelpScreen();
                  }));
                },
                height: 50.0,
                minWidth: 50.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Icon(
                  Icons.help,
                  color: widget.isDark ? Colors.black : Colors.white,
                ),
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    if (modalitaCorrente == Modalita.accesso) {
                      avvisoAccesso =
                          'Inserisci il vecchio codice per sostituirlo (default: 0000)';
                      modalitaCorrente = Modalita.InserimentoVecchioPin;
                    } else {
                      avvisoAccesso = 'Pin di accesso';
                      modalitaCorrente = Modalita.accesso;
                    }
                  });
                },
                height: 50.0,
                minWidth: 50.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Icon(
                  Icons.lock_open,
                  color: widget.isDark ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
