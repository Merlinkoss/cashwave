import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Inputs {
  static Widget defaultInput(String name, TextInputType type,
      TextEditingController controller, Widget suffixButton, bool isEnabled) {
    return Container(
        margin: EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          keyboardType: type,
          decoration: InputDecoration(
              enabled: isEnabled,
              suffixIcon: suffixButton,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 0.0)),
              border: OutlineInputBorder(),
              labelText: name,
              labelStyle: TextStyle(color: Colors.black)),
        ));
  }
}
