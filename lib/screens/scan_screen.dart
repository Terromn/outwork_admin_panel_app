import 'dart:io';

import 'package:flutter/material.dart';
import 'package:outwork_final_admin_panel_app/assets/app_theme.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../assets/app_color_palette.dart';
import 'asistance_screen.dart';
import 'sale_screen.dart';

class ScanScreen extends StatefulWidget {
  final String nextScreenName;
  const ScanScreen({super.key, required this.nextScreenName});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  late String nextScreenName;
  Barcode? barcode;
  String qrText = '';

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
    nextScreenName = widget.nextScreenName;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await controller.pauseCamera();
    }

    if (Platform.isIOS) {
      await controller.pauseCamera();
    }

    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF0A0813),
          appBar: AppBar(
            title: Text(
              barcode != null
                  ? '${barcode!.code}'
                  : 'Scanee un codigo para mostrar el ID',
            ),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              buildQrView(context),
              Positioned(
                bottom: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (barcode != null) {
                      if (nextScreenName == 'asistance') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AsistanceScreen(
                                    athleteId: barcode!.code as String,
                                  )),
                        );
                      } else if (nextScreenName == 'sale') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  SaleScreen(uid: barcode!.code as String,)),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No se ha detectado ningun codigo...'),
                          backgroundColor: TeAppColorPalette.green,
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        WidgetStateProperty.all<Color>(TeAppColorPalette.black),
                    backgroundColor:
                        WidgetStateProperty.all<Color>(TeAppColorPalette.green),
                    textStyle: WidgetStateProperty.all<TextStyle>(
                        const TextStyle(fontSize: 16)),
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(12)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                    child: Text(
                      'Scanear',
                      style: TextStyle(
                          fontFamily: TeAppThemeData.teFont,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          borderColor: TeAppColorPalette.green,
          cutOutSize: 300,
        ),
      );

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((barcode) {
      setState(() {
        this.barcode = barcode;
      });
    });
  }

  Future<void> _requestCameraPermission() async {
    if (await Permission.camera.request().isGranted) {
    } else {
      return;
    }
  }
}
