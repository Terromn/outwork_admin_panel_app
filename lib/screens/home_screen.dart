import 'package:flutter/material.dart';
import 'package:outwork_final_admin_panel_app/screens/merch_screen.dart';
import 'package:outwork_final_admin_panel_app/screens/scan_screen.dart';
import 'package:outwork_final_admin_panel_app/utils/te_media_query.dart';

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
          height: TeMediaQuery.getPercentageHeight(context, 35),
          width: 500,
          decoration: BoxDecoration(
            color: TeAppColorPalette.blackLight,
            border: Border.all(
                color: TeAppColorPalette.green, width: 8), // Add border
            borderRadius: BorderRadius.circular(40),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: TeAppColorPalette.green),
                textAlign: TextAlign.center,
              ),
              Icon(
                icon,
                size: 200,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                teOutlinedButton(
                    "VENTA CREDITOS",
                    Icons.monetization_on,
                    context,
                    const ScanScreen(
                      nextScreenName: "sale",
                    )),
                teOutlinedButton(
                    "CREAR USUARIO",
                    Icons.add_box_rounded,
                    context,
                    const ScanScreen(
                      nextScreenName: 'asistance',
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                teOutlinedButton(
                    "REGISTRAR USUARIO",
                    Icons.search,
                    context,
                    const ScanScreen(
                      nextScreenName: "asistance",
                    )),
                teOutlinedButton("VENTA MERCH", Icons.shopping_bag_rounded,
                    context, const MerchScreen())
              ],
            )
          ],
        ),
      ),
    );
  }
}
