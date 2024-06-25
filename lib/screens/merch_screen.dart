import 'package:flutter/material.dart';

class MerchScreen extends StatefulWidget {
  const MerchScreen({super.key});

  @override
  State<MerchScreen> createState() => _MerchScreenState();
}

class _MerchScreenState extends State<MerchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DANIEL HUELE FEO'),
      ),
      body: const Center(child: Text('DANIEL CAE MAL'),),
    );
  }
}
