import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../CurrentLocation.dart';
import '../StoresDB.dart';

class FavoriteStoresScreen extends StatelessWidget {
  final String custID;

  const FavoriteStoresScreen(this.custID);

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<Stores>(context, listen: false);
    appProvider.getDataFavorite(custID);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Stores'),
      ),
      body: Consumer<Stores>(
        builder: (context, appProvider, _) {
          final favoriteStores = appProvider.favoriteData;

          return ListView.builder(
            itemCount: favoriteStores.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> item = favoriteStores[index];
              return Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item['name']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${item['city']}',
                          style: TextStyle(fontSize: 12.0),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    subtitle: Container(
                      width: 180.0,
                      height: 180.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                      ),
                      child: Container(
                        child: item['image'] != null
                            ? Image.memory(
                          Uint8List.fromList(item['image']),
                          fit: BoxFit.fill,
                        )
                            : Image.asset(
                          'path_to_placeholder_image',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CurrentLocation(x: item['x'], y: item['y']),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Row(

                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CurrentLocation(x: item['x'], y: item['y']),
                            ),
                          );
                        },
                        child: Text('Calculate Distance'),
                      ),
                      SizedBox(width: 10,)
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                    height: 0.0,
                    endIndent: 10,
                    indent: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

