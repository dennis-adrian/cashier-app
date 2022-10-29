import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:cashier/helpers/thousands_input_formatter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final amountPaid = TextEditingController();
  final amountToCharge = TextEditingController();
  final changeToGive = TextEditingController();
  //state
  int charged = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    amountPaid.dispose();
    amountToCharge.dispose();
    super.dispose();
  }

  void calculateChargeAmount() {
    charged += amountToCharge.text.isNotEmpty
        ? int.parse(amountToCharge.text.replaceAll(',', ''))
        : 0;

    setState(() {});
  }

  void calculateChange() {
    int paid = amountPaid.text.isNotEmpty
        ? int.parse(amountPaid.text.replaceAll(',', ''))
        : 0;

    int chargedTextField = amountToCharge.text.isNotEmpty
        ? int.parse(amountToCharge.text.replaceAll(',', ''))
        : 0;

    int change = paid -
        (amountToCharge.text.isEmpty ? charged : chargedTextField + charged);
    var formatter = NumberFormat.decimalPattern('en_us');
    changeToGive.value =
        TextEditingValue(text: formatter.format(change).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cashier App')),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: amountPaid,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: '0',
                labelText: 'Cantidad pagada',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                ThousandsSeparatorInputFormatter(),
              ],
              onChanged: (value) {
                calculateChange();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                    controller: amountToCharge,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      hintText: charged.toString(),
                      labelText: 'Cantidad a cobrar',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      ThousandsSeparatorInputFormatter(),
                    ],
                    onChanged: (value) {
                      calculateChange();
                    },
                  ),
                ),
                const Spacer(),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        calculateChargeAmount();
                        amountToCharge.clear();
                      },
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: changeToGive,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Cambio a dar',
              ),
              readOnly: true,
              inputFormatters: [ThousandsSeparatorInputFormatter()],
            ),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.restart_alt),
        onPressed: () {
          amountPaid.clear();
          amountToCharge.clear();
          changeToGive.clear();
          charged = 0;
          setState(() {});
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }
}
