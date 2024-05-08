import 'package:provider/provider.dart';
import 'package:your_project_name/view/BottomBar.dart';

import 'package:flutter/material.dart';
import 'StoresDB.dart';
import 'getFormTextField.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<Stores>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getTextFormField(
              controller: usernameController,
              icon: Icons.person,
              hintName: 'E-mail',
            ),
            const SizedBox(height: 20),
            getTextFormField(
              controller: passwordController,
              icon: Icons.lock,
              hintName: 'password',
              isObscureText: true,
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () async {
                var customerData = await appProvider.checkLogin(
                  usernameController.text,
                  passwordController.text,
                );
                if (customerData == null || customerData.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Invalid Credentials"),
                        content: Text("The email or password is not correct"),
                        actions: <Widget>[
                          ElevatedButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  String customerId =customerData[0]['id'];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyBottomNavigationBar(0, customerId),
                    ),
                  );
                }
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                const SizedBox(width: 5,),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
