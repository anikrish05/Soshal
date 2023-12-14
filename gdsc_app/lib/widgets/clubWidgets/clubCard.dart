import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:gdsc_app/screens/clubInfo.dart';

class ClubCardWidget extends StatelessWidget {
  Color _cardColor = Color(0xffc8c9ca);
  double _rating = 1.0;
  final ClubCardData club;

  ClubCardWidget({required this.club});

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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClubProfilePage(this.club),
              ),
            );
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
                                  Row(
                                    children: List.generate(5, (index) {
                                      return Icon(
                                        index < _rating ? Icons.star : Icons.star_border,
                                        color: Colors.yellow,
                                        size: 12,
                                      );
                                    }),
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
