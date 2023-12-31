import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          NotificationIconButton(tabController: _tabController),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          NotificationTab(tabTitle: 'Requested'),
          NotificationTab(tabTitle: 'Accepted'),
        ],
      ),
    );
  }
}

class NotificationTab extends StatelessWidget {
  final String tabTitle;

  NotificationTab({required this.tabTitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(tabTitle),
    );
  }
}

class NotificationIconButton extends StatelessWidget {
  final TabController? tabController;

  NotificationIconButton({this.tabController});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        children: [
          Icon(Icons.notifications),
          Positioned(
            right: 0,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.red,
              child: Text(
                '3', // Replace with the actual notification count
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Notifications'),
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'Requested'),
                    Tab(text: 'Accepted'),
                  ],
                  controller: tabController,
                ),
              ),
              body: TabBarView(
                controller: tabController,
                children: [
                  NotificationTab(tabTitle: 'Requested'),
                  NotificationTab(tabTitle: 'Accepted'),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
