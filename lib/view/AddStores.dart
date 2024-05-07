import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../StoresDB.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

class AddStorePage extends StatefulWidget {
  @override
  _AddStorePageState createState() => _AddStorePageState();
}

class _AddStorePageState extends State<AddStorePage> {
  final TextEditingController _xController = TextEditingController();
  final TextEditingController _yController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  File? _image;

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _storeNameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _addStore()async {
    final appProvider = Provider.of<Stores>(context, listen: false);

    // Retrieve input values
    final  int x = int.parse(_xController.text);
    final int y = int.parse(_yController.text);
    final String storeName = _storeNameController.text;
    final String city = _cityController.text;

    // Convert the image to bytes
    Uint8List? imageBytes;
    if (_image != null) {
      imageBytes = _image!.readAsBytesSync();
    }

    // Call the method to add the store
    appProvider.insertDataStores(
      name: storeName,
      imageBytes: imageBytes,
      city: city,
      x: x,
      y: y,

    );
  // Navigator.pop(context);
    // Navigate back to the store list page
    Navigator.push(context, MaterialPageRoute(builder: (context) =>MyBottomNavigationBar(0)));

//       MaterialPageRoute(builder: (context) => HomeScreen());

  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<Stores>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Store'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _xController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'X Coordinate'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _yController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Y Coordinate'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _storeNameController,
              decoration: InputDecoration(labelText: 'Store Name'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Take Picture'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Choose from Gallery'),
            ),
            SizedBox(height: 16.0),
            _image != null
                ? Image.file(_image!)
                : Placeholder(
              fallbackHeight: 200.0,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
                onPressed: _addStore,
              child: Text('Add Store'),
            ),
          ],
        ),
      ),
    );
  }
}










//
//
//
//
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:your_project_name/main.dart';
// import '../StoresDB.dart';
// import 'StorePage.dart'; // Assuming this is the file where StoresPage is defined
//
// class AddStorePage extends StatefulWidget {
//   @override
//   _AddStorePageState createState() => _AddStorePageState();
// }
//
// class _AddStorePageState extends State<AddStorePage> {
//   final TextEditingController _xController = TextEditingController();
//   final TextEditingController _yController = TextEditingController();
//   final TextEditingController _storeNameController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   File? _image;
//
//   @override
//   void dispose() {
//     _xController.dispose();
//     _yController.dispose();
//     _storeNameController.dispose();
//     _cityController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: source);
//     if (pickedImage != null) {
//       setState(() {
//         _image = File(pickedImage.path);
//       });
//     }
//   }
//
//   // void _addStore() {
//   //   final appProvider = Provider.of<Stores>(context, listen: false);
//   //
//   //   // Retrieve input values
//   //   final int x = int.parse(_xController.text);
//   //   final int y = int.parse(_yController.text);
//   //   final String storeName = _storeNameController.text;
//   //   final String city = _cityController.text;
//   //
//   //   // Convert the image to bytes
//   //   Uint8List? imageBytes;
//   //   if (_image != null) {
//   //     imageBytes = _image!.readAsBytesSync();
//   //   }
//   //
//   //   // Call the method to add the store
//   //   appProvider.insertDataStores(
//   //     x: x,
//   //     y: y,
//   //     name: storeName,
//   //     city: city,
//   //     imageBytes: imageBytes,
//   //   );
//   //
//   //   // Navigate back to the store list page
//   //   Navigator.pop(context); // This will pop the AddStorePage and return to the previous page
//   // }
//
//
//   void _addStore() {
//     final appProvider = Provider.of<Stores>(context, listen: false);
//
//     // Retrieve input values
//     final int x = int.parse(_xController.text);
//     final int y = int.parse(_yController.text);
//     final String storeName = _storeNameController.text;
//     final String city = _cityController.text;
//
//     // Convert the image to bytes
//     Uint8List? imageBytes;
//     if (_image != null) {
//       imageBytes = _image!.readAsBytesSync();
//     }
//
//     // Call the method to add the store
//     appProvider.insertDataStores(
//       x: x,
//       y: y,
//       name: storeName,
//       city: city,
//       imageBytes: imageBytes,
//     );
//
//     // Navigate to the store list page
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => HomeScreen()),
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Store'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextFormField(
//               controller: _xController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(labelText: 'X Coordinate'),
//             ),
//             SizedBox(height: 16.0),
//             TextFormField(
//               controller: _yController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(labelText: 'Y Coordinate'),
//             ),
//             SizedBox(height: 16.0),
//             TextFormField(
//               controller: _storeNameController,
//               decoration: InputDecoration(labelText: 'Store Name'),
//             ),
//             SizedBox(height: 16.0),
//             TextFormField(
//               controller: _cityController,
//               decoration: InputDecoration(labelText: 'City'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () => _pickImage(ImageSource.camera),
//               child: Text('Take Picture'),
//             ),
//             SizedBox(height: 8.0),
//             ElevatedButton(
//               onPressed: () => _pickImage(ImageSource.gallery),
//               child: Text('Choose from Gallery'),
//             ),
//             SizedBox(height: 16.0),
//             _image != null
//                 ? Image.file(_image!)
//                 : Placeholder(
//               fallbackHeight: 200.0,
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _addStore,
//               child: Text('Add Store'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }























//
// @override
//   Widget build(BuildContext context) {
//     final appProvider = Provider.of<Stores>(context);
// appProvider.createDatabase();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 appProvider.getPostion();
//               },
//               child: Text('Get Position'),
//             ),
//             ElevatedButton(
//               onPressed: ()async {
//                 ByteData assetData = await rootBundle.load('assets/Book.png');
//                 Uint8List imageFile = assetData.buffer.asUint8List();
//                 appProvider.insertDataStores(
//                   name: 'John Doe',
//                   imageBytes: imageFile,
//                   city: 'password',
//                   x: 10,
//                   y: 10,
//                 );
//
//               },
//               child: Text('Insert Sign Up Data'),
//             ),
//
//             ElevatedButton(
//               onPressed: () {
//                 appProvider.deleteStoresData();
//
//               },
//               child: Text('Delete Data'),
//             ),
//
//
//             Expanded(
//               child: ListView.builder(
//                 itemCount: appProvider.storesData.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   Map<String, dynamic> item = appProvider.storesData[index];
//                   return Container(
//                     margin: EdgeInsets.symmetric(vertical: 5.0),
//                     padding: EdgeInsets.all(10.0),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Name: ${item['name']}',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ), Image.memory(Uint8List.fromList(item['image'])),
//                         Text('id: ${item['id']}'),
//                         Text('city: ${item['city']}'),
//                         Text('x: ${item['x']}'),
//                         Text('y: ${item['y']}'),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }

//
