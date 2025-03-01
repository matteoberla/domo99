import 'package:domotica_mimmo/customClasses/Oggetto.dart';
import 'package:flutter/cupertino.dart';

class OggettiData extends ChangeNotifier {
  List<Oggetto> listOggetti = [];

  bool isLoading = false;

  Oggetto oggettoToModify = Oggetto();
  Oggetto oggettoSelected = Oggetto();

  int get oggettiCount {
    return listOggetti.length;
  }

  void updateListOggetti(List<Oggetto> updatedListOggetti) {
    listOggetti = updatedListOggetti;
    notifyListeners();
  }

  void updateIsLoading(bool newState) {
    print(newState);
    isLoading = newState;
    notifyListeners();
  }

  void updateOggettoToModify(Oggetto newObjectToModify) {
    oggettoToModify = newObjectToModify;
    notifyListeners();
  }

  void updateOggettoSelected(Oggetto newObjectSelected) {
    oggettoSelected = newObjectSelected;
    notifyListeners();
  }

  void updateOggettoColor(Oggetto oggetto, Color newColor) {
    if (listOggetti.indexOf(oggetto) != -1) {
      listOggetti[listOggetti.indexOf(oggetto)].colore = newColor;
      notifyListeners();
    }
  }
}
