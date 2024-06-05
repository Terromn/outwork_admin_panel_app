import 'package:flutter/material.dart';

import '../assets/app_color_palette.dart';

class TeButtonOutline extends StatelessWidget {
   const TeButtonOutline({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: double.infinity,
        width: 500,
        decoration: BoxDecoration(
          color: TeAppColorPalette.blackLight,
          border: Border.all(
              color: TeAppColorPalette.green, width: 8), // Add border
          borderRadius: BorderRadius.circular(40),
        ),
        child: const Center(),
      ),
    );
  }
}
