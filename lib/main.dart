import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:your_project_name/view/FavoritePage.dart';
import 'StoresDB.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Stores(),
      child: MaterialApp(
        debugShowCheckedModeBanner:false,
        home: MyBottomNavigationBar(0),
      ),
    ),
  );
}

class MyBottomNavigationBar extends StatefulWidget {
  int selectedIndex = 0;
  MyBottomNavigationBar(int s) {
    selectedIndex = s;
  }
  @override
  _MyBottomNavigationBarState createState() =>
      _MyBottomNavigationBarState(selectedIndex);
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;

  _MyBottomNavigationBarState(int s) {
    _selectedIndex = s;
  }

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    AddStorePage(),
    FavoriteStoresScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite Stores',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<Stores>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Stores Database'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              appProvider.deleteStoresData();
            },
            child: Text('Delete Data'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Example of inserting data
              // Replace this with your own logic
              ByteData assetData =
              await rootBundle.load('assets/Book.png');
              Uint8List imageFile = assetData.buffer.asUint8List();
              appProvider.insertDataStores(
                name: 'John Doe',
                imageBytes: imageFile,
                city: 'New York',
                x: 10,
                y: 10,
              );
            },
            child: Text('Insert Data'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: appProvider.storesData.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> item = appProvider.storesData[index];
                bool isFavorite = appProvider.isFavorite(item);
                return ListTile(
                  title: Text('Name: ${item['name']}'),
                  subtitle: item['image'] != null
                      ? Image.memory(Uint8List.fromList(item['image']))
                      : Text('No Image'),
                  trailing: IconButton(

                    onPressed: () {
                      appProvider.toggleFavorite(item);
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
                        : Icon(Icons.favorite_border)
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

    // Navigate to the appropriate screen based on the selected index
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // If there's a screen to pop, pop it
    } else {
      // If there's no screen to pop (e.g., if the AddStorePage is the initial route),
      // navigate to the HomeScreen based on the selected index
      final _MyBottomNavigationBarState bottomNavState =
      context.findAncestorStateOfType<_MyBottomNavigationBarState>()!;
      bottomNavState._onItemTapped(0); // Navigate to HomeScreen (index 0)
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => _addStore(context),
              child: Text('Add Store'),
            ),
          ],
        ),
      ),
    );
  }
}
