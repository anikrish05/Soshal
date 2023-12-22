import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gdsc_app/classes/userData.dart';
import 'package:gdsc_app/screens/viewYourOwnScreen/clubInfo.dart';

import '../../screens/viewOtherScreens/otherclubinfo.dart';

class ClubCardWidget extends StatelessWidget {
  Color _cardColor = Color(0xffc8c9ca);
  final ClubCardData club;
  final bool isOwner;
  double rating = 4.5; // Replace this with your dynamic rating variable


  ClubCardWidget({required this.club, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final double imageWidth = screenWidth * 0.2;
    final double imageHeight = screenWidth * 0.22;

    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {
            print(isOwner);
            if(isOwner){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClubProfilePage(this.club),
                ),
              );
            }
            else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtherClubProfilePage(this.club),
                ),
              );
            }
          },
          child: Container(
            height: screenWidth * 0.25,
            width: screenWidth * 0.50,
            child: Card(
              color: _cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blueGrey.withAlpha(30),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: imageWidth,
                        height: imageHeight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: imageBuild(),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(club.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            Flexible(
                              child: Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: club.rating, // Replace '3' with your dynamic rating variable from the 'club' object
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    itemSize: 8.0, // Adjust this value to change the size of the stars
                                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget imageBuild() {
    if (club.downloadURL != "") {
      return Image.network(club.downloadURL, fit: BoxFit.cover);
    } else {
      return Image.network('https://cdn.shopify.com/s/files/1/0982/0722/files/6-1-2016_5-49-53_PM_1024x1024.jpg?7174960393118038727', fit: BoxFit.cover);
    }
  }
}
