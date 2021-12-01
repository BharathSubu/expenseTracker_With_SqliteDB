import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';
import './Db/transactions_database.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //transaction lies here
  //sqlite bsased operation begins here
  List<Transaction> _userTransactions = [];
  bool isLoading = false;

  @override
  void initState() {
    //executed as soon as the app starts
    super.initState();
    refreshTransactions();
  }

  @override
  void dispose() {
    TransactionsDatabase.instance.close();
    super.dispose();
  }

  Future refreshTransactions() async {
    setState(() => isLoading = true);

    this._userTransactions =
        await TransactionsDatabase.instance.readAllTransactions();
    print("Transaction Loaded");

    setState(() => isLoading = false);
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now()
          .millisecondsSinceEpoch
          .abs()
          .toInt(), //id generated besed on milli seconds from epoch
    ); //so the newly created transaciton has id greater than the previous one

    Future createTransaction() async {
      print("Transaction added 1");
      await TransactionsDatabase.instance.create(newTx);
    }

    setState(() {
      _userTransactions.add(newTx);
      createTransaction();
      print("Transaction added 2");
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(int id) {
    Future deleteTransaction() async {
      print("Transaction deleted 1");
      await TransactionsDatabase.instance.delete(id);
    }

    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
      print("Transaction deleted 2");
      deleteTransaction();
    });
  }

  //sqlite based operation ends here and all the CRUD are passed from the main function to other modules
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Expenses',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Chart(_recentTransactions),
            TransactionList(_userTransactions, _deleteTransaction),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
