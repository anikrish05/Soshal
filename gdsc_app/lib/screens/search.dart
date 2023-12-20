import 'package:flutter/material.dart';
import 'package:gdsc_app/widgets/clubWidgets/clubCard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:gdsc_app/classes/EventCardData.dart';
import 'package:gdsc_app/widgets/loader.dart';
import 'package:gdsc_app/widgets/clubWidgets/clubCard.dart';
import 'package:gdsc_app/widgets/eventWidgets/eventCard.dart';

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

  final GlobalKey<AnimatedListState> _clubListKey = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _eventListKey = GlobalKey<AnimatedListState>();

  bool isSearchingClubs = false;
  List<ClubCardData> clubs = [];
  List<EventCardData> events = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  void performSearch(String query) {
    setState(() {
      filteredItemsClubs = clubs
          .where((club) => club.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      filteredItemsEvents = events
          .where((event) => event.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });

    _clubListKey.currentState?.insertItem(0);
    _eventListKey.currentState?.insertItem(0);
  }

  Future<bool> fetchClubs() async {
    print("IN FETCH CLUBS");
    final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/clubs/getDataForSearchPage'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
      json.decode(response.body)["message"];
      for (int i = 0; i < data['clubs'].length; i++) {
        clubs.add(
          ClubCardData(
              admin: List<String>.from((data['clubs'][i]['admin'] ?? [])
                  .map((admin) => admin.toString())),
              category: data['clubs'][i]['category'],
              description: data['clubs'][i]['description'],
              downloadURL: data['clubs'][i]['downloadURL'],
              events: List<String>.from((data['clubs'][i]['events'] ?? [])
                  .map((event) => event.toString())),
              followers: List<String>.from((data['clubs'][i]['followers'] ?? [])
                  .map((follower) => follower.toString())),
              name: data['clubs'][i]['name'],
              type: data['clubs'][i]['type'],
              verified: data['clubs'][i]['verified'],
              id: data['clubs'][i]['id']),
        );
      }
      for (int i = 0; i < data['events'].length; i++) {
        events.add(
          EventCardData(
              rsvpList: List<String>.from((data['events'][i]['rsvpList'] ?? [])
                  .map((rsvp) => rsvp.toString())),
              name: data['events'][i]['name'],
              description: data['events'][i]['description'],
              downloadURL: data['events'][i]['downloadURL'],
              latitude: data['events'][i]['latitude'],
              longitude: data['events'][i]['longitude'],
              rating: data['events'][i]['rating'].toDouble(),
              comments: List<String>.from((data['events'][i]['comments'] ?? [])
                  .map((comment) => comment.toString())),
              id: data['events'][i]['id']),
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
      body: FutureBuilder<bool>(
        future: fetchClubs(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoaderWidget();
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
    child: TextFormField(
      onChanged: (text) {
        performSearch(text);
      },
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
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Row(
        children: <Widget>[
          Expanded(
            child: AnimatedList(
              key: _clubListKey,
              initialItemCount: filteredItemsClubs.length,
              itemBuilder: (context, index, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ClubCardWidget(club: filteredItemsClubs[index]),
                );
              },
            ),
          ),
          /*
          Expanded(
            child: AnimatedList(
              key: _eventListKey,
              initialItemCount: filteredItemsEvents.length,
              itemBuilder: (context, index, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: EventCardWidget(event: filteredItemsEvents[index]),
                );
              },
            ),
          ),
         */
        ],
      ),
    );
  }
}
