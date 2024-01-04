import 'dart:async';

import 'package:expence_tracker/service/google_sheets_api.dart';
import 'package:expence_tracker/widgets/loading_circle.dart';
import 'package:expence_tracker/widgets/shimmer_loader.dart';
import 'package:expence_tracker/widgets/top_card.dart';
import 'package:expence_tracker/widgets/transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // collect user inputs
  final _textControllerAmount = TextEditingController();
  final _textControllerItem = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;
  // enter the new transaction into the spreadsheet
  void _enterTransaction() {
    GoogleSheetsApi.insert(
      _textControllerAmount.text,
      _textControllerItem.text,
      _isIncome,
    );
    setState(() {});
  }

  // new transaction
  void _newTransaction() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: const Text('Add new transaction'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Expense'),
                        Switch(
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                            splashRadius: 5,
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            }),
                        const Text('Income')
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      hintText: 'Amount'),
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Enter an amount';
                                    }
                                    return null;
                                  },
                                  controller: _textControllerItem,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      hintText: _isIncome == true
                                          ? 'Income name'
                                          : 'Expense name'),
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Enter a transaction name';
                                    }
                                    return null;
                                  },
                                  controller: _textControllerAmount,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.grey[500],
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.grey[500],
                    child: const Text(
                      'Enter',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterTransaction();
                        _textControllerItem.clear();
                        _textControllerAmount.clear();
                        Navigator.of(context).pop();
                      }
                    }),
              ],
            );
          },
        );
      },
    );
  }

  // wait for the timer to be fetched from goole sheets
  bool timerHasStarted = false;
  void startLoading() {
    timerHasStarted = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

// open clear dialog
  void _showClearDIalog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Clear Data'),
              content: const Text('This will clear all data'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Yes'))
              ],
            );
          },
        );
      },
    );
  }

// confirm exit dialog
  void _confirmexit() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Are you sure you want to exit?',
              style: TextStyle(fontSize: 12),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    // close dialog
                    Navigator.pop(context);
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // start loading until the data arrives
    if (GoogleSheetsApi.loading == true && timerHasStarted == false) {
      startLoading();
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Expense Tracker'),
          centerTitle: true,
          backgroundColor: Colors.grey[200],
          leading: IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              onPressed: () {
                // are you sure you want to exit dialog
                _confirmexit();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.grey[600],
                size: 30,
              )),
          actions: [
            IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                onPressed: () {
                  //open clear dialog
                  _showClearDIalog();
                },
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey[600],
                  size: 30,
                ))
          ],
        ),
        backgroundColor: Colors.grey[300],
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
          child: Column(
            children: [
              GoogleSheetsApi.loading == true
                  ? const ShimmerLoader()
                  : TopNeuCard(
                      balance: (GoogleSheetsApi.calculateIncome() -
                          GoogleSheetsApi.calculateExpense()),
                      income: GoogleSheetsApi.calculateExpense(),
                      expense: GoogleSheetsApi.calculateIncome().toString(),
                    ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: GoogleSheetsApi.loading == true
                      ? const LoadingCircle()
                      : ListView.builder(
                          itemCount: GoogleSheetsApi.currentTransactions.length,
                          itemBuilder: ((context, index) {
                            return TransactionsWidget(
                                transactionName: GoogleSheetsApi
                                    .currentTransactions[index][0],
                                transactionAmount: GoogleSheetsApi
                                    .currentTransactions[index][1],
                                expenceOrIcome: GoogleSheetsApi
                                    .currentTransactions[index][2]);
                          }),
                        ),
                ),
              ),
              FloatingActionButton(
                backgroundColor: Colors.grey[500],
                foregroundColor: Colors.white,
                onPressed: _newTransaction,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
