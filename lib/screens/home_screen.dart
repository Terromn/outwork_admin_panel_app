import 'package:flutter/material.dart';
import 'package:outwork_final_admin_panel_app/screens/scan_screen.dart';

import '../assets/app_color_palette.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Widget teOutlinedButton(
    String text, IconData icon, dynamic context, dynamic screen) {
  return Padding(
    padding: const EdgeInsets.all(32.0),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
          height: double.infinity,
          width: 500,
          decoration: BoxDecoration(
            color: TeAppColorPalette.blackLight,
            border: Border.all(
                color: TeAppColorPalette.green, width: 8), // Add border
            borderRadius: BorderRadius.circular(40),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: TeAppColorPalette.green),
                textAlign: TextAlign.center,
              ),
              Icon(
                icon,
                size: 264,
                color: TeAppColorPalette.green,
              )
            ],
          )),
    ),
  );
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BIENVENIDO ADMIN'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            teOutlinedButton(
                "NUEVA VENTA",
                Icons.monetization_on,
                context,
                const ScanScreen(
                  nextScreenName: "sale",
                )),
            teOutlinedButton(
                "REGISTRAR ASISTENCIA",
                Icons.search,
                context,
                const ScanScreen(
                  nextScreenName: 'asistance',
                ))
          ],
        ),
      ),
    );
  }
}
