import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gdsc_app/widgets/appBar.dart';
import 'package:gdsc_app/widgets/bottomNavigation.dart';
import 'package:http/http.dart';

class MyApp extends StatefulWidget {
  //const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    //TODO: eventually needs to be changed to host ex: https://soshal.com/
    Response response =  await get(Uri.parse('http://10.0.2.2:3000/'));
    print(response.body);
  }
  void isUserSignedIn() async {
    final response = await get(Uri.parse('http://10.0.2.2:3000/signedIn'));
    print(jsonDecode(response.body));
    if ((jsonDecode(response.body))['message'] == false) {
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return MaterialApp(
      home: Scaffold(
        appBar: MyAppBar(),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
        bottomNavigationBar: NavBottomWidget(),
      ),
    );
  }
}