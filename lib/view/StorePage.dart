// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// import '../StoresDB.dart';
//
//
//
// class FavoritesPage extends StatelessWidget {
//   final Stores stores = Stores();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Favorites'),
//       ),
//       body: ListView.builder(
//         itemCount: stores.favoriteData.length,
//         itemBuilder: (context, index) {
//           final store = stores.favoriteData[index];
//
//           return ListTile(
//             title: Text(store['name']),
//             trailing: IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () {
//                 stores.deleteFavData(store['name'] , );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
