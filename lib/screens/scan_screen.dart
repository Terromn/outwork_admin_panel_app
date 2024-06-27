// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:outwork_final_admin_panel_app/assets/app_theme.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool usingManualSearch = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    nextScreenName = widget.nextScreenName;
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    _controller.dispose();
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
                  : 'ESCANEE UN CODIGO PARA MOSTRAR EL ID',
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                  size: 32,
                ),
                onPressed: () {
                  _showSearchDialog(context);
                },
              ),
            ],
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
                              builder: (context) => SaleScreen(
                                    uid: barcode!.code as String,
                                  )),
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

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String searchQuery = '';
        return LayoutBuilder(
          builder: (context, constraints) {
            return AlertDialog(
              title: const Text('Buscar Atleta'),
              content: SizedBox(
                width: constraints.maxWidth * 0.8,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    searchQuery = _controller.text;
                    usingManualSearch = true;
                  },
                  decoration:
                      const InputDecoration(hintText: "Ingresar Nombre"),
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      child: const Text(
                        'CANCELAR',
                        style: TextStyle(
                          color: TeAppColorPalette.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          TeAppColorPalette.green,
                        ),
                      ),
                      onPressed: () async {
                        String searchQuery = _controller.text
                            .trim(); // Get trimmed text from controller
                        if (searchQuery.isNotEmpty) {
                          bool exists = await athleteExists(searchQuery);
                          if (exists) {
                            String? athleteId = await getIdByName(searchQuery);
                            if (athleteId != null) {
                              if (nextScreenName == 'asistance') {
                                if (mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AsistanceScreen(
                                        athleteId: athleteId,
                                      ),
                                    ),
                                  );
                                }
                              } else if (nextScreenName == 'sale') {
                                if (mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SaleScreen(uid: athleteId),
                                    ),
                                  );
                                }
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('ID no encontrado'),
                                  backgroundColor: TeAppColorPalette.green,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Nombre inexistente, por favor inténtelo de nuevo...'),
                                backgroundColor: TeAppColorPalette.green,
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ingrese un nombre para buscar'),
                              backgroundColor: TeAppColorPalette.green,
                            ),
                          );
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 18.0),
                        child: Text(
                          'BUSCAR',
                          style: TextStyle(
                            color: TeAppColorPalette.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> athleteExists(String searchQuery) async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    final searchParts = searchQuery.toLowerCase().split(' ');

    for (var doc in querySnapshot.docs) {
      final name = doc['name'] as String;
      final nameParts = name.toLowerCase().split(' ');

      bool match = true;
      for (int i = 0; i < searchParts.length; i++) {
        if (i >= nameParts.length || searchParts[i] != nameParts[i]) {
          match = false;
          break;
        }
      }

      if (match) {
        return true;
      }
    }

    return false;
  }

  Future<String?> getIdByName(String searchQuery) async {
    final searchParts = searchQuery.toLowerCase().split(' ');

    final querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    for (var doc in querySnapshot.docs) {
      final name = doc['name'] as String;
      final nameParts = name.toLowerCase().split(' ');

      bool match = true;
      for (int i = 0; i < searchParts.length; i++) {
        if (i >= nameParts.length || searchParts[i] != nameParts[i]) {
          match = false;
          break;
        }
      }

      if (match) {
        return doc.id;
      }
    }

    return null;
  }
}
