import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();
  final String _ticketsTableName = "tickets";
  final String _idColumnName = "id";
  final String _startLocationColumnName = "start";
  final String _destinationLocationColumnName = "destination";
  final String _dateTimeColumnName = "datetime";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getdatabase();
    return _db!;
  }

  Future<Database> getdatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      version: 1 ,
      databasePath,
      onCreate: (db, version){
        db.execute(
        '''
        CREATE TABLE $_ticketsTableName (
          $_idColumnName INTEGER PRIMARY KEY,
          $_startLocationColumnName TEXT NOT NULL,
          $_destinationLocationColumnName TEXT NOT NULL,
          $_dateTimeColumnName TEXT NOT NULL
        )

        ''');
      }
      );
    // List<Map<String, dynamic>> result = await database.rawQuery("SELECT name FROM sqlite_master WHERE type='table';");
    // print("Tables in the database: $result");
    return database;
  }


  void addTicket(String id, String start, String destination, String datetime) async {
    final db = await database;

    await db.insert(
      _ticketsTableName, 
      {
        _idColumnName: id,
        _startLocationColumnName: start,
        _destinationLocationColumnName: destination,
        _dateTimeColumnName: datetime,
      }
    );
  }

  void deleteAllData() async{
    final db = await database;
    await db.delete(
    _ticketsTableName,
  );
  }

  Future<void> deleteDatabaseFile() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");

    // Delete the database
    await deleteDatabase(databasePath);
    _db = null;

  }

  Future<List<Ticket>> getData() async{
    final db = await database;
    final data = await db.query(_ticketsTableName);
    List<Ticket> tickets = data
        .map((e) => Ticket(
          id: e["id"].toString(), 
          start: e["start"].toString(), 
          destination: e["destination"].toString(),
          datetime: e["datetime"].toString(),))
        .toList();
      
    return tickets;
  }

}

class Ticket {
  final String id;
  final String start;
  final String destination;
  final String datetime;
  
  Ticket({
    required this.id,
    required this.start,
    required this.destination,
    required this.datetime,

  });
}