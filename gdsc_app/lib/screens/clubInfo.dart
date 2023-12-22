import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/club.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:gdsc_app/classes/user.dart';
import 'package:gdsc_app/screens/createEvent.dart';

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
  bool isEditing = false;
  late TabController tabController;
  late TextEditingController clubNameController;
  late TextEditingController clubTypeController;
  late TextEditingController clubDescController;
  User user = User();
  Color _colorTab = Color(0xFFFF8050);

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    isUserSignedIn();
    clubNameController = TextEditingController(text: club.name);
    clubTypeController = TextEditingController(text: club.type);
    clubDescController = TextEditingController(text: club.description);// Initialize the controller
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
                          Text(
                            '${club.name}',
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
                              _showEditSheet(context);
                            },
                            child: Row(
                              children: [
                                // Edit icon
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isEditing = true;
                                    });
                                    _showEditSheet(context);
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
                                // Create Event button
                                GestureDetector(
                                  onTap: () {
                                    // Add your logic for creating an event here
                                    // For example, navigate to the create event screen
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
              // Add your TabBar here
              buildTabBar(),
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
                  isEditing = false; // Reset isEditing state
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
                                onTap: () {
                                  // Add your logic for editing the profile picture here
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
                            // Add more text fields as needed
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
                    // Implement the logic for saving edits
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
}