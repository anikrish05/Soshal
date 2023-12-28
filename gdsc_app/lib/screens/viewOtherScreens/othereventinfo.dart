import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/EventCardData.dart';
import 'package:gdsc_app/classes/user.dart';
import 'package:gdsc_app/screens/createEventMap.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:toggle_switch/toggle_switch.dart';

class OtherEventProfilePage extends StatefulWidget {
  final EventCardData event;

  OtherEventProfilePage({required this.event});

  @override
  State<OtherEventProfilePage> createState() => _OtherEventProfilePageState();
}

class _OtherEventProfilePageState extends State<OtherEventProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late TextEditingController eventNameController;
  late TextEditingController eventDescController;
  User user = User();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    isUserSignedIn();
    eventNameController = TextEditingController(text: widget.event.name);
    eventDescController = TextEditingController(text: widget.event.description);// Initialize the controller
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


  Color _orangeColor = Color(0xFFFF8050);
  bool repeatable = false;

  final ButtonStyle style2 =
  ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      shape: StadiumBorder(),
      textStyle: const TextStyle(fontFamily: 'Borel', fontSize: 15, color: Colors.grey ));

  @override
  void onGetLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateEventMapScreen()),
    );
    print("-------------");
    print(result);
  }

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
                            '${widget.event.name}',
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
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${widget.event.description}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
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
        ],
      ),
    );
  }






  Widget profilePicture() {
    if (widget.event.downloadURL != "") {
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(widget.event.downloadURL),
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
      unselectedLabelColor: _orangeColor,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: _orangeColor,
      ),
      controller: tabController,
      tabs: [
        Tab(
          child: Text(
            'RSVP List',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
      indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
    );
  }
}