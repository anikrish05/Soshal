import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/EventCardData.dart';
import 'package:gdsc_app/classes/club.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:gdsc_app/classes/user.dart';
import 'package:gdsc_app/screens/createEvent.dart';
import 'package:http/http.dart' as http;
import 'package:gdsc_app/screens/editClub.dart';
import 'package:intl/intl.dart';
import '../../utils.dart';
import '../../widgets/eventWidgets/eventCard.dart';
import '../../widgets/loader.dart';
import '../../widgets/notificationWidgets/clubNotifcations/userFollowedYouWidget.dart';
import '../../widgets/notificationWidgets/clubNotifcations/userRequestFollowWidget.dart';
import '/../app_config.dart';


final serverUrl = AppConfig.serverUrl;

class ClubProfilePage extends StatefulWidget {
  late ClubCardData club;

  ClubProfilePage(ClubCardData club) {
    this.club = club;
  }

  @override
  _ClubProfilePageState createState() => _ClubProfilePageState(this.club);
}

class _ClubProfilePageState extends State<ClubProfilePage>
    with SingleTickerProviderStateMixin {
  late ClubCardData club;
  final format = DateFormat("yyyy-MM-dd HH:mm");


  bool isEditing = false;
  late TabController tabController;
  late TextEditingController clubNameController;
  late TextEditingController clubTypeController;
  late TextEditingController clubDescController;
  User user = User();
  Color _colorTab = Color(0xFFFF8050);
  List<EventCardData> upcommingEvents = [];
  List<EventCardData> finishedEvents = [];
  bool isFollowerDataLoaded = false;

  Future<void> getTabContent() async {
    await club.getALlEventsForClub();
    final now = DateTime.now();

    // Filter events based on the date
    upcommingEvents = club.eventData
        .where((event) => format.parse(event.time).isAfter(now))
        .toList();
    finishedEvents = club.eventData
        .where((event) => format.parse(event.time).isBefore(now))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    isUserSignedIn();
    getFollowerData();

    clubNameController = TextEditingController(text: club.name);
    clubTypeController = TextEditingController(text: club.type);
    clubDescController = TextEditingController(text: club.description);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  dynamic isUserSignedIn() async {
    user.isUserSignedIn().then((check) async {
      if (!check) {
        Navigator.pushNamed(context, '/login');
      }
    });
  }

  Future<void> getFollowerData() async {
    if (!isFollowerDataLoaded) {
      try {
        await widget.club.getFollowerData();
        setState(() {
          isFollowerDataLoaded = true;
        });
      } catch (error) {
        print("Error fetching follower data: $error");
      }
    }
  }


  _ClubProfilePageState(ClubCardData club) {
    this.club = club;
  }

  Color _orangeColor = Color(0xFFFF8050);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: _orangeColor,
        ),
        actions: [
          IconButton(
            icon: Stack(
              alignment: Alignment.topRight,
              children: [
                Icon(Icons.notifications),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red, // You can customize the color
                    ),
                    child: Text(
                      "3", // Replace this with the actual count of notifications
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              // Show the notification modal
              _showNotificationModal(context);
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          ListView(
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
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  club.name,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (club.verified)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Icon(Icons.verified, color: _orangeColor, size: 20.0),
                                ),
                            ],
                          ),
                          SizedBox(height: 3),
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
                                ' ${club.type}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${club.description}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isEditing = true;
                              });
                              onUpdateClub();
                            },
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isEditing = true;
                                    });
                                    onUpdateClub();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _orangeColor,
                                    ),
                                    child: Icon(Icons.edit, color: Colors.white),
                                  ),
                                ),
                                SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CreateEventScreen(club: club),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _orangeColor,
                                    ),
                                    child: Icon(Icons.add, color: Colors.white),
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
              SizedBox(height: 16),
              Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 24,
                endIndent: 24,
              ),
              SizedBox(height: 16),
              buildTabBar(),
              SizedBox(height: 16),
              buildTabContent(),
            ],
          ),
          if (isEditing)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isEditing = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isEditing = false;
                });
              },
              color: _orangeColor,
            ),
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            profilePicture(),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _orangeColor,
                                  ),
                                  child: Icon(Icons.edit, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Column(
                          children: [
                            TextField(
                              controller: clubNameController,
                              decoration: InputDecoration(labelText: 'Club Name'),
                              maxLines: null,
                            ),
                            TextField(
                              controller: clubTypeController,
                              decoration: InputDecoration(labelText: 'Club Type'),
                              maxLines: null,
                            ),
                            TextField(
                              controller: clubDescController,
                              decoration: InputDecoration(labelText: 'Club Description'),
                              maxLines: null,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditing = false;
                      club.name = clubNameController.text;
                      club.type = clubTypeController.text;
                      club.description = clubDescController.text;
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: _orangeColor,
                    textStyle: TextStyle(
                      fontFamily: 'Borel',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('save'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget profilePicture() {
    if (club.downloadURL != "") {
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(club.downloadURL),
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


  Widget buildTabContent() {
    return FutureBuilder<void>(
      future: getTabContent(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoaderWidget(); // or any loading indicator
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          List<EventCardData> eventsToDisplay = [];

          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: TabBarView(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: upcommingEvents.length,
                    itemBuilder: (context, index) {
                      return EventCardWidget(
                        event: upcommingEvents[index],
                        isOwner: true,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: finishedEvents.length,
                    itemBuilder: (context, index) {
                      return EventCardWidget(
                        event: finishedEvents[index],
                        isOwner: true,
                      );
                    },
                  ),
                ),
              ],
              controller: tabController,
            ),
          );
        }
      },
    );
  }
  void _showNotificationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: _colorTab,
                title: Text('Notifications'),
                bottom: TabBar(
                  labelStyle: TextStyle(fontFamily: 'Borel'), // Add this line
                  tabs: [
                    Tab(text: 'Requested'),
                    Tab(text: 'Accepted'),
                  ],
                ),
              ),
              body: FutureBuilder<void>(
                future: getFollowerData(), // Assuming getFollowerData returns a Future<void>
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Display a loading indicator while waiting for the data
                    return LoaderWidget();
                  } else if (snapshot.hasError) {
                    // Display an error message if there is an error
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    // Check if the data is available
                    if (widget.club.followerActionRequired == null ||
                        widget.club.followerData == null) {
                      // If data is not available, display a loading indicator
                      return LoaderWidget();
                    } else {
                      // If data is available, display the TabBarView with the content
                      return TabBarView(
                        children: [
                          // Content for the 'Requested' tab
                          widget.club.type == "Public"
                              ? Center(
                            child: Text('You need to be a private club to get requests.'),
                          )
                              : ListView.builder(
                            itemCount: widget.club.followerActionRequired.length,
                            itemBuilder: (context, index) {
                              return UserRequest(
                                user: widget.club.followerActionRequired[index][0],
                                timestamp: widget.club.followerActionRequired[index][1],
                                onAccept: (uid) {
                                  // Handle accept action with additionalData
                                  widget.club.acceptUser(uid);
                                },
                                onDeny: (uid) {
                                  // Handle deny action with additionalData
                                  widget.club.denyUser(uid);
                                },
                              );
                            },
                          ),
                          // Content for the 'Accepted' tab
                          ListView.builder(
                            itemCount: widget.club.followerData.length,
                            itemBuilder: (context, index) {
                              return UserFollowing(
                                user: widget.club.followerData[index][0],
                                timestamp: widget.club.followerData[index][1],
                              );
                            },
                          ),
                        ],
                      );
                    }
                  }
                },
              )

          ),
        );
      },
    );
  }

  void onUpdateClub() async
  {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateClubScreen(club: club!)),
    );

    final updateClubData = {
      "name": result[0],
      "description": result[1],
      "type": result[2],
      "id": result[4]
    };
      setState(() {
        club.name = result[0];
        club.description = result[1];
        club.type = result[2];
      });

      print(club.name);
    print("got back");
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/api/clubs/updateClub'),
        headers: await getHeaders(),
        body: jsonEncode(updateClubData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData['message']); // Assuming the server responds with a JSON object containing a 'message' property
      } else {
        print('Error: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('Error: $error');
    }
  }


}