// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:outwork_final_admin_panel_app/models/new_sale_model_.dart';
import 'package:outwork_final_admin_panel_app/utils/google_sheets_sales_api.dart';
import '../assets/app_color_palette.dart';
import '../assets/app_theme.dart';
import '../widgets/te_dropdown_menu.dart';
import '../widgets/te_textfield.dart';

class SaleScreen extends StatefulWidget {
  final String uid; // Add this to receive the UID

  const SaleScreen({super.key, required this.uid}); // Update constructor

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  var _selectedIndex = 1;
  String selectedPackage = '1 Sesion';
  String? otherQuantity;
  final TextEditingController otherQuantityController = TextEditingController();
  final TextEditingController discountPercentageController =
      TextEditingController();

  List<String> classCoachesDropDownMenu = [
    '1 Sesion',
    '5 Sesiones',
    '15 Sesiones',
    'Full Access',
    '1 Sesion De Adolecente',
    '10 Sesiones De Adolecente',
    'Adolecente Full Access',
    'Otro',
  ];

  Future<void> _updateUserCredits() async {
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(widget.uid);

    try {
      DocumentSnapshot userSnapshot = await userDoc.get();
      if (userSnapshot.exists) {
        int currentCredits = userSnapshot['creditsAvailable'] ?? 0;
        String membership = userSnapshot['membership'] ?? '';

        switch (selectedPackage) {
          case '1 Sesion':
            membership = 'sessions';
            currentCredits += 1;
            break;
          case '5 Sesiones':
            membership = 'sessions';
            currentCredits += 5;
            break;
          case '15 Sesiones':
            membership = 'sessions';
            currentCredits += 15;
            break;
          case '1 Sesion De Adolecente':
            membership = 'sessions';
            currentCredits += 1;
            break;
          case '10 Sesiones De Adolecente':
            membership = 'sessions';
            currentCredits += 10;
            break;
          case 'Full Access':
            membership = 'membership';
            currentCredits = 0;
            break;
          case 'Adolecente Full Access':
            membership = 'membership';
            currentCredits = 0;
            break;
          default:
            break;
        }

        await userDoc.update({
          'creditsAvailable': currentCredits,
          'membership': membership,
        });
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("REGISTRE NUEVA VENTA")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 64),
        child: Column(
          children: [
            const SizedBox(height: 60),
            TeDropDownMenu(
              context: context,
              value: selectedPackage,
              items: classCoachesDropDownMenu,
              onChanged: (newValue) {
                setState(() {
                  selectedPackage = newValue;
                });
              },
            ),
            if (selectedPackage == 'Otro') const SizedBox(height: 30),
            if (selectedPackage == 'Otro')
              TeTextField(
                controller: otherQuantityController,
                labelText: 'Ingresa Otra Cantidad',
                isPercentage: false,
              ),
            const SizedBox(height: 30),
            TeTextField(
              controller: discountPercentageController,
              labelText: 'Ingresar Porcentaje De Descuento',
              isPercentage: true,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildButton(0, 'Efectivo'),
                const SizedBox(width: 32),
                buildButton(1, 'Transferencia'),
                const SizedBox(width: 32),
                buildButton(2, 'Terminal'),
              ],
            ),
            const Expanded(child: SizedBox()),
            SizedBox(
              height: 100,
              child: TextButton(
                onPressed: () {
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: const Text("Confirmar Compra"),
                        content: const Text(
                            "¿Está seguro de que desea completar la venta?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Close the dialog
                              Navigator.of(context).pop();
                              // Perform action upon confirmation
                              _completePurchase();
                            },
                            child: const Text(
                              "Confirmar",
                              style: TextStyle(color: TeAppColorPalette.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Close the dialog
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancelar",
                                style:
                                    TextStyle(color: TeAppColorPalette.white)),
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

  Future<void> _completePurchase() async {
    // Fetch user document from Firestore
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();

    // Check if the document exists and retrieve the name
    if (userSnapshot.exists) {
      String userName = userSnapshot['name'] ?? 'Athlete Name';

      // Construct the sale object
      final sale = {
        NewSaleModel.id: widget.uid,
        NewSaleModel.name: userName,
        NewSaleModel.date: DateTime.now().toString(),
        NewSaleModel.price: selectedPackage == 'Otro'
            ? otherQuantityController.text
            : getPrice(),
        NewSaleModel.discountPercentage: discountPercentageController.text,
        NewSaleModel.paymentForm: getPaymentForm(),
        NewSaleModel.package: selectedPackage,
      };

      // Insert sale into Google Sheets
      await GoogleSheetsSalesApi.insert([sale]);

      // Close all screens and show success message
      Navigator.of(context).popUntil((route) => route.isFirst);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Venta Completada Exitosamente'),
        ),
      );

      // Update user credits in Firestore
      _updateUserCredits();
    } else {
      // Handle case where user document does not exist
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontró el usuario'),
        ),
      );
    }
  }

  Widget buildButton(int index, String text) {
    return Expanded(
      child: SizedBox(
        height: 100,
        child: TextButton(
          onPressed: () {
            setState(() {
              _selectedIndex = index; // Update selected index
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: TeAppColorPalette.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(300.0),
              side: BorderSide(
                width: 4,
                color: _selectedIndex == index
                    ? TeAppColorPalette.green
                    : TeAppColorPalette.black,
              ),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontFamily: TeAppThemeData.teFont,
              color: TeAppColorPalette.white,
              fontSize: 28,
            ),
          ),
        ),
      ),
    );
  }

  getPaymentForm() {
    if (_selectedIndex == 0) {
      return 'Efectivo';
    } else if (_selectedIndex == 1) {
      return 'Tranferencia';
    } else if (_selectedIndex == 2) {
      return 'Terminal';
    }
  }

  getPrice() {
    switch (selectedPackage) {
      case '1 Sesion':
        return '250';

      case '5 Sesiones':
        return '1100';

      case '15 Sesiones':
        return '3000';

      case '1 Sesion De Adolecente':
        return '180';

      case '10 Sesiones De Adolecente':
        return '1620';

      case 'Full Access':
        return '2600';

      case 'Adolecente Full Access':
        return '2000';

      default:
        break;
    }
  }
}
