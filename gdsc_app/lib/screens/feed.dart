import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:gdsc_app/widgets/slidingUpWidget.dart';
import 'package:gdsc_app/widgets/loader.dart';
import 'package:gdsc_app/classes/user.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:gdsc_app/classes/MarkerData.dart';
import 'dart:convert';
import 'package:http/http.dart';
import '../widgets/loader.dart';

// Define the color as a global variable
Color _orangeColor = Color(0xFFFF8050);

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();
  PanelController panelController = PanelController();
  List<Marker> _markers = [];
  MarkerData? selectedMarkerData; // Track selected marker data
  User user = User();
  List<dynamic> eventData = [];
  final LatLng _center = const LatLng(36.9907207008804, -122.05845686120782);

  Map<MarkerId, dynamic> _markerEventMap = {};

  dynamic isUserSignedIn() async {
    user.isUserSignedIn().then((check) async {
      if (!check) {
        Navigator.pushNamed(context, '/login');
      }
    });
  }

  Future<bool> getData() async {
    return user.initUserData();
  }

  @override
  void initState() {
    super.initState();
    initializeData(); // Call a new method to handle the sequential flow
  }

  Future<void> initializeData() async {
    await isUserSignedIn(); // Wait for isUserSignedIn to complete
    await getData(); // Wait for getData to complete
    await loadData(); // Wait for loadData to complete
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
      eventData = await getEventData();
      _markers.clear(); // Clear existing markers
      _markerEventMap.clear(); // Clear existing event mapping

      eventData.asMap().forEach((index, event) {
        MarkerId markerId = MarkerId(index.toString());

        _markers.add(
          Marker(
            markerId: markerId,
            position: LatLng(event['latitude'], event['longitude']),
            onTap: () {
              handleMarkerTap(markerId);
            },
          ),
        );

        _markerEventMap[markerId] = event;
      });

      setState(() {}); // Trigger rebuild with updated markers
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  void handleMarkerTap(MarkerId markerId) {
    dynamic event = _markerEventMap[markerId];
    print("LSKJAKJQEJKFHEQ");
    print(event);
    if (event != null) {
      print("Marker Tapped: ${event['id']}");
      selectedMarkerData = getMarkerData(event);
      panelController.isPanelOpen
          ? panelController.close()
          : panelController.open();
      setState(() {});
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
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getEventData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoaderWidget(); // You need to define the Loader widget
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      markers: Set.of(_markers),
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 16.0,
                      ),
                    );
                  }
                },
              ),
            ),
            SlidingUpPanel(
              controller: panelController,
              minHeight: 0,
              maxHeight: 450,
              panel: selectedMarkerData != null
                  ? SlidingUpWidget(
                markerData: selectedMarkerData!,
                currUser: user,
                onClose: () {
                  panelController.close();
                },
              )
                  : Container(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: _orangeColor, // Use the global variable here
          onPressed: loadData, // Trigger data loading on button press
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }

  MarkerData getMarkerData(dynamic event) {
    print("HELLLOO");
    print(event);

    // Create a copy of the event data to avoid potential modifications
    Map<String, dynamic> eventDataCopy = Map.from(event);

    List<ClubCardData> clubs = [];
    eventDataCopy['clubInfo'].forEach((club) {
      clubs.add(
        ClubCardData(
          admin: List<String>.from((club['admin'] ?? [])
              .map((admin) => admin.toString())),
          category: club['category'],
          rating: club['avgRating'].toDouble(),
          description: club['description'],
          downloadURL: club['downloadURL'],
          events: List<String>.from((club['events'] ?? [])
              .map((event) => event.toString())),
          followers: club['followers'],
          name: club['name'],
          type: club['type'],
          verified: club['verified'],
          id: club['id'],
        ),
      );
    });

    // Use the copied eventDataCopy instead of the original event for certain properties
    return MarkerData(
      user: user,
      clubs: clubs,
      isRSVP: user.myEvents.contains(eventDataCopy['eventID']),
      eventID: eventDataCopy['eventID'],
      title: eventDataCopy['name'],
      description: eventDataCopy['description'],
      longitude: eventDataCopy['longitude'],
      latitude: eventDataCopy['latitude'],
      time: eventDataCopy['timestamp'],
      comments: eventDataCopy['comments'],
      rating: eventDataCopy['rating'].toDouble(),
      image: eventDataCopy['downloadURL'] ==
          ""
          ? 'https://cdn.shopify.com/s/files/1/0982/0722/files/6-1-2016_5-49-53_PM_1024x1024.jpg?7174960393118038727'
          : eventDataCopy['downloadURL'],
    );
  }

}
