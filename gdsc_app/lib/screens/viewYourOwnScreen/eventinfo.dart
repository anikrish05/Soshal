import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/EventCardData.dart';
import 'package:gdsc_app/classes/user.dart';
import 'package:gdsc_app/screens/createEventMap.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';

class EventProfilePage extends StatefulWidget {
  final EventCardData event;

  EventProfilePage({required this.event});

  @override
  State<EventProfilePage> createState() => _EventProfilePageState();
}

class _EventProfilePageState extends State<EventProfilePage>
    with SingleTickerProviderStateMixin {
  late DateTime selectedDateTime;

  bool isEditing = false;
  late TabController tabController;
  late TextEditingController eventNameController;
  late TextEditingController eventDescController;
  final format = DateFormat("yyyy-MM-dd HH:mm");

  User user = User();
  double latitude = 0.0;
  double longitude = 0.0;

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
    latitude = result.latitude;
    longitude = result.longitude;
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
                              controller: eventNameController,
                              decoration: InputDecoration(labelText: 'Event Name'),
                              maxLines: null,
                            ),
                            TextField(
                              controller: eventDescController,
                              decoration: InputDecoration(labelText: 'Event Description'),
                              maxLines: null,
                            ),
                            // Add more text fields as needed
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 40,
                              width: 160,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: _orangeColor,
                                  textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                onPressed: () {
                                  onGetLocation();
                                },
                                child: const Text('Choose Location'),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: 'Repeat:',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Container(
                                          child: ToggleButtons(
                                            borderColor: Colors.transparent,
                                            selectedBorderColor: Colors.transparent,
                                            borderRadius: BorderRadius.circular(20.0),
                                            borderWidth: 0.0,
                                            onPressed: (int index) {
                                              setState(() {
                                                repeatable = index == 1;
                                              });
                                            },
                                            isSelected: [!repeatable, repeatable],
                                            children: [
                                              ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                  repeatable ? _orangeColor : Colors.grey,
                                                  BlendMode.srcIn,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text('Off'),
                                                ),
                                              ),
                                              ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                  repeatable ? Colors.grey : _orangeColor,
                                                  BlendMode.srcIn,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text('On'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Choose Date and Time',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.6), fontFamily: 'Garret', fontSize: 15),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 295.0,
                                child: DateTimeField(
                                  format: format,
                                  onShowPicker: (context, currentValue) async {
                                    final dateTime = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2000),
                                      initialDate: currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2101),
                                    );
                                    if (dateTime != null) {
                                      final timeOfDay = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                          currentValue ?? DateTime.now(),
                                        ),
                                      );
                                      if (timeOfDay != null) {
                                        setState(() {
                                          selectedDateTime = DateTime(
                                            dateTime.year,
                                            dateTime.month,
                                            dateTime.day,
                                            timeOfDay.hour,
                                            timeOfDay.minute,
                                          );
                                        });
                                        return selectedDateTime;
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
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
                      widget.event.name = eventNameController.text;
                      widget.event.description = eventDescController.text;
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