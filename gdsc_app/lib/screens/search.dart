import 'package:flutter/material.dart';
import 'package:gdsc_app/screens/profile.dart';
import 'package:gdsc_app/widgets/clubWidgets/clubCard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:gdsc_app/classes/EventCardData.dart';
import 'package:gdsc_app/widgets/loader.dart';
import 'package:gdsc_app/widgets/clubWidgets/clubCard.dart';

import '../classes/userData.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  final searchController = TextEditingController();

  Color _color2 = Color(0xFFF0F0F0);

  Color _colorTab = Color(0xFFFF8050);
  late TabController tabController;
  late UserData user;
  List<ClubCardData> filteredItemsClubs = [];
  List<EventCardData> filteredItemsEvents = [];

  bool isSearchingClubs = false;
  List<ClubCardData> clubs = [];
  List<EventCardData> events = [];

  bool isDataLoaded = false; // Added to track whether data is loaded

  Future<void> getUser() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/users/signedIn'));
    if ((jsonDecode(response.body))['message'] == false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        ),
      );
    } else {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/users/userData'));
      var data = jsonDecode(response.body)['message'];
      UserData tempUser = UserData(
        uid: data['uid'],
        displayName: data['displayName'],
        email: data['email'],
        following: List<String>.from((data['following'] ?? []).map((follow) => follow.toString())),
        role: data['role'],
        myEvents: List<String>.from((data['myEvents'] ?? []).map((event) => event.toString())),
        clubIds: List<String>.from((data['clubIds'] ?? []).map((clubID) => clubID.toString())),
        downloadURL: data['downloadURL'],
      );
      user = tempUser;
    }
  }

  Future<void> fetchClubs() async {
    print("IN FETCH CLUBS");
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/clubs/getDataForSearchPage'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)["message"];
      for (int i = 0; i < data['clubs'].length; i++) {
        clubs.add(
          ClubCardData(
              admin: List<String>.from((data['clubs'][i]['admin'] ?? []).map((admin) => admin.toString())),
              category: data['clubs'][i]['category'],
              description: data['clubs'][i]['description'],
              downloadURL: data['clubs'][i]['downloadURL'],
              events: List<String>.from((data['clubs'][i]['events'] ?? []).map((event) => event.toString())),
              followers: List<String>.from((data['clubs'][i]['followers'] ?? []).map((follower) => follower.toString())),
              name: data['clubs'][i]['name'],
              verified: data['clubs'][i]['verified'],
              type: data['clubs'][i]['type'],
              id: data['clubs'][i]['id']),
        );
      }
      for (int i = 0; i < data['events'].length; i++) {
        events.add(
          EventCardData(
              rsvpList: List<String>.from((data['events'][i]['rsvpList'] ?? []).map((rsvp) => rsvp.toString())),
              name: data['events'][i]['name'],
              description: data['events'][i]['description'],
              downloadURL: data['events'][i]['downloadURL'],
              latitude: data['events'][i]['latitude'],
              longitude: data['events'][i]['longitude'],
              rating: data['events'][i]['rating'].toDouble(),
              comments: List<String>.from((data['events'][i]['comments'] ?? []).map((comment) => comment.toString())),
              id: data['events'][i]['id']),
        );
      }

      // Set the flag to indicate that data is loaded
      isDataLoaded = true;
    } else {
      throw Exception('Failed to load clubs');
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    // Call the method to fetch user data and clubs
    fetchData();
  }

  Future<void> fetchData() async {
    // Fetch user data first
    await getUser();

    // Fetch clubs only if user data is successfully fetched
    if (user != null) {
      await fetchClubs();
    }
  }

  void performSearch(String query) {
    setState(() {
      filteredItemsClubs = clubs
          .where((club) => club.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      filteredItemsEvents = events
          .where((event) => event.name.toLowerCase().contains(query.toLowerCase()))
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: fetchData(), // Wait for both getUser and fetchClubs
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoaderWidget(); // Show loader while data is being fetched
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!isDataLoaded) {
            return Center(
              child: Text('Data not loaded'), // Handle case where data failed to load
            );
          } else {
            // Render the UI once both getUser and fetchClubs are complete
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
    indicator: BoxDecoration(borderRadius: BorderRadius.circular(50), color: _colorTab),
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
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: filteredItemsClubs.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ClubCardWidget(club: filteredItemsClubs[index], isOwner: user.clubIds.contains(filteredItemsClubs[index].id));
              },
            ),
          ),
          /*
        Expanded(
          child: ListView.builder(
            itemCount: filteredItemsEvents.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return EventCardWidget(event: filteredItemsEvents[index]);
            },
          ),
        ),
        */
        ],
      ),
    );
  }
}
