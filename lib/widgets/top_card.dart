import 'package:flutter/material.dart';

class TopNeuCard extends StatelessWidget {
  final double balance;
  final double income;
  final String expense;
  const TopNeuCard(
      {super.key,
      required this.balance,
      required this.income,
      required this.expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[300],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: const Offset(4.0, 4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0,
            ),
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-4.0, -4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0,
            ),
          ]),
      padding: const EdgeInsets.all(30),
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'BALANCE',
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
          Text(
            'Ksh${balance.toStringAsFixed(2)}',
            style: TextStyle(color: Colors.grey[800], fontSize: 40),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.attach_money,
                      color: Colors.green,
                    ),
                  ),
                  Column(
                    children: [const Text('INCOME'), Text('Ksh$expense')],
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.money_off,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      const Text('EXPENSE'),
                      Text('Ksh$income'),
                    ],
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
