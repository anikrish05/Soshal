import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gdsc_app/screens/login.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:gdsc_app/widgets/slidingUpWidget.dart';
import 'package:gdsc_app/widgets/loader.dart';
import 'package:gdsc_app/classes/user.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:gdsc_app/classes/MarkerData.dart';
import 'dart:convert';
import 'package:http/http.dart';
import '../utils.dart';
import '../widgets/loader.dart';
import '../app_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final serverUrl = AppConfig.serverUrl;

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
  bool isDataInitialized = false;
  late BitmapDescriptor myIcon;
  Map<MarkerId, dynamic> _markerEventMap = {};


  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(10000000, 10000000)), 'assets/feedIcon.png')
        .then((onValue) {
      myIcon = onValue;
    });
    initializeData(); // Call a new method to handle the sequential flow
  }

  Future<void> initializeData() async {
    await loadData();
    setState(() {
      isDataInitialized = true;
    });// Wait for loadData to complete
  }

  // Added method to load data on demand
  Future<List<dynamic>> getEventData() async {
    try {
      var response =
      await get(Uri.parse('$serverUrl/api/events/getFeedPosts/${user.uid}'),
        headers: await getHeaders()
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      }
      else {
        print("Anirudh return status code = " + response.statusCode.toString() );
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  Future<void> loadData() async {
    try {
        await user.initUserData();
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
              icon: myIcon
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
    Map<String, dynamic> event = Map.from(_markerEventMap[markerId]);
    if (event != null) {
      print("Marker Tapped: ${event['eventID'].toString()}");
      selectedMarkerData = getMarkerData(event);
      panelController.isPanelOpen
          ? panelController.close()
          : panelController.animatePanelToSnapPoint();
      setState(() {});
    }
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await _controller.future;
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataInitialized) {
      return Scaffold(
        body: Center(
          child: LoaderWidget(), // or any loading indicator
        ),
      );
    }

    double panelMinHeight = selectedMarkerData != null ? 240 : 0; // 25% of 450

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Expanded(
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: Set.of(_markers),
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 16.0,
                ),
              ),
            ),
            SlidingUpPanel(
              controller: panelController,
              minHeight: 0,
              maxHeight: MediaQuery.of(context).size.height*(2/3),
              snapPoint: .37,
            borderRadius:  BorderRadius.only(
    topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
    ),
              panel: selectedMarkerData != null
                  ? SlidingUpWidget(
                markerData: selectedMarkerData!,
                currUser: user,
                onClose: () {
                  panelController.close();
                },

                resetStateCallback: () {
                  setState(() {
                    // Reset the state variables in MyApp
                    selectedMarkerData = null;
                  });
                },
              )
                  : Container(),
            ),

          ],
        ),
      ),
    );
  }


  MarkerData getMarkerData(dynamic event) {

    // Create a copy of the event data to avoid potential modifications
    Map<String, dynamic> eventDataCopy = Map.from(event);
    List<ClubCardData> clubs = [];
    eventDataCopy['clubInfo'].forEach((club) {
      clubs.add(
        ClubCardData(
          admin: List<String>.from((club['admin'] ?? [])
              .map((admin) => admin.toString())),
          rating: club['avgRating'].toDouble(),
          description: club['description'],
          downloadURL: club['downloadURL'],
          events: List<String>.from((club['events'] ?? [])
              .map((event) => event.toString())),
          tags: List<String>.from((club['tags'] ?? [])
              .map((tag) => tag.toString())),
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
      image: eventDataCopy['downloadURL'] ==
          ""
          ? 'https://cdn.shopify.com/s/files/1/0982/0722/files/6-1-2016_5-49-53_PM_1024x1024.jpg?7174960393118038727'
          : eventDataCopy['downloadURL'],
    );
  }

}
