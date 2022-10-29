import 'package:flutter/material.dart';
import 'package:cashier/screens/home_screen.dart';

void main() => runApp(const CashierApp());

class CashierApp extends StatelessWidget {
  const CashierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Cashier App',
      home: HomeScreen(),
    );
  }
}
