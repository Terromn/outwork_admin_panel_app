import 'package:flutter/material.dart';
import 'package:outwork_final_admin_panel_app/firebase_options.dart';
import 'package:outwork_final_admin_panel_app/utils/google_sheets_api.dart';
import 'package:outwork_final_admin_panel_app/utils/google_sheets_sales_api.dart';

import 'assets/app_theme.dart';
import 'screens/home_screen.dart';


import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleSheetsApi.init();
  await GoogleSheetsSalesApi.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Use this if you have generated options using FlutterFire CLI
  );
  runApp(const TeApp());
}



class TeApp extends StatelessWidget {
  
  const TeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      theme: TeAppThemeData.darkTheme,
    );
  }
}



