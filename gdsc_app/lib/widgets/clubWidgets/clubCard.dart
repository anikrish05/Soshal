import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gdsc_app/classes/userData.dart';
import 'package:gdsc_app/screens/clubInfo.dart';

import '../../screens/otherclubinfo.dart';

class ClubCardWidget extends StatelessWidget {
  Color _cardColor = Color(0xffc8c9ca);
  final ClubCardData club;
  final bool isOwner;

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
                                  SizedBox(width: 14),
                                  RatingBar.builder(
                                    initialRating: 3,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
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
