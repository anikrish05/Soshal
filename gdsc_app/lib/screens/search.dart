import 'package:flutter/material.dart';
import 'package:gdsc_app/screens/login.dart';
import 'package:gdsc_app/screens/profile.dart';
import 'package:gdsc_app/widgets/clubWidgets/clubCard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:gdsc_app/classes/EventCardData.dart';
import 'package:gdsc_app/widgets/loader.dart';
import 'package:gdsc_app/widgets/clubWidgets/clubCard.dart';
import 'package:gdsc_app/widgets/eventWidgets/eventCard.dart';

import '../classes/userData.dart';
import '../app_config.dart';
import '../utils.dart';

final serverUrl = AppConfig.serverUrl;

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final searchController = TextEditingController();

  Color _color2 = Color(0xFFF0F0F0);

  Color _colorTab = Color(0xFFFF8050);
  late TabController tabController;

  List<ClubCardData> filteredItemsClubs = [];
  List<EventCardData> filteredItemsEvents = [];
  UserData? user;

  bool isSearchingClubs = false;
  List<ClubCardData> clubs = [];
  List<EventCardData> events = [];
  Future<void> getUser() async {
    final response = await http.get(Uri.parse('$serverUrl/api/users/signedIn'),
        headers: await getHeaders(),
    );
    if ((jsonDecode(response.body))['message'] == false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } else {
      final response = await http.get(Uri.parse('$serverUrl/api/users/userData'),
        headers: await getHeaders(),
      );
      var data = jsonDecode(response.body)['message'];
      print(data);
      UserData tempUser = UserData(
        classOf: data['classOf'],
        uid: data['uid'],
        displayName: data['displayName'],
        email: data['email'],
        following: data['following'],
        role: data['role'],
        myEvents: List<String>.from((data['myEvents'] ?? []).map((event) => event.toString())),
        clubIds: List<String>.from((data['clubsOwned'] ?? []).map((clubID) => clubID.toString())),
        downloadURL: data['downloadURL'],
        likedEvents: List<String>.from((data['likedEvents'] ?? []).map((event) => event.toString())),
        dislikedEvents: List<String>.from((data['dislikedEvents'] ?? []).map((event) => event.toString())),

      );
      user = tempUser;
    }
  }
  Future<void> fetchData() async {
    // Fetch user data first
    await getUser();

    // Fetch clubs only if user data is successfully fetched
    if (user != null) {
      await fetchClubs();
    }
  }
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  void performSearch(String query) {
    setState(() {
      filteredItemsClubs = clubs
          .where((club) =>
          club.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      filteredItemsEvents = events
          .where((event) =>
          event.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      // Keep only the first occurrence of each club based on id
      final Set<String> clubIds = Set();
      filteredItemsClubs.removeWhere((club) {
        if (!clubIds.contains(club.id)) {
          clubIds.add(club.id);
          return false;
        } else {
          return true;
        }
      });

      // Keep only the first occurrence of each event based on id
      final Set<String> eventIds = Set();
      filteredItemsEvents.removeWhere((event) {
        if (!eventIds.contains(event.id)) {
          eventIds.add(event.id);
          return false;
        } else {
          return true;
        }
      });
    });
  }

  Future<bool> fetchClubs() async {
    print("IN FETCH CLUBS");
    final response = await http.get(Uri.parse(
        '$serverUrl/api/clubs/getDataForSearchPage'),
      headers: await getHeaders()
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
      json.decode(response.body)["message"];
      print(data['clubs']);
      print(data['events']);
      for (int i = 0; i < data['clubs'].length; i++) {
        clubs.add(
          ClubCardData(
              admin: List<String>.from((data['clubs'][i]['admin'] ?? [])
                  .map((admin) => admin.toString())),
              category: data['clubs'][i]['category'],
              rating: data['clubs'][i]['avgRating'].toDouble(),
              description: data['clubs'][i]['description'],
              downloadURL: data['clubs'][i]['downloadURL'],
              events: List<String>.from((data['clubs'][i]['events'] ?? [])
                  .map((event) => event.toString())),
              followers: data['clubs'][i]['followers'],
              name: data['clubs'][i]['name'],
              type: data['clubs'][i]['type'],
              verified: data['clubs'][i]['verified'],
              id: data['clubs'][i]['id']),
        );
      }
      for (int i = 0; i < data['events'].length; i++) {
        events.add(
          EventCardData(
              admin: List<String>.from((data['events'][i]['admin'] ?? []).map((admin) => admin.toString())),
              rsvpList: List<String>.from((data['events'][i]['rsvpList'] ?? [])
                  .map((rsvp) => rsvp.toString())),
              name: data['events'][i]['name'],
              description: data['events'][i]['description'],
              downloadURL: data['events'][i]['downloadURL'],
              latitude: data['events'][i]['latitude'],
              longitude: data['events'][i]['longitude'],
              comments: List<String>.from((data['events'][i]['comments'] ?? [])
                  .map((comment) => comment.toString())),
              id: data['events'][i]['id'],
              time: data['events'][i]['timestamp'],
              likedBy: List<String>.from((data['events'][i]['likedBy'] ?? []).map((likedBy) => likedBy.toString())),
              disLikedBy: List<String>.from((data['events'][i]['disLikedBy'] ?? []).map((disLikedBy) => disLikedBy.toString())),
          ),
        );
      }
    } else {
      throw Exception('Failed to load clubs');
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return (LoaderWidget());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                buildText(),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                buildTabBar(),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                buildSearchResultList(),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildText() => SizedBox(
    width: 350,
    child: TextField(
      onSubmitted: (value) {
        performSearch(searchController.text);
      },
      textInputAction: TextInputAction.search,
      controller: searchController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(50.0),
        ),
        hintText: "Search",
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: _color2,
      ),
    ),
  );

  Widget buildTabBar() => TabBar(
    unselectedLabelColor: _colorTab,
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(50), color: _colorTab),
    controller: tabController,
    tabs: [
      Tab(
        text: 'Discover',
      ),
      Tab(
        text: 'Following',
      ),
      Tab(
        text: 'Near Me',
      ),
    ],
  );

  Widget buildSearchResultList() {
    List<Widget> clubWidgets = filteredItemsClubs.map((club) =>
        ClubCardWidget(
          club: club,
          isOwner: user!.clubIds.contains(club.id),
          currUser: user!,
        )).toList();

    List<Widget> eventWidgets = filteredItemsEvents.map((event) =>
        EventCardWidget(event: event, isOwner: false)).toList();

    ScrollController _scrollController = ScrollController();

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 8.0, left: 0, top: 8.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: MediaQuery.of(context).size.width * 0.002,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
              ),
              child: Text(
                'Organizations',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey.withOpacity(0.8)),
              ),
            ),
            SizedBox(height: 16.0),
            // Conditionally display club widgets or 'No organizations found' text
            if (clubWidgets != null && clubWidgets.isNotEmpty)
              SizedBox(height: 100, child: ListView(children: clubWidgets))
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'No organizations found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 8.0, left: 0, top: 8.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: MediaQuery.of(context).size.width * 0.002,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
              ),
              child: Text(
                'Events',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey.withOpacity(0.8)),
              ),
            ),
            SizedBox(height: 15.0),
            // Display event cards or 'No results found' text based on eventWidgets list
            if (eventWidgets != null && eventWidgets.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3, // Adjust the height accordingly
                  child: ListView.builder(
                    itemCount: eventWidgets.length,
                    itemBuilder: (context, index) {
                      return eventWidgets[index]; // Your event widget item here
                    },
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'No results found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );

  }

}
