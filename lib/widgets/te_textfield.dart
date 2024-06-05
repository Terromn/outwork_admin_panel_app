import 'package:flutter/material.dart';
import '../assets/app_color_palette.dart';
import '../assets/app_theme.dart';

class TeTextField extends StatelessWidget {
  final String labelText;
  final bool isPercentage;
  final TextEditingController controller; // Accepting controller

  const TeTextField({
    super.key,
    required this.labelText,
    required this.isPercentage,
    required this.controller, // Adding this line to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: TeAppColorPalette.green,
          width: 4,
        ),
        borderRadius: BorderRadius.circular(300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller, // Assigning controller here
                style: TextStyle(
                    fontFamily: TeAppThemeData.teFont, fontSize: 28),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  labelText: labelText,
                  isCollapsed: true,
                  labelStyle: TextStyle(
                      fontFamily: TeAppThemeData.teFont,
                      fontSize: 28,
                      fontWeight: FontWeight.normal),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 24.0), // Add padding here
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  alignLabelWithHint: false,
                ),
              ),
            ),
            if (isPercentage)
              Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: Center(
                    child: Text(
                  "%",
                  style: TextStyle(
                      fontFamily: TeAppThemeData.teFont, fontSize: 28),
                )),
              )
          ],
        ),
      ),
    );
  }
}
