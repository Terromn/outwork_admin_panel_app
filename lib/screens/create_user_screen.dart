// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outwork_final_admin_panel_app/widgets/te_button_row.dart';

import '../assets/app_color_palette.dart';
import '../assets/app_theme.dart';
import '../widgets/te_textfield.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedGender = 'Male';
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  void createUserInFirestore() async {
  try {
    // Create user with email and password
    print('Attempting to create user with email: ${emailController.text.trim()}');
    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // Get the newly created user ID
    String uid = userCredential.user?.uid ?? '';
    print('User created with UID: $uid');

    // Add user data to Firestore
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'creditsAvailable': 0,
      'gender': selectedGender,
      'membership': 'sessions',
      'name': nameController.text.trim(),
      'phoneNumber': phoneNumberController.text.trim(),
      'profilePicture': '5.jpg',
      'userName': userNameController.text.trim(),
    });

    print('User data added to Firestore for UID: $uid');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usuario creado exitosamente'),
        backgroundColor: TeAppColorPalette.green,
      ),
    );

    // Navigate back to the home screen
    Navigator.popUntil(context, ModalRoute.withName('/')); // Replace '/' with your home screen route
  } catch (e) {
    String errorMessage = 'Error al crear usuario';

    if (e is FirebaseAuthException) {
      errorMessage = e.message ?? errorMessage;
    } else {
      errorMessage = e.toString();
    }

    // Log the error to the console
    print('Error: $errorMessage');

    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CREANDO USUARIO'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 64),
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              TeTextField(
                controller: nameController,
                labelText: 'Nombre Completo',
                isPercentage: false,
              ),
              const SizedBox(height: 32),
              TeTextField(
                controller: userNameController,
                labelText: 'Nombre De Usuario',
                isPercentage: false,
              ),
              const SizedBox(height: 32),
              TeTextField(
                controller: phoneNumberController,
                labelText: 'Numero De Celular',
                textInputType: const TextInputType.numberWithOptions(
                    signed: true, decimal: false),
                isPercentage: false,
              ),
              const SizedBox(height: 32),
              TeTextField(
                controller: emailController,
                labelText: 'Correo Electronico',
                isPercentage: false,
              ),
              const SizedBox(height: 32),
              TeTextField(
                controller: passwordController,
                labelText: 'Password',
                isPercentage: false,
              ),
              const SizedBox(height: 32),
              TeButtonRow(
                buttonLabels: const ['Mujer', 'Hombre'],
                onPressed: (index) {
                  setState(() {
                    selectedGender = index == 0 ? 'Female' : 'Male';
                  });
                },
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () {
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: const Text("Confirmar Creacion De Usuario"),
                        content: const Text(
                            "¿Está seguro de que desea completar la creacion de usuario?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              createUserInFirestore();
                            },
                            child: const Text(
                              "Confirmar",
                              style: TextStyle(color: TeAppColorPalette.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancelar",
                                style: TextStyle(
                                    color: TeAppColorPalette.white)),
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
              const SizedBox(height: 72),
            ],
          ),
        ),
      ),
    );
  }
}
