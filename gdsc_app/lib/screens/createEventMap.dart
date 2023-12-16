import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:gdsc_app/widgets/slidingUpWidget.dart';
import 'package:gdsc_app/classes/MarkerData.dart';

class CreateEventMapScreen extends StatefulWidget {
  _CreateEventMapScreenState createState() => _CreateEventMapScreenState();

}

class _CreateEventMapScreenState extends State<CreateEventMapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  PanelController panelController = PanelController();
  final List<Marker> _markers = <Marker>[];
  Color _orangeColor = Color(0xFFFF8050);

  final LatLng _center = const LatLng(36.9907207008804, -122.05845686120782);
  MarkerData? selectedMarkerData;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    _markers.add(
      Marker(
        markerId: MarkerId('UCSC'),
        position: LatLng(36.9907207008804, -122.05845686120782),
        onTap: () {
          // Get data for the clicked marker
          selectedMarkerData = getMarkerData('UCSC');

          // Show/hide the sliding panel when marker is tapped
          panelController.isPanelOpen
              ? panelController.close()
              : panelController.open();

          // Rebuild the widget to reflect the new selected marker data
          setState(() {});
        },
      ),
    );
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
        appBar: AppBar(leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
            color: _orangeColor),
            centerTitle: true,
            title: Text("Create an Event",
              style: TextStyle(
                color: Color(0xFF88898C),
              ),),
            backgroundColor: Colors.white
        ),
        body: SlidingUpPanel(
          controller: panelController,
          minHeight: 0,
          maxHeight: 300.0, // Adjust as needed
          panel: selectedMarkerData != null
              ? SlidingUpWidget(markerData: selectedMarkerData!)
              : Container(), // You can replace Container() with an empty widget or any default content
          body: GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: Set<Marker>.of(_markers),
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  // Function to get data for a specific marker
  MarkerData getMarkerData(String markerId) {
    // Replace this with your actual data retrieval logic
    return MarkerData(
      title: 'Event Location',
      description: 'Your marker description goes here.',
      // Add more data fields as needed
    );
  }

}