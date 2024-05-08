import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../StoresDB.dart';

class HomeScreen extends StatefulWidget {
  final String custID;

  const HomeScreen(this.custID);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final appProvider = Provider.of<Stores>(context, listen: false);
    appProvider.getDataStores();
    appProvider.getDataFavorite(widget.custID);
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<Stores>(context);
    final favoriteStores = appProvider.favoriteData;

    return Scaffold(
      appBar: AppBar(
        title: Text('Stores Database'),
      ),
      body: Column(
        children: [
          // ElevatedButton(
          //   onPressed: () {
          //     appProvider.deleteStoresData();
          //   },
          //   child: Text('Delete Data'),
          // ),
          // ElevatedButton(
          //   onPressed: () async {
          //     // Example of inserting data
          //     // Replace this with your own logic
          //     ByteData assetData =
          //         await rootBundle.load('assets/Book.png');
          //     Uint8List imageFile = assetData.buffer.asUint8List();
          //     appProvider.insertDataStores(
          //       name: 'John Doe',
          //       imageBytes: imageFile,
          //       city: 'New York',
          //       x: 10,
          //       y: 10,
          //     );
          //   },
          //   child: Text('Insert Data'),
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: appProvider.storesData.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> item = appProvider.storesData[index];
                bool isFavorite = appProvider.isFavorite(item);
                return ListTile(
                  title: Text('${item['name']}'),
                  subtitle: Text('${item['city']}'),
                  trailing: IconButton(
                    onPressed: () {
                      appProvider.toggleFavorite(item, widget.custID);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isFavorite
                              ? 'Removed from favorites'
                              : 'Added to favorites'),
                        ),
                      );
                    },
                    icon: isFavorite
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                  ),
                  onTap: () {
                    // Navigate to a detailed page or perform an action
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}