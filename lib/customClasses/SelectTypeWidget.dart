import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:domotica_mimmo/components/tipologieStanzeOggetti.dart';

class SelectTypeWidget {
  //STANZE
  DropdownButton<String> androidDropdownRoom(
      String tipoStanza, Function onChangeCallback) {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (var tipo in tipiStanze) {
      var newItem = DropdownMenuItem(
        child: Text(
          tipo,
          style: TextStyle(color: Colors.white),
        ),
        value: tipo,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      dropdownColor: Colors.black,
      value: tipoStanza,
      items: dropdownItems,
      onChanged: (newValue) {
        tipoStanza = newValue ?? "";
        onChangeCallback(newValue);
      },
    );
  }

  CupertinoPicker iOSPickerRoom(Function onChangedCallback, int initialIndex) {
    List<Text> pickerItems = [];
    String tipoStanza = tipiStanze[initialIndex];
    for (String tipo in tipiStanze) {
      pickerItems.add(Text(tipo));
    }

    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: initialIndex),
      backgroundColor: Colors.lightBlueAccent,
      itemExtent: 30.0,
      onSelectedItemChanged: (selectedItem) {
        tipoStanza = tipiStanze[selectedItem];
        onChangedCallback(tipoStanza);
      },
      children: pickerItems,
    );
  }

  //OGGETTI
  DropdownButton<String> androidDropdownObject(
      String tipoOggetto, Function onChangeCallback) {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (var tipo in tipiOggetti) {
      var newItem = DropdownMenuItem(
        child: Text(
          tipo,
          style: TextStyle(color: Colors.white),
        ),
        value: tipo,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      dropdownColor: Colors.black,
      value: tipoOggetto,
      items: dropdownItems,
      onChanged: (newValue) {
        tipoOggetto = newValue ?? "";
        onChangeCallback(newValue);
      },
    );
  }

  CupertinoPicker iOSPickerObject(Function onChangeCallback, int initialIndex) {
    List<Text> pickerItems = [];
    String tipoOggetto = tipiOggetti[initialIndex];
    for (String tipo in tipiOggetti) {
      pickerItems.add(Text(tipo));
    }

    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: initialIndex),
      backgroundColor: Colors.lightBlueAccent,
      itemExtent: 30.0,
      onSelectedItemChanged: (selectedItem) {
        tipoOggetto = tipiOggetti[selectedItem];
        onChangeCallback(tipoOggetto);
      },
      children: pickerItems,
    );
  }
}
