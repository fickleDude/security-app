import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../models/contact_model.dart';

class DatabaseService extends ChangeNotifier{
  //database structure
  String contactTable = 'contact_table';
  String colId = 'id';
  String colContactName = 'name';
  String colContactNumber = 'number';

  // named private constructor..(used to create an instance of a singleton class)
  // it will be used to create an instance of the DatabaseHelper class
  DatabaseService._createInstance();
  //instance of the database service
  static DatabaseService? _databaseService; // this _databaseHelper will
  //initialize the db service
  //factory keyword allows the constructor to return some value
  factory DatabaseService() {
    //create an instance of _DatabaseHelper if there is no instance created before
    //using null check
    _databaseService ??= DatabaseService._createInstance();
    return _databaseService!;
  }

  // initialize the database
  static Database? _database;
  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String directoryPath = await getDatabasesPath();
    String dbLocation = '${directoryPath}contact.db';

    var contactDatabase =
    await openDatabase(dbLocation, version: 1, onCreate: _createDbTable);
    return contactDatabase;
  }

  void _createDbTable(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $contactTable($colId INTEGER PRIMARY KEY, $colContactName TEXT, $colContactNumber TEXT)');
  }

  // Fetch Operation: get contact object from db
  Future<List<Map<String, dynamic>>> getContactMapList() async {
    Database db = await database;
    List<Map<String, dynamic>> result =
    await db.rawQuery('SELECT * FROM $contactTable order by $colId ASC');

    // or
    // var result = await db.query(contactTable, orderBy: '$colId ASC');
    return result;
  }

  //Insert a contact object
  Future<int> insertContact(UserContact contact) async {
    Database db = await database;
    //insert returns id of last inserted row
    var result = await db.insert(contactTable, contact.toMap());
    // print(await db.query(contactTable));
    notifyListeners();
    return result;
  }

  // update a contact object
  Future<int> updateContact(UserContact contact) async {
    Database db = await database;
    var result = await db.update(contactTable, contact.toMap(),
        where: '$colId = ?', whereArgs: [contact.id]);
    notifyListeners();
    return result;
  }

  //delete a contact object
  Future<int> deleteContact(int id) async {
    Database db = await database;
    //rawDelete returns number of changes made
    int result =
    await db.rawDelete('DELETE FROM $contactTable WHERE $colId = $id');
    // print(await db.query(contactTable));
    notifyListeners();
    return result;
  }

  //get number of contact objects
  Future<int> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
    await db.rawQuery('SELECT COUNT (*) from $contactTable');
    int result = Sqflite.firstIntValue(x)!;
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Contact List' [ List<Contact> ]
  Future<List<UserContact>> getContactList() async {
    List<Map<String, dynamic>> contactMapList = [];
    await getContactMapList().then((value) => contactMapList = value); // Get 'Map List' from database
    int count =
        contactMapList.length; // Count the number of map entries in db table

    List<UserContact> contactList = <UserContact>[];
    // For loop to create a 'Contact List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      contactList.add(UserContact.fromMapObject(contactMapList[i]));
    }
    notifyListeners();
    return contactList;
  }
}
