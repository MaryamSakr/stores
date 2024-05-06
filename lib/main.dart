import 'package:assiment_2/the%20store%20view/storeProvider.dart';
import 'package:assiment_2/the%20store%20view/view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Assuming StoreListModel is defined in this file

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StoreListModel(), // Create an instance of StoreListModel
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StorePage(), // Now StorePage will have access to StoreListModel
    );
  }
}
