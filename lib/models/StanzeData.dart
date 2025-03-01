import 'package:flutter/foundation.dart';
import 'package:domotica_mimmo/customClasses/Stanza.dart';

class StanzeData extends ChangeNotifier {
  List<Stanza> listStanze = [];

  bool isLoading = false;

  Stanza stanzaToModify = Stanza();
  Stanza stanzaSelected = Stanza();

  int get stanzeCount {
    return listStanze.length;
  }

  void updateListStanze(List<Stanza> updatedListStanze) {
    listStanze = updatedListStanze;
    notifyListeners();
  }

  void updateIsLoading(bool newState) {
    isLoading = newState;
    notifyListeners();
  }

  void updateStanzaToModify(Stanza newRoomToModify) {
    stanzaToModify = newRoomToModify;
    notifyListeners();
  }

  void updateStanzaSelected(Stanza newRoomSelected) {
    stanzaSelected = newRoomSelected;
    notifyListeners();
  }
}
