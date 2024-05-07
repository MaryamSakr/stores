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
          'CREATE TABLE fav (id INTEGER PRIMARY KEY, name TEXT, image BLOB, city TEXT , x INTEGER , y  INTEGER)',
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

  }) async {
    await database.transaction((txn) async {

      await txn.rawInsert(
        'INSERT INTO fav(name, image, city ,x ,y) VALUES(?, ?, ?,?,?)',
        [name, imageBytes, city , x , y],
      );
    });

    getDataFavorite();
  }

  getDataFavorite() async {
    favoriteData = await database.rawQuery('SELECT * FROM fav');
    notifyListeners();
  }


  deleteFavData(String name) async {
    await database.rawDelete('DELETE FROM fav WHERE name = ?', [name]);
    getDataFavorite();
  }

  deleteStoresData() async {
    await database.rawDelete('DELETE FROM stores');
    getDataStores();
  }


  void changeNav() {
    // Your implementation here
  }

  void changeToDistance() {
    // Your implementation here
  }

  bool isFavorite(Map<String, dynamic> store) {
    return favoriteData.any((favorite) => favorite['id'] == store['id']);
  }



  void toggleFavorite(Map<String, dynamic> store) {
    if (isFavorite(store)) {
      // Remove from favorites
      deleteFavData(store['name']);
    } else {
      // Add to favorites
      insertDatabaseFav(name: store['name'], city: store['city'], x: store['x'], y: store['y']);
    }
    // Update favoriteData list
    getDataFavorite();
    notifyListeners();
  }

}

// Your existing code...


