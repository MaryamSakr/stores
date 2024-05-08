import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_project_name/Login.dart';
import 'getFormTextField.dart';
import 'StoresDB.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String _gender = '';
  String _level = '';
  final _studentID = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _conPassword = TextEditingController();
  List<String> _genders =["Male" ,"Female"];
  List<String> _levels =['1','2','3','4'];
  var file;
  SignUp() async {
    final appProvider = Provider.of<Stores>(context , listen: false);
    String name = _name.text;
    String gender = _gender;
    String email = _email.text;
    String studentID = _studentID.text;
    String level = _level;
    String password = _password.text;
    String conPassword = _conPassword.text;

    if (_globalKey.currentState!.validate()) {
      // Call getDataCustomer and await the result
      var customerData = await appProvider.getDataCustomer(studentID);

      // Check if customerData is null or empty
      if (customerData == null || customerData.isEmpty) {
        print("Customer with ID $studentID does not exist");
        // Proceed with sign up
        if (password != conPassword) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Invalid Credentials"),
                content: Text("Two Passwords Not The Same"),
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
          print("Successfully registered");
          appProvider.insertDataCustomer(name: name, id: studentID, Gender: gender, Email: email, Password: password, Level: level);
          Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
        }
      } else {
        // Show error dialog if customer exists
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Invalid Credentials"),
              content: Text("This ID already exists"),
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<Stores>(context , listen: false);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Sign up",
            style: TextStyle(color: Colors.blue,
                fontWeight: FontWeight.bold),),
        ),
        body: Form(


          key: _globalKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: 20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                     getTextFormField(
                          controller: _name,
                          icon: Icons.person,
                          hintName: 'User name'
                      ),
                    SizedBox(height: 10,),
                    getTextFormField(
                        controller: _email,
                        icon: Icons.mail,
                        hintName: 'studentID@stud.fci-cu.edu.eg'
                    ),
                    SizedBox(height: 10,),
                    getTextFormField(
                        controller: _studentID,
                        icon: Icons.info,
                        hintName: 'student id',
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(horizontal:40),
                      child:
                        Text('Gender'),
                    ),
                    for(int i=0;i < _genders.length; i++)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Radio(value: _genders[i].toString(),
                              groupValue: _gender,
                              onChanged: (value) {
                                setState(() {
                                  _gender = value.toString();
                                });
                              },),
                            Text(_genders[i]),
                          ],
                        ),
                      ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(horizontal:40),
                      child:
                      Text('Level'),
                    ),
                    for(int i=0;i < _levels.length; i++)
                      Container(
                        padding:const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Radio(value: _levels[i].toString(),
                              groupValue: _level,
                              onChanged: (value) {
                                setState(() {
                                  _level = value.toString();
                                });
                              },),
                            const Text("Level "),
                            Text(_levels[i]),
                          ],
                        ),
                      ),
                    SizedBox(height: 10,),
                    getTextFormField(
                      controller: _password,
                      icon: Icons.lock,
                      hintName: 'password',
                        isObscureText: true,
                    ),
                    SizedBox(height: 10,),
                    getTextFormField(
                      controller: _conPassword,
                      icon: Icons.lock,
                      hintName: 'confirm password',
                        isObscureText: true,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                          SignUp();


                        // localStorge local = localStorge();
                        // bool isExist = await local.checkID(_studentID.text);
                        // if(!isExist){
                        //   showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return AlertDialog(
                        //         title: Text("Invalid Credentials"),
                        //         content: Text("This Id Is Already Exist"),
                        //         actions: <Widget>[
                        //           ElevatedButton(
                        //             child: Text("OK"),
                        //             onPressed: () {
                        //               Navigator.of(context).pop();
                        //             },
                        //           ),
                        //         ],
                        //       );
                        //     },
                        //   );
                        // }else {
                        //   SignUp();
                        // }
                      }, child:const Text('Sign up',style: TextStyle(color: Colors.blue),),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print(appProvider.deleteUsers());
                      },
                      child: Text('Delete Data'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        SizedBox(width: 5,),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                            },
                            child:const Text('Log in',style: TextStyle(color: Colors.blue),)
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
