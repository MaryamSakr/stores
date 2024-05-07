import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../CurrentLocation.dart';
import '../StoresDB.dart';

class FavoriteStoresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<Stores>(context);
    final favoriteStores = appProvider.favoriteData;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Stores'),
      ),
      body: ListView.builder(
        itemCount: favoriteStores.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> item = favoriteStores[index];
          return ListTile(
            title: Text('Name: ${item['name']}'),
            subtitle: item['image'] != null
                ? Image.memory(Uint8List.fromList(item['image']))
                : Text('No Image'),
            onTap: () {
              // Navigate to a detailed page or perform an action
              Navigator.push(context, MaterialPageRoute(builder: (context) => CurrentLocation(x: item['x'], y: item['y'])));
            },
          );
        },
      ),
    );
  }
}

