import 'package:flutter/material.dart';

import '../assets/app_color_palette.dart';
import '../assets/app_theme.dart';

class TeDropDownMenu extends StatelessWidget {
  final BuildContext context;
  final dynamic value;
  final List items;
  final Function onChanged;

  const TeDropDownMenu(
      {super.key,
      required this.context,
      required this.value,
      required this.items,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: TeAppColorPalette.green,
          width: 4,
        ),
        borderRadius: BorderRadius.circular(300),
      ),
      height: 100,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            focusColor: TeAppColorPalette.blackLight,
            iconSize: 64,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: TeAppColorPalette.white,
            ),
            value: value,
            onChanged: (newValue) {
              onChanged(newValue);
            },
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 0.0),
                  child: Text(
                    item,
                    style: TextStyle(
                        fontFamily: TeAppThemeData.teFont, fontSize: 28),
                    textAlign: TextAlign.left,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
