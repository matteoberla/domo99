import 'package:flutter/cupertino.dart';

enum Modalita { accesso, insertOldPin, insertNewPin }

class LoginProvider extends ChangeNotifier {
  String avvisoAccesso = 'Pin di accesso';

  updateAvvisoAccesso(String newAvviso) {
    avvisoAccesso = newAvviso;
    notifyListeners();
  }

  ///pin
  List<String> currentPin = ["", "", "", ""];

  updateCurrentPinAtIndex(int index, String val) {
    currentPin[index] = val;
    notifyListeners();
  }

  TextEditingController pinOneController = TextEditingController();
  TextEditingController pinTwoController = TextEditingController();
  TextEditingController pinThreeController = TextEditingController();
  TextEditingController pinFourController = TextEditingController();

  ///
  Modalita modalitaCorrente = Modalita.accesso;

  updateModalitaPin(Modalita newMod) {
    modalitaCorrente = newMod;
    notifyListeners();
  }

  ///
  final String defaultPin = "0000";

  ///
  int pinIndex = 0;

  updatePinIndex(int newPinIndex) {
    pinIndex = newPinIndex;
    notifyListeners();
  }

  ///
  String pinSalvato = '';

  updatePinSalvato(String newPin) {
    pinSalvato = newPin;
    notifyListeners();
  }
}
