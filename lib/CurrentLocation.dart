import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class CurrentLocation extends StatefulWidget {
  final int x;
  final int y;
  const CurrentLocation({required this.x, required this.y});
  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  late int x;
  late int y;
  late String lat;
  late String long;
  String message = 'Current Location';
  double distanceInMeters = 0.0;

  @override
  void initState() {
    super.initState();
    x = widget.x;
    y = widget.y;
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location Services Are Disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission Is Denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location Permission Is Denied, We Cannot Request Permission');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _calculateDistance() async {
    final currentPosition = await _getCurrentLocation();
    final startLocation = LatLng(currentPosition.latitude, currentPosition.longitude);
    final endLocation = LatLng(x.toDouble(), y.toDouble());
    final distance = Distance().as(
      LengthUnit.Kilometer,
      startLocation,
      endLocation,
    );
    setState(() {
      distanceInMeters = distance;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Distance'),
      ),
      body: Center(
        child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _getCurrentLocation().then((value) {
                    lat = '${value.latitude}';
                    long = '${value.longitude}';
                    _calculateDistance();
                  });
                },
                child: Text('Get Distance'),
              ),
              Text('Distance: ${distanceInMeters.toStringAsFixed(2)} Kilometers'),
            ]
        ),
      ),
    );
  }
}







// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart';
//
// class CurrentLocation extends StatefulWidget {
//   final int x;
//   final int y;
//
//   const CurrentLocation({required this.x, required this.y});
//
//   @override
//   _CurrentLocationState createState() => _CurrentLocationState();
// }
//
// class _CurrentLocationState extends State<CurrentLocation> {
//   late int x;
//   late int y;
//   late String lat;
//   late String long;
//   String message = 'Current Location';
//   double distanceInMeters = 0.0;
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     x = widget.x;
//     y = widget.y;
//   }
//
//   Future<Position> _getCurrentLocation() async {
//     setState(() {
//       isLoading = true;
//       message = 'Getting Distance ...';
//     });
//
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         return Future.error('Location Services Are Disabled');
//       }
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           return Future.error('Location Permission Is Denied');
//         }
//       }
//
//       if (permission == LocationPermission.deniedForever) {
//         return Future.error('Location Permission Is Denied, We Cannot Request Permission');
//       }
//
//       return await Geolocator.getCurrentPosition();
//     } catch (e) {
//       return Future.error('Failed to get current location: $e');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _calculateDistance() async {
//     final currentPosition = await _getCurrentLocation();
//     final startLocation = LatLng(currentPosition.latitude, currentPosition.longitude);
//     final endLocation = LatLng(x.toDouble(), y.toDouble());
//     final distance = Distance().as(
//       LengthUnit.Kilometer,
//       startLocation,
//       endLocation,
//     );
//     setState(() {
//       distanceInMeters = distance;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Get Distance'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ElevatedButton(
//               onPressed: isLoading ? null : () => _getCurrentLocation().then((value) {
//                 lat = '${value.latitude}';
//                 long = '${value.longitude}';
//                 setState(() {
//                   message = 'Lat: $lat, Long: $long';
//                 });
//                 _calculateDistance();
//               }),
//               child: isLoading ? CircularProgressIndicator() : Text('Get Distance'),
//             ),
//             SizedBox(height: 16.0),
//             Text(message),
//             SizedBox(height: 8.0),
//             Text('Distance: ${distanceInMeters.toStringAsFixed(2)} Kilometers'),
//           ],
//         ),
//       ),
//     );
//   }
// }
