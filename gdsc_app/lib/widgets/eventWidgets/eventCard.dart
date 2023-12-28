import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gdsc_app/classes/EventCardData.dart';
import 'package:gdsc_app/classes/userData.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gdsc_app/screens/viewYourOwnScreen/eventInfo.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

import '../../screens/viewOtherScreens/othereventinfo.dart';

class EventCardWidget extends StatefulWidget {
  final EventCardData event;
  final bool isOwner;

  EventCardWidget({required this.event, required this.isOwner});
  @override
  State<EventCardWidget> createState() => _EventCardWidgetState();
}

class _EventCardWidgetState extends State<EventCardWidget> {
  Color _cardColor = Color(0xffc8c9ca);
  String locationText = "Loading...";
  double rating = 3.5;
  final format = DateFormat("yyyy-MM-dd HH:mm");

  String clubs = "...";

  Future<void> getStreetName() async{
    print("in get street name");
    List<Placemark> placemarks = await placemarkFromCoordinates(widget.event.latitude, widget.event.longitude);
    Placemark place = placemarks[0];
    String tempText = "${place.street}";
    setState(() {
      locationText = tempText;
    });
  }

  String getFormattedDateTime(String dateTimeString) {
    DateTime dateTime = format.parse(dateTimeString);
    String formattedDateTime =
    DateFormat.MMMd().add_jm().format(dateTime); // e.g., Feb 2, 7:30 PM
    return formattedDateTime;
  }

  @override
  void initState() {
    super.initState();
    getStreetName();
    displayClubNames();
    setState(() {
      locationText = "Loading...";
    });
  }

  Future<void> displayClubNames() async{
    String tempClubs = "";
    await widget.event.getAllClubsForEvent();
    for(var i =0;i<widget.event.clubInfo.length;i++){
      if(i!=widget.event.clubInfo.length-1){
        tempClubs+=widget.event.clubInfo[i].name + ", ";
      }
      else{
        tempClubs+=widget.event.clubInfo[i].name;
      }
    }
    setState(() {
      clubs = tempClubs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double imageWidth = MediaQuery.of(context).size.width * 0.25;
    final double imageHeight = MediaQuery.of(context).size.height * 0.15;

    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            print(widget.isOwner);
            if(widget.isOwner){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventProfilePage(event: widget.event),
                ),
              );
            }
            else{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtherEventProfilePage(event: widget.event),
                ),
              );
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.89, // Adjust the width here
            child: Card(
              color: _cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Set the border radius
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  InkWell(
                    splashColor: Colors.blueGrey.withAlpha(30),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0), // Add padding to the card
                      child: Row(
                        children: [
                          Container(
                            width: imageWidth,
                            height: imageHeight,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network('https://cdn.shopify.com/s/files/1/0982/0722/files/6-1-2016_5-49-53_PM_1024x1024.jpg?7174960393118038727', fit: BoxFit.cover), // Replace 'IMAGE_URL' with your image url
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${widget.event.name}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Replace 'Title Header' with your title
                                SizedBox(height: 8), // Add more spacing vertically
                                Text('By: $clubs'), // Replace 'Club Name' with your club name
                                SizedBox(height: 8), // Add more spacing vertically
                                RatingBarIndicator(
                                  rating: rating,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 15.0, // Adjust the size of the stars here
                                  direction: Axis.horizontal,
                                ),
                                SizedBox(height: 8), // Add more spacing vertically
                                Row(
                                  children: [
                                    Icon(Icons.location_on), // Add a location icon
                                    Text(locationText), // Replace 'Location' with your location
                                  ],
                                ),
                                SizedBox(height: 8), // Add more spacing vertically
                                Row(
                                  children: [
                                    Icon(Icons.access_time),
                                    Text(" "),// Add a clock icon
                                    Text(getFormattedDateTime(widget.event.time)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Handle your button tap here
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
