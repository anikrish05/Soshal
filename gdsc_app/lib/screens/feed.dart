import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyApp extends StatefulWidget {
  //const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();

  final LatLng _center = const LatLng(36.9907207008804, -122.05845686120782);
  Marker ucscMarker = Marker(
    markerId: MarkerId('UCSC'),
    position: LatLng(36.9907207008804, -122.05845686120782),
    infoWindow: InfoWindow(title: 'UCSC'),
  );


  @override
  void initState() {
    super.initState();
  }
  void dispose() {
    _disposeController();
    super.dispose();
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await _controller.future;
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: {ucscMarker},
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}