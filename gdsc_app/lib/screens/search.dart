import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin{
  final searchController = TextEditingController();
  Color _color1 = Color(0xFFFF8050);
  Color _color2 = Color(0xFFF0F0F0);
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }
  @override
  void dispose() {
    super.dispose();
    tabController!.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          buildText(),
          Padding(
            padding: EdgeInsets.all(16.0),
          ),
          buildTabBar()
        ]
      ),
    );
  }
  Widget buildText() => SizedBox(
    width: 350,
    child: TextFormField(
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
        )
    ),
  );
  Widget buildTabBar() => TabBar(
      unselectedLabelColor: Colors.redAccent,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.redAccent),
      controller: tabController,
      tabs: [
        Tab(
          text: 'discover',
        ),
        Tab(
          text: 'following',
        ),
        Tab(
          text: 'near me',
        )
      ]
  );
}


