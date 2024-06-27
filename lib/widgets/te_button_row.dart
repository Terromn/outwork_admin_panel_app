// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../assets/app_color_palette.dart';
import '../assets/app_theme.dart';

class TeButtonRow extends StatefulWidget {
  final List<String> buttonLabels;

  dynamic onPressed;

  TeButtonRow({
    super.key,
    required this.buttonLabels,
    required this.onPressed,
  });

  @override
  _TeButtonRowState createState() => _TeButtonRowState();
}

class _TeButtonRowState extends State<TeButtonRow> {
  int _selectedIndex = -1; // Initially no button is selected

  Widget buildButton(int index, String text) {
    return Expanded(
      child: Padding(
       
        padding:  EdgeInsets.only(right:  index <  widget.buttonLabels.length -1 ? 32.0 : 0),
        child: SizedBox(
          height: 100,
          child: TextButton(
            onPressed: () {
              setState(() {
                _selectedIndex = index; // Update selected index
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TeAppColorPalette.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(300.0),
                side: BorderSide(
                  width: 4,
                  color: _selectedIndex == index
                      ? TeAppColorPalette.green
                      : TeAppColorPalette.black,
                ),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: TeAppThemeData.teFont,
                color: TeAppColorPalette.white,
                fontSize: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }

  getSelectedValue() {
    return _selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        widget.buttonLabels.length,
        (index) {
          Widget button = buildButton(index, widget.buttonLabels[index]);         
          return 
          button;
        },
      ),
    );
  }
}
