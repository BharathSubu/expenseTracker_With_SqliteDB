import 'package:flutter/foundation.dart';

//creating a user defined structure
final String tableTransactions = 'transactions';

class TransactionFields {
  static final List<String> values = [id, title, amount, title, date];
  static final String id = 'id';
  static final String title = 'title';
  static final String amount = 'amount';
  static final String date = 'date';
}

class Transaction {
  final int id;
  final String title;
  final double amount;
  final DateTime date;

  Transaction(
      {@required this.id,
      @required this.title,
      @required this.amount,
      @required this.date});
  Transaction copy({
    int id,
    String title,
    double amount,
    DateTime date,
  }) =>
      Transaction(
        id: id ?? this.id,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        date: date ?? this.date,
      );

  static Transaction fromJson(Map<String, Object> json) => Transaction(
        id: json[TransactionFields.id] as int,
        title: json[TransactionFields.title] as String,
        amount: json[TransactionFields.amount] as double,
        date: DateTime.parse(json[TransactionFields.date] as String),
      );
  Map<String, Object> toJson() => {
        TransactionFields.id: id,
        TransactionFields.title: title,
        TransactionFields.amount: amount,
        TransactionFields.date: date.toIso8601String(),
      };
}
