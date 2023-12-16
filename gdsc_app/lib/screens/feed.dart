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
List<Marker> _markers = [];
MarkerData? selectedMarkerData; // Track selected marker data

final LatLng _center = const LatLng(36.9907207008804, -122.05845686120782);

@override
void initState() {
  super.initState();
  loadData(); //might need to remove and just have reload capability
}

// Added method to load data on demand
  Future<List<dynamic>> getEventData() async {
    try {
      var response =
      await get(Uri.parse('http://10.0.2.2:3000/api/events/getFeedPosts'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

Future<void> loadData() async {
  try {
    List<dynamic> eventData = await getEventData();
    _markers.clear();
    eventData.forEach((event) {
      _markers.add(
        Marker(
          markerId: MarkerId(event['id'].toString()),
          position: LatLng(event['latitude'], event['longitude']),
          onTap: () {
            selectedMarkerData = getMarkerData(event);
            panelController.isPanelOpen
                ? panelController.close()
                : panelController.open();
            setState(() {});
          },
        ),
      );
    });
    setState(() {}); // Trigger rebuild with updated markers
  } catch (e) {
    print('Error loading data: $e');
  }
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
            markers: Set.of(_markers),
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 16.0,
            ),
          ),
          SlidingUpPanel(
            controller: panelController,
            minHeight: 0,
            maxHeight: 450,
            panel: selectedMarkerData != null
                ? SlidingUpWidget(
              markerData: selectedMarkerData!,
              onClose: () {
                panelController.close();
              },
            )
                : Container(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadData, // Trigger data loading on button press
        child: Icon(Icons.refresh),
      ),
    ),
  );
}

  MarkerData getMarkerData(dynamic event) {
    print(event);
    return MarkerData(
      title: event['name'],
      description: event['description'],
      location: "69 Pineapple St",
      time: "Feb 31, 7:99 AM",
      image: event['downloadURL'] ==
          ""
          ? 'https://cdn.shopify.com/s/files/1/0982/0722/files/6-1-2016_5-49-53_PM_1024x1024.jpg?7174960393118038727'
          : event['downloadURL'],
    );
  }
}
