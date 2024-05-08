import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';




class Stores extends ChangeNotifier {
  DatabaseFactory databaseFactory = databaseFactoryFfi;

  late Database database;
  List<Map<String, dynamic>> storesData = [];
  List<Map<String, dynamic>> CustomerData = [];
  List<Map<String, dynamic>> favoriteData = [];
  bool services = false;
  var per;
  Position? current;
  List<Placemark>? placemarker;
  double? distance;
  var distanceBetween;
  bool? isFavorited;

  Stores() {
    createDatabase();
  }

  createDatabase() async {
    sqfliteFfiInit();

    database = await openDatabase(
      join(await getDatabasesPath(), 'App_Stores.db'),
      version: 1,
      onCreate: (db, version) {

        db.execute(
          'CREATE TABLE stores (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, image BLOB, city TEXT , x INTEGER , y  INTEGER)',
        );
        db.execute(
          'CREATE TABLE fav (id INTEGER PRIMARY KEY, name TEXT, image BLOB, city TEXT , x INTEGER , y  INTEGER , customerId TEXT )',
        );
        db.execute(
          'CREATE TABLE customers (id TEXT PRIMARY KEY, name TEXT, gender TEXT , level TEXT , email TEXT , password TEXT )',
        );
      },
    );
    //
    // getDataStores();
    // getDataFavorite();
  }

  getPostion() async {
    // Your implementation here
  }


  insertDataCustomer({
    required String name,
    required String id,
    required String Gender,
    required String Email,
    required String Password,
    required String Level,

  }) async {
    await database.transaction((txn) async {
      await txn.rawInsert(
        'INSERT INTO customers (id , name , gender  , level  , email  , password  ) VALUES (? , ?, ? , ? , ? , ?)',
        [id, name, Gender, Level, Email, Password],
      );
    });
  }

  getDataCustomer(String customerID) async {

    List<Map<String, dynamic>> CustomerDataSign= await database.rawQuery('SELECT * FROM customers WHERE id = ${customerID}');
    if(CustomerDataSign.isEmpty){
      notifyListeners();
      return null;
    }else{
      notifyListeners();
      return CustomerDataSign;
    }

  }

  checkLogin(String Email , String Pass)async{
    List<Map<String, dynamic>> CustomerDataLogin = await database.rawQuery('SELECT * FROM customers WHERE email = \'$Email\' AND password = \'$Pass\'');
    if(CustomerDataLogin.isEmpty){
      notifyListeners();
      return null;
    }else{
      notifyListeners();
      return CustomerDataLogin;
    }
  }

  getAllDataCustomer() async {
    CustomerData= await database.rawQuery('SELECT * FROM customers');
    notifyListeners();

  }



  insertDataStores({
    required String name,
    Uint8List? imageBytes,
    required String city,
    required  int x,
    required  int y,

  }) async {
    await database.transaction((txn) async {
      await txn.rawInsert(
        'INSERT INTO stores (name , image , city , x , y) VALUES(?, ?, ? , ?,?)',
        [name, imageBytes, city,x,y],
      );
    });

    getDataStores();
  }

  getDataStores() async {
    storesData = await database.rawQuery('SELECT * FROM stores');
    notifyListeners();
  }

  insertDatabaseFav({
    required String name,
    Uint8List? imageBytes,
    required String city,
    required int x,
    required int y,
    required String customerId,

  }) async {
    await database.transaction((txn) async {

      await txn.rawInsert(
        'INSERT INTO fav(name, image, city ,x ,y , customerId) VALUES(?, ?, ?,?,? , ?)',
        [name, imageBytes, city , x , y , customerId],
      );
    });

    getDataFavorite(customerId);
  }

  getDataFavorite(String CustID) async {
    favoriteData = await database.rawQuery('SELECT * FROM fav WHERE customerId = \'$CustID\'');
    notifyListeners();
  }



  deleteFavData(String name , String customerId) async {
    await database.rawDelete('DELETE FROM fav WHERE name = ?', [name]);
    getDataFavorite(customerId);
  }

  deleteStoresData() async {
    await database.rawDelete('DELETE FROM stores');
    getDataStores();
  }

  deleteUsers() async {
    await database.rawDelete('DELETE FROM customers');
    getAllDataCustomer();
  }

  // deleteAllFav() async {
  //   await database.rawDelete('DELETE FROM fav');
  //   getDataFavorite();
  // }

  void changeNav() {
    // Your implementation here
  }

  void changeToDistance() {
    // Your implementation here
  }

  // bool isFavorite(Map<String, dynamic> store) {
  //   return favoriteData.any((favorite) => favorite['id'] == store['id']);
  // }


  bool isFavorite(Map<String, dynamic> store) {
    return favoriteData.any((favorite) => favorite['name'] == store['name'] && favorite['city']==store['city']&& favorite['x']==store['x']&& favorite['y']==store['y']);
  }

  void toggleFavorite(Map<String, dynamic> store , String CustID) {
    if (isFavorite(store)) {
      deleteFavData(store['name'] , CustID);
    } else {
      insertDatabaseFav(name: store['name'], city: store['city'], x: store['x'], y: store['y'], imageBytes: store['image'] , customerId:CustID );
    }
    // Update favoriteData list
    getDataFavorite( CustID);
    notifyListeners();
  }

}

// Your existing code...


