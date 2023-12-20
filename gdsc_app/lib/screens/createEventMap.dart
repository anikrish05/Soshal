import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateEventMapScreen extends StatefulWidget {
  _CreateEventMapScreenState createState() => _CreateEventMapScreenState();

}

class _CreateEventMapScreenState extends State<CreateEventMapScreen> {
  LatLng? _selectedLatLng;
  final LatLng _center = const LatLng(36.9907207008804, -122.05845686120782);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.orange),
          centerTitle: true,
          title: Text('Chose Event Location'),
          backgroundColor: Colors.white
      ),

      body: GoogleMap(
        onTap: _onMapTap,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15,
        ),
        markers: _selectedLatLng != null
            ? {Marker(markerId: MarkerId("1"), position: _selectedLatLng!)}
            : {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the previous screen
          Navigator.pop(context, _selectedLatLng);
        },
        child: Icon(Icons.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  void _onMapTap(LatLng tappedLatLng) {
    setState(() {
      _selectedLatLng = tappedLatLng;
    });

  }

}