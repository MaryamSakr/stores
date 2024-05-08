import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../StoresDB.dart';
import 'package:image_picker/image_picker.dart';

import 'BottomBar.dart';

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

  void _addStore(BuildContext context) {
    final appProvider = Provider.of<Stores>(context, listen: false);

    // Retrieve input values
    final int x = int.parse(_xController.text);
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
      x: x,
      y: y,
      name: storeName,
      city: city,
      imageBytes: imageBytes,
    );


      // If there's no screen to pop (e.g., if the AddStorePage is the initial route),
      // navigate to the HomeScreen based on the selected index
      final MyBottomNavigationBarState bottomNavState =
      context.findAncestorStateOfType<MyBottomNavigationBarState>()!;
      bottomNavState.onItemTapped(0); // Navigate to HomeScreen (index 0)

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Store'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                decoration: InputDecoration(
                    labelText: 'Store Name',
                    errorText: _storeNameController.text.isEmpty
                        ? 'Please enter a store name'
                        : null),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),

              SizedBox(height: 25.0),
              _image != null
                  ? Image.file(_image!)
              :              Icon(Icons.store,size: 150,),

              //     : Placeholder(child: Icon(Icons.store),
              //
              //   fallbackHeight: 200.0,
              // ),
              SizedBox(height: 16.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: Icon(Icons.camera_alt),
                    label: Text('pic Picture'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: Icon(Icons.photo),
                    label: Text('take from Gallery'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _addStore(context),
                child: Text('Add Store'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
