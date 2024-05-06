
import 'package:flutter/material.dart';
import '../model.dart';

class StoreListModel extends ChangeNotifier {
  List<Store> _stores = [];

  List<Store> get stores => _stores;

  void addStore(Store store) {
    _stores.add(store);
    notifyListeners();
  }

  void toggleFavoriteStatus(int index) {
    _stores[index].isFavorited = !_stores[index].isFavorited;
    notifyListeners();
  }

  List<Store> getFavoriteStores() {
    return _stores.where((store) => store.isFavorited).toList();
  }
}
