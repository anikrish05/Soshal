import 'dart:async';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gdsc_app/widgets/slidingUpWidget.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();
  PanelController panelController = PanelController();
  final List<Marker> _markers = <Marker>[];

  final LatLng _center = const LatLng(36.9907207008804, -122.05845686120782);

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
          // Show/hide the sliding panel when marker is tapped
          panelController.isPanelOpen
              ? panelController.close()
              : panelController.open();
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
        body: SlidingUpPanel(
          controller: panelController,
          minHeight: 0,
          maxHeight: 300.0, // Adjust as needed
          panel: SlidingUpWidget(),
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
}

