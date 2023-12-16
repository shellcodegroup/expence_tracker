import 'package:flutter/material.dart';

class TransactionsWidget extends StatelessWidget {
  final String transactionName;
  final String transactionAmount;
  final String expenceOrIcome;
  const TransactionsWidget(
      {super.key,
      required this.transactionName,
      required this.transactionAmount,
      required this.expenceOrIcome});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
          height: 55,
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(transactionName.capitalize()),
              Text(
                'Ksh ${expenceOrIcome == 'Expense' ? '-' : '+'}$transactionAmount ',
                style: TextStyle(
                    color: expenceOrIcome == 'Expense'
                        ? Colors.red
                        : Colors.green),
              )
            ],
          ))),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
