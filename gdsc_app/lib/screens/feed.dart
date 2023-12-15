import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:gdsc_app/widgets/slidingUpWidget.dart';
import 'package:gdsc_app/classes/MarkerData.dart';
import 'dart:convert';
import 'package:http/http.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();
  PanelController panelController = PanelController();
  final List<Marker> _markers = <Marker>[];

  final LatLng _center = const LatLng(36.9907207008804, -122.05845686120782);
  MarkerData? selectedMarkerData; // Track selected marker data

  @override
  void initState() {
    super.initState();
    // Load data only once in initState
    loadData();
  }

  Future<List<dynamic>> getEventData() async {
    try {
      var response =
      await get(Uri.parse('http://10.0.2.2:3000/api/events/getFeedPosts'));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the data
        return jsonDecode(response.body)['message'];
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle errors during the HTTP request
      print('Error fetching data: $e');
      throw e; // Re-throw the error to notify the calling code
    }
  }

  Future<void> loadData() async {
    try {
      List<dynamic> eventData = await getEventData();
      _markers.clear(); // Clear existing markers before adding new ones
      eventData.forEach((event) {
        _markers.add(
          Marker(
            markerId: MarkerId(event['id'].toString()),
            position: LatLng(event['latitude'], event['longitude']),
            onTap: () {
              // Get data for the clicked marker
              selectedMarkerData = getMarkerData(event);

              // Show/hide the sliding panel when marker is tapped
              panelController.isPanelOpen
                  ? panelController.close()
                  : panelController.open();

              // Rebuild the widget to reflect the new selected marker data
              setState(() {});
            },
          ),
        );
      });
    } catch (e) {
      // Handle errors if any
      print('Error loading data: $e');
    }
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
          children: [
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: Set<Marker>.of(_markers),
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 16.0,
              ),
            ),
            SlidingUpPanel(
              controller: panelController,
              minHeight: 0,
              maxHeight: 450, // Adjust as needed
              panel: selectedMarkerData != null
                  ? SlidingUpWidget(
                markerData: selectedMarkerData!,
                onClose: () {
                  // Handle closing logic when map is tapped
                  panelController.close();
                },
              )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  // Function to get data for a specific marker
  MarkerData getMarkerData(dynamic event) {
    print(event);
    return MarkerData(
      title: "House Party",
      description: "Kamble is gonna be there.",
      location: "69 Pineapple St",
      time: "Feb 31, 7:99 AM",
      image:
      'https://cdn.shopify.com/s/files/1/0982/0722/files/6-1-2016_5-49-53_PM_1024x1024.jpg?7174960393118038727',
      // Add more data fields as needed
    );
  }
}