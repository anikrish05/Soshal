import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/club.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:gdsc_app/classes/user.dart';

class OtherClubProfilePage extends StatefulWidget {
  final ClubCardData club;

  OtherClubProfilePage(this.club);

  @override
  _OtherClubProfilePageState createState() => _OtherClubProfilePageState();
}

class _OtherClubProfilePageState extends State<OtherClubProfilePage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  Color _colorTab = Color(0xFFFF8050);

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  Color _orangeColor = Color(0xFFFF8050);

  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: _orangeColor,
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 16),
                    profilePicture(),
                  ],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.club.name}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Row(
                            children: [
                              for (int i = 0; i < 5; i++)
                                Icon(
                                  Icons.star,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                            ],
                          ),
                          SizedBox(width: 7),
                          Text(
                            ' ${widget.club.type}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${widget.club.description}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 12),
                      // Follow Button
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Toggle the follow state
                            isFollowing = !isFollowing;
                          });

                          // Add your logic for follow/unfollow here
                          if (isFollowing) {
                            // Logic for follow
                            // You can implement the logic to follow the club here
                          } else {
                            // Logic for unfollow
                            // You can implement the logic to unfollow the club here
                          }
                        },
                        child: Text(isFollowing ? 'Unfollow' : 'Follow'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Divider(
            color: Colors.grey,
            thickness: 1,
            indent: 24,
            endIndent: 24,
          ),
          SizedBox(height: 16),
          // Add your TabBar here
          buildTabBar(),
        ],
      ),
    );
  }


  Widget profilePicture() {
    if (widget.club.downloadURL != "") {
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(widget.club.downloadURL),
      );
    } else {
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(
            'https://cdn.shopify.com/s/files/1/0982/0722/files/6-1-2016_5-49-53_PM_1024x1024.jpg?7174960393118038727'),
      );
    }
  }

  Widget buildTabBar() {
    return TabBar(
      unselectedLabelColor: _colorTab,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: _colorTab,
      ),
      controller: tabController,
      tabs: [
        Tab(
          child: Text(
            'Upcoming',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Tab(
          child: Text(
            'Previous',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
      indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
    );
  }
}