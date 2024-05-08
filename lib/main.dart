import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_project_name/Login.dart';
import 'package:your_project_name/SignUp.dart';
import 'package:your_project_name/view/BottomBar.dart';
import 'StoresDB.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Stores(),
      child: MaterialApp(
        debugShowCheckedModeBanner:false,
        home: SignupScreen(),
      ),
    ),
  );
}






