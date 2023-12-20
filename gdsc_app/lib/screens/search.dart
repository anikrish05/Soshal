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
        'http://10.0.2.2:3000/api/clubs/getDataForSearchPage'));
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
              followers: List<String>.from((data['clubs'][i]['followers'] ?? [])
                  .map((follower) => follower.toString())),
              name: data['clubs'][i]['name'],
              type: data['clubs'][i]['type'],
              verified: data['clubs'][i]['verified'],
              id: data['clubs'][i]['id']),
        );
      }
      for (int i = 0; i < data['events'].length; i++) {
        List<ClubCardData> temp = [];
        /*
        for (int z = 0; z < data['events']['clubInfo'].length; z++) {
          temp.add(
            ClubCardData(
                admin: List<String>.from((data['events']['clubInfo'][z]['admin'] ?? []).map((admin) => admin.toString())),
                category: data['events']['clubInfo'][z]['category'],
                rating: data['events']['clubInfo'][z]['avgRating'].toDouble(),
                description: data['events']['clubInfo'][z]['description'],
                downloadURL: data['events']['clubInfo'][z]['downloadURL'],
                events: List<String>.from((data['events']['clubInfo'][z]['events'] ?? []).map((event) => event.toString())),
                followers: List<String>.from((data['events']['clubInfo'][z]['followers'] ?? []).map((follower) => follower.toString())),
                name: data['events']['clubInfo'][z]['name'],
                type: data['events']['clubInfo'][z]['type'],
                verified: data['events']['clubInfo'][z]['verified'],
                id: data['events']['clubInfo'][z]['id']
            ),
          );
        }
         */

        events.add(
          EventCardData(
            admin: List<String>.from((data['events'][i]['admin'] ?? []).map((admin) => admin.toString())),
            clubInfo: temp,
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
            id: data['events'][i]['id'],
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
      body: FutureBuilder<bool>(
        future: fetchClubs(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
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
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: filteredItemsClubs.length + filteredItemsEvents.length,
        itemBuilder: (context, index) {
          if (index < filteredItemsClubs.length) {
            return ClubCardWidget(club: filteredItemsClubs[index]);
          } else {
            return EventCardWidget(
                event: filteredItemsEvents[index - filteredItemsClubs.length]);
          }
        },
      ),
    );
  }
}
