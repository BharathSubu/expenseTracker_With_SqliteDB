import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transaction;
  TransactionList(this.transaction);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: ListView.builder(
        itemCount: transaction.length,
        itemBuilder: (context, index) {
          return Card(
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  )),
                  child: Text(
                    '\$${transaction[index].amount.toStringAsFixed(2)}', //to specify the floating value
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      transaction[index].title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                    Text(
                      DateFormat().format(transaction[index].date),
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
