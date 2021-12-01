import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' hide Transaction;
import '../models/transaction.dart';

class TransactionsDatabase {
  static final TransactionsDatabase instance = TransactionsDatabase._init();

  static Database _database;

  TransactionsDatabase._init();

  Future<Database> get database async {
    return _database ??= await _initDB("transactions.db");
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    final doubleType = 'DOUBLE  NOT NULL';

    await db.execute('''
    CREATE TABLE $tableTransactions ( 
    ${TransactionFields.id} $idType, 
    ${TransactionFields.title} $textType,
    ${TransactionFields.amount} $doubleType,
    ${TransactionFields.date} $textType
    )
  ''');
  }

  Future<Transaction> create(Transaction transaction) async {
    final db = await instance.database;
    final id = await db.insert(tableTransactions, transaction.toJson());
    return transaction.copy(id: id);
  }

  Future<Transaction> readTransaction(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTransactions,
      columns: TransactionFields.values,
      where: '${TransactionFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Transaction.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Transaction>> readAllTransactions() async {
    final db = await instance.database;

    final orderBy = '${TransactionFields.date} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableTransactions, orderBy: orderBy);

    return result.map((json) => Transaction.fromJson(json)).toList();
  }

  Future<int> update(Transaction note) async {
    final db = await instance.database;

    return db.update(
      tableTransactions,
      note.toJson(),
      where: '${TransactionFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTransactions,
      where: '${TransactionFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
