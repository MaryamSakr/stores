
import 'storeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model.dart';
import 'favStore.dart'; // Import Store and StoreListModel


class StorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stores'),
      ),
      body: Column(
        children: [
          // Add store button
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Show dialog to enter x and y coordinates
              showDialog(
                context: context,
                builder: (context) {
                  double x = 0.0;
                  double y = 0.0;
                  return AlertDialog(
                    title: const Text('Add New Store'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: const InputDecoration(labelText: 'X Coordinate'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => x = double.tryParse(value) ?? 0.0,
                        ),
                        TextField(
                          decoration: const InputDecoration(labelText: 'Y Coordinate'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => y = double.tryParse(value) ?? 0.0,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Add a new store with the entered coordinates
                          Provider.of<StoreListModel>(context, listen: false).addStore(
                            Store(
                              name: 'New Store',
                              imageUrl: 'assets/pngwing.com (6).png',
                              x: x,
                              y: y,
                            ),
                          );
                          Navigator.pop(context); // Close the dialog
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          // Display stores
          Expanded(
            child: Consumer<StoreListModel>(
              builder: (context, storeList, child) {
                return ListView.builder(
                  itemCount: storeList.stores.length,
                  itemBuilder: (context, index) {
                    final store = storeList.stores[index];
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Store profile picture
                              const CircleAvatar(
                                backgroundImage: AssetImage('assets/pngwing.com (6).png'),
                                radius: 24.0,
                              ),
                              // Favorite icon
                              IconButton(
                                icon: Icon(store.isFavorited ? Icons.favorite : Icons.favorite_border),
                                onPressed: () {
                                  // Toggle favorite status
                                  Provider.of<StoreListModel>(context, listen: false).toggleFavoriteStatus(index);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          // Store name
                          Text(
                            store.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          // Store image
                          Image.asset(
                            store.imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Button to navigate to FavoritePage
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritePage()),
              );
            },
            child: const Text('Go to Favorites'),
          ),
        ],
      ),
    );
  }
}
















