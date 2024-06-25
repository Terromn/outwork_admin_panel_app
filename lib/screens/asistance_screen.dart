// ignore_for_file: use_build_context_synchronously, equal_keys_in_map

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outwork_final_admin_panel_app/models/asistance_sheets_model.dart';
import 'package:outwork_final_admin_panel_app/models/athlete_model.dart';
import 'package:outwork_final_admin_panel_app/utils/google_sheets_api.dart';

import '../assets/app_color_palette.dart';
import '../assets/app_theme.dart';

class AsistanceScreen extends StatefulWidget {
  final String athleteId;
  const AsistanceScreen({super.key, required this.athleteId});

  @override
  State<AsistanceScreen> createState() => _AsistanceScreenState();
}

class _AsistanceScreenState extends State<AsistanceScreen> {
  bool _isSwitched = true;
  late int _athleteLeftOverCredits = 0;
  late String athleteID = '';
  String? _profilePictureUrl;

  late AthleteModel currentAthlete = AthleteModel(0, '', '', '', '', '');

  @override
  void initState() {
    super.initState();
    athleteID = widget.athleteId;
    getAthleteModelData();
    _athleteLeftOverCredits = currentAthlete.creditsAvailable;
  }

  Future<void> _fetchProfilePictureUrl() async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('defaultProfilePictures/${currentAthlete.profilePicture}');
      final url = await ref.getDownloadURL();
      setState(() {
        _profilePictureUrl = url;
      });
    } catch (e) {
      print('Error fetching profile picture: $e');
    }
  }

  void getAthleteModelData() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('users').doc(athleteID).get();

      if (snapshot.exists) {
        setState(() {
          currentAthlete = AthleteModel(
            snapshot['creditsAvailable'],
            snapshot['gender'],
            snapshot['membership'],
            snapshot['name'],
            snapshot['userName'],
            snapshot['profilePicture'],
          );
          _athleteLeftOverCredits = currentAthlete.creditsAvailable;
        });
        _fetchProfilePictureUrl();
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching athlete data: $e');
    }
  }

  Future<String> _getProfilePictureUrl() async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('defaultProfilePictures/${currentAthlete.profilePicture}');

      return await ref.getDownloadURL();
    } catch (e) {
      print('Error fetching profile picture: $e');
      return '';
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("REGISTRE ASISTENCIA")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 80),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                    color: TeAppColorPalette.green,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 24.0, right: 24, left: 24),
                    child: Column(
                      children: [
                        Text(
                          currentAthlete.membership == 'sessions'
                              ? 'Sesiones\nDisponibles'
                              : currentAthlete.membership == 'membership'
                                  ? 'Full\nAccess'
                                  : 'Error',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: TeAppThemeData.teFont,
                            color: TeAppColorPalette.black,
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _athleteLeftOverCredits.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: TeAppThemeData.teFont,
                            color: TeAppColorPalette.black,
                            fontSize: 46,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                _profilePictureUrl == null
                    ? const CircularProgressIndicator()
                    : CircleAvatar(
                        backgroundColor: TeAppColorPalette.black,
                        backgroundImage: NetworkImage(_profilePictureUrl!),
                        radius: 100,
                      ),
                const SizedBox(width: 32),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentAthlete.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: TeAppThemeData.teFont,
                        color: TeAppColorPalette.white,
                        fontSize: 46,
                      ),
                    ),
                    Text(
                      '@${currentAthlete.userName}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: TeAppThemeData.teFont,
                        color: TeAppColorPalette.white,
                        fontSize: 32,
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 30),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: TeAppColorPalette.black,
                borderRadius: BorderRadius.circular(200),
                border: Border.all(color: TeAppColorPalette.green, width: 6),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('El Dia De Hoy Asistio?',
                          style: TextStyle(
                              fontFamily: TeAppThemeData.teFont, fontSize: 28)),
                      CupertinoSwitch(
                        activeColor: TeAppColorPalette.green,
                        value: _isSwitched,
                        onChanged: (value) {
                          setState(() {
                            _isSwitched = value;
                          });
                        },
                      )
                    ]),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: TeAppColorPalette.black,
                borderRadius: BorderRadius.circular(200),
                border: Border.all(color: TeAppColorPalette.green, width: 6),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Creditos: $_athleteLeftOverCredits',
                          style: TextStyle(
                              fontFamily: TeAppThemeData.teFont, fontSize: 28)),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (_athleteLeftOverCredits > 0) {
                                  _athleteLeftOverCredits--;
                                }
                              });
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _athleteLeftOverCredits++;
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            SizedBox(
              height: 100,
              child: TextButton(
                onPressed: () {
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirmar Asistencia"),
                        content: const Text(
                            "¿Está seguro de que registrar la asistencia?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Close the dialog
                              Navigator.of(context).pop();
                              // Perform action upon confirmation
                              _completePurchase();
                            },
                            child: const Text("Confirmar", style: TextStyle(color: TeAppColorPalette.white)),
                          ),
                          TextButton(
                            onPressed: () {
                              // Close the dialog
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancelar", style: TextStyle(color: TeAppColorPalette.white)),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(TeAppColorPalette.green),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 64),
                  child: Text(
                    'Confirmar',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: TeAppThemeData.teFont,
                      color: TeAppColorPalette.black,
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  void _completePurchase() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(athleteID).update({
        'creditsAvailable': _athleteLeftOverCredits,
      });

      final athlete = {
        AsistanceSheetsModel.id: athleteID,
        AsistanceSheetsModel.name: currentAthlete.name,
        AsistanceSheetsModel.gender: currentAthlete.gender,
        AsistanceSheetsModel.date: DateTime.now().toString(),
      };
      if (_isSwitched) {
        await GoogleSheetsApi.insert([athlete]);
      }

      // Show success message or navigate back to the previous screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Creditos & Asistencia Guardados Correctamente')),
      );

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating credits: $e')),
      );
    }
  }
}
