import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/slidingUpWidget.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();

  final LatLng _center = const LatLng(36.9907207008804, -122.05845686120782);

  Set<Marker> markers = {
    Marker(
      markerId: MarkerId('UCSC'),
      position: LatLng(36.9907207008804, -122.05845686120782),
      infoWindow: InfoWindow(title: 'UCSC'),
    ),
  };

  bool isSlidingPanelVisible = false;

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

  void handleTap(LatLng latLng) {
    Marker tappedMarker = markers.firstWhere(
          (marker) => marker.position == latLng,
      orElse: () => Marker(markerId: MarkerId('dummy')),
    );

    if (tappedMarker.markerId != MarkerId('dummy')) {
      showMarkerInfo(context, tappedMarker);
      setState(() {
        isSlidingPanelVisible = true;
      });
    }
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
              markers: markers,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 16.0,
              ),
              onTap: (LatLng latLng) {
                handleTap(latLng);
              },
            ),
            SlidingUpWidget(isSlidingPanelVisible: isSlidingPanelVisible), // Conditionally add SlidingUpWidget
          ],
        ),
      ),
    );
  }

  void showMarkerInfo(BuildContext context, Marker marker) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(marker.infoWindow.title ?? 'No Title'),
          content: Text('You tapped on the marker!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
