import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
import 'package:multi_select_flutter/multi_select_flutter.dart';

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

  Set<ClubCardData> filteredItemsClubs = {};
  Set<EventCardData> filteredItemsEvents = {};
  Set<ClubCardData> filteredFollowers = {};
  Set<String> selectedTags = {};
  List<String> sampleTags = [
    "Party",
    "Social",
    "Club Event",
    "Hackathon"
  ]; // will need to replace this with master tag list
  UserData? user;

  bool isSearchingClubs = false;
  List<ClubCardData> clubs = [];
  List<EventCardData> events = [];

  Future<void> getUser() async {
    final response = await http.get(
      Uri.parse('$serverUrl/api/users/userData'),
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
      myEvents: List<String>.from(
          (data['myEvents'] ?? []).map((event) => event.toString())),
      clubIds: List<String>.from(
          (data['clubsOwned'] ?? []).map((clubID) => clubID.toString())),
      downloadURL: data['downloadURL'],
      likedEvents: List<String>.from(
          (data['likedEvents'] ?? []).map((event) => event.toString())),
      dislikedEvents: List<String>.from(
          (data['dislikedEvents'] ?? []).map((event) => event.toString())),
      friendGroups: List<String>.from(
          (data['friendGroups'] ?? []).map((friend) => friend.toString())),
      interestedTags: List<String>.from(
          (data['interestedTags'] ?? []).map((tag) => tag.toString())),
    );
    user = tempUser;
    await user!.getFollowingData();
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
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  void performSearch(String query) {
    bool containsQuery(String name) =>
        name.toLowerCase().contains(query.toLowerCase());
    setState(() {
      filteredItemsClubs = clubs.where((club) {
        if (selectedTags.isNotEmpty && containsQuery(club.name)) {
          return selectedTags
              .any((selectedTag) => club.tags.contains(selectedTag));
        } else {
          return containsQuery(club.name);
        }
      }).toSet(); // gets all filtered clubs that also have selected tags

      filteredItemsEvents = events.where((event) {
        if (selectedTags.isNotEmpty && containsQuery(event.name)) {
          return selectedTags
              .any((selectedTag) => event.tags.contains(selectedTag));
        } else {
          return containsQuery(event.name);
        }
      }).toSet(); // gets all filtered events that also have selected tags

      filteredFollowers = user!.followingClubData.where((club) {
        if (selectedTags.isNotEmpty && containsQuery(club.name)) {
          return selectedTags
              .any((selectedTag) => club.tags.contains(selectedTag));
        } else {
          return containsQuery(club.name);
        }
      }).toSet();
    });
  }

  Future<bool> fetchClubs() async {
    clubs = [];
    events = [];
    print("IN FETCH CLUBS");
    final response = await http.get(
        Uri.parse('$serverUrl/api/clubs/getDataForSearchPage'),
        headers: await getHeaders());
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)["message"];
      print(data['clubs']);
      print(data['events']);
      for (int i = 0; i < data['clubs'].length; i++) {
        clubs.add(
          ClubCardData(
              admin: List<String>.from((data['clubs'][i]['admin'] ?? [])
                  .map((admin) => admin.toString())),
              rating: data['clubs'][i]['avgRating'].toDouble(),
              description: data['clubs'][i]['description'],
              downloadURL: data['clubs'][i]['downloadURL'],
              events: List<String>.from((data['clubs'][i]['events'] ?? [])
                  .map((event) => event.toString())),
              tags: List<String>.from((data['clubs'][i]['tags'] ?? [])
                  .map((tag) => tag.toString())),
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
            admin: List<String>.from((data['events'][i]['admin'] ?? [])
                .map((admin) => admin.toString())),
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
            likedBy: List<String>.from((data['events'][i]['likedBy'] ?? [])
                .map((likedBy) => likedBy.toString())),
            disLikedBy: List<String>.from(
                (data['events'][i]['disLikedBy'] ?? [])
                    .map((disLikedBy) => disLikedBy.toString())),
            tags: List<String>.from(
                (data['events'][i]['tags'] ?? []).map((tag) => tag.toString())),
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

  Widget buildText() =>
      Column(
        children: [
          SizedBox(
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
          ),
          MultiSelectDialogField(
            buttonText: Text("Select Club/Event Tags",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                )
            ),
            title: Text("Select Tags",
                style: TextStyle(
                  color: Colors.grey,
                )

            ),
            initialValue: selectedTags.toList(),
            items: sampleTags.map((e) => MultiSelectItem(e, e)).toList(),
            onConfirm: (List<String> values) {
              setState(() {
                selectedTags = values.toSet();
                performSearch(searchController.text);
              });
            },
            searchable: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please choose at least one admin.';
              }
              return null;
            },
          ),
        ],
      );

  Widget buildTabBar() =>
      TabBar(
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
        ],
      );

  Widget buildSearchResultList() {
    ScrollController _scrollController = ScrollController();

    Set<Widget> clubWidgets = filteredItemsClubs
        .map((club) =>
        ClubCardWidget(
          club: club,
          isOwner: user!.clubIds.contains(club.id),
          currUser: user!,
        ))
        .toSet();

    Set<Widget> eventWidgets = filteredItemsEvents
        .map((event) => EventCardWidget(event: event, isOwner: false))
        .toSet();

    Set<Widget> followerWidgets = filteredFollowers
        .map((club) =>
        ClubCardWidget(
          club: club,
          isOwner: user!.clubIds.contains(club.id),
          currUser: user!,
        ))
        .toSet();

    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height,
      child: TabBarView(
        controller: tabController,
        children: [
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 8.0, left: 0, top: 8.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.002,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Text(
                    'Organizations',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.withOpacity(0.8)),
                  ),
                ),
                SizedBox(height: 16.0),
                if (clubWidgets != null && clubWidgets.isNotEmpty)
                  Stack(
                    children: [
                      SizedBox(
                        height: 100,
                        child: ListView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          children: clubWidgets.toList(),
                        ),
                      ),
                      Positioned(
                        right: 0, // Adjust this value to move the arrow more to the right
                        bottom: 32, // Adjust this value to move the arrow down
                        child: IconButton(
                          icon: Icon(Icons.arrow_right_alt), // Arrow with a tail
                          onPressed: () {
                            _scrollController.animateTo(
                              _scrollController.offset + 200,
                              curve: Curves.linear,
                              duration: Duration(milliseconds: 500),
                            );
                          },
                        ),
                      ),
                    ],
                  )
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
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.002,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Text(
                    'Events',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.withOpacity(0.8)),
                  ),
                ),
                SizedBox(height: 15.0),
                if (eventWidgets != null && eventWidgets.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height *
                          0.6, // Adjust the height accordingly
                      child: ListView.builder(
                        itemCount: eventWidgets.length,
                        itemBuilder: (context, index) {
                          return eventWidgets.toList()[
                          index]; // Your event widget item here
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
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 8.0, left: 0, top: 8.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.002,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Organizations Followed',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.withOpacity(0.8)),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                if (filteredFollowers.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Center(
                      child: SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height *
                            0.6, // Adjust the height accordingly
                        child: ListView.builder(
                          itemCount: followerWidgets.length,
                          itemBuilder: (context, index) {
                            return followerWidgets.toList()[
                            index]; // Your event widget item here
                          },
                        ),
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
        ],
      ),
    );
  }
}
