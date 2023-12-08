import 'dart:async';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/slidingUpWidget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  final List<Marker> _markers = <Marker>[];

  final LatLng _center = const LatLng(36.9907207008804, -122.05845686120782);


  //bool isSlidingPanelVisible = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData (){
    _markers.add(
      Marker(
        markerId: MarkerId('UCSC'),
        position: LatLng(36.9907207008804, -122.05845686120782),
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
              SlidingUpPanel(
                panel: Center(child: Text("This is the sliding Widget"),),
              ),
              LatLng(36.9907207008804, -122.05845686120782)
          );
        }
      //infoWindow: InfoWindow(title: 'UCSC'),
    )
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

  /*
  void handleTap(LatLng latLng) {
    print("in handle tap");
    Marker tappedMarker = _markers.firstWhere(
          (marker) => marker.position == latLng,
      //orElse: () => Marker(markerId: MarkerId('dummy')),
    );
    print(tappedMarker);
    if (tappedMarker.markerId != MarkerId('dummy')) {
      print("in marker pressed");
      showMarkerInfo(context, tappedMarker);
      setState(() {
        isSlidingPanelVisible = true;
      });
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _customInfoWindowController.googleMapController = controller;
              },
              markers: Set<Marker>.of(_markers),
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 16.0,
              ),
              onTap: (position) {
                _customInfoWindowController.hideInfoWindow!();
              },
              onCameraMove: (position){
                _customInfoWindowController.onCameraMove!();
              }
            ),
            CustomInfoWindow(
              controller: _customInfoWindowController,
            ),
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
