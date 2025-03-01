import 'package:flutter/foundation.dart';
import 'package:domotica_mimmo/customClasses/Spazio.dart';

class SpaziData extends ChangeNotifier {
  List<Spazio> listSpazi = [];

  String nomeUtente = 'Domo99';

  bool isLoading = false;

  Spazio spazioToModify = Spazio();
  Spazio spazioSelected = Spazio();

  int get spaziCount {
    return listSpazi.length;
  }

  void updateListSpazi(List<Spazio> updatedListSpazi) {
    listSpazi = updatedListSpazi;
    notifyListeners();
  }

  void updateIsLoading(bool newState) {
    isLoading = newState;
    notifyListeners();
  }

  void updateSpazioToModify(Spazio newSpaceToModify) {
    spazioToModify = newSpaceToModify;
    notifyListeners();
  }

  void updateSpazioSelected(Spazio newSpaceSelected) {
    spazioSelected = newSpaceSelected;
    notifyListeners();
  }
}
