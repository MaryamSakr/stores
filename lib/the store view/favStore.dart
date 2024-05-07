
import 'storeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Stores'),
      ),
      body: Consumer<StoreListModel>(
        builder: (context, storeList, child) {
          final favoriteStores = storeList.getFavoriteStores();
          if (favoriteStores.isEmpty) {
            return const Center(
              child: Text('No favorite stores yet.'),
            );
          } else {
            return ListView.builder(
              itemCount: favoriteStores.length,
              itemBuilder: (context, index) {
                final store = favoriteStores[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/pngwing.com (6).png'), // Example profile picture
                  ),
                  title: Text(store.name),
                  subtitle: Text('Coordinates: (${store.x}, ${store.y})'),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      // Toggle favorite status when tapped
                      storeList.toggleFavoriteStatus(storeList.stores.indexOf(store));
                    },
                  ),
                  onTap: () {
                    // You can define an action when tapping on a favorite store post
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
