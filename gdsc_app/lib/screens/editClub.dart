import 'package:flutter/material.dart';
import 'package:gdsc_app/classes/ClubCardData.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:http/http.dart' as http;
import '/../app_config.dart';
import 'dart:convert';
import '/../utils.dart';
import 'dart:io' as i;

final serverUrl = AppConfig.serverUrl;

class UpdateClubScreen extends StatefulWidget {
  final ClubCardData club;
  UpdateClubScreen({required this.club});
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}
// widget.user
class _CreateUserScreenState extends State<UpdateClubScreen> {
  final newName = TextEditingController();
  final newDesc = TextEditingController();

  int indexPubOrPriv = 1;

  bool chooseImage = false;
  List<int> newImageBytes = [];
  XFile? _image;

  Color _orangeColor = Color(0xFFFF8050);
  final ButtonStyle style =
  ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      shape: StadiumBorder(),
      textStyle: const TextStyle(
          fontFamily: 'Borel', fontSize: 30, color: Colors.grey));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.orange),
            centerTitle: true,
            title: Text("Update Club Details",
              style: TextStyle(
                color: Color(0xFF88898C),
              ),),
            backgroundColor: Colors.white
        ),
        body:
        Padding(
            padding: EdgeInsets.all(16.6),
            child: ListView(
              children: [
                Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              GestureDetector(
                                child: _image == null
                                    ? profilePicture()
                                    : CircleAvatar(
                                  radius: 60,
                                  backgroundImage: FileImage(i.File(_image!.path)),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    _pickImage();
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
                              )
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Change Club Name',
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.6),
                                  fontFamily: 'Borel',
                                  fontSize: 15),
                            ),
                          ),
                          TextField(
                            controller: newName,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              hintText: widget.club.name,
                              contentPadding: EdgeInsets.fromLTRB(
                                  20.0, 10.0, 20.0, 10.0),
                            ),
                          ),
                          Divider(),
                          RichText(
                            text: TextSpan(
                              text: 'Change Club Description',
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.6),
                                  fontFamily: 'Borel',
                                  fontSize: 15),
                            ),
                          ),
                          TextField(
                            controller: newDesc,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              hintText: widget.club.description,
                              contentPadding: EdgeInsets.fromLTRB(
                                  20.0, 10.0, 20.0, 10.0),
                            ),
                          ),
                          Divider(),
                          Row(
                            children:[
                              RichText(
                                text: TextSpan(
                                  text: 'Change Club Type',
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(0.6),
                                      fontFamily: 'Borel',
                                      fontSize: 15),
                                ),
                              ),
                              VerticalDivider(),
                              ToggleSwitch(
                                minWidth: 77.5,
                                cornerRadius: 20.0,
                                activeBgColors: [
                                  [_orangeColor],
                                  [_orangeColor]
                                ],
                                activeFgColor: Colors.white,
                                inactiveBgColor: Colors.grey,
                                inactiveFgColor: Colors.white,
                                initialLabelIndex: 0,
                                totalSwitches: 2,
                                labels: ['Public', 'Private'],
                                radiusStyle: true,
                                onToggle: (index) {
                                  if (index == 1) {
                                    indexPubOrPriv = 0;
                                    print("private");
                                  } else if (index == 0) {
                                    indexPubOrPriv = 1;
                                    print("public");
                                  }
                                },
                              ),
                            ]
                          ),
                          Divider(height: 15,),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  height: 50,
                                  width: 200,
                                  child:
                                  ElevatedButton(
                                    style: style,
                                    onPressed: () {
                                      submitEdit();
                                    },
                                    child: const Text('Update'),
                                  ),
                                )
                              ],
                            ),
                          )
                        ]
                    )
                )
              ],
            )
        )
    );
  }

  Widget profilePicture() {
    if (widget.club.downloadURL != "") {
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(widget.club.downloadURL),

      );
    } else {
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(
            'https://cdn.shopify.com/s/files/1/0982/0722/files/6-1-2016_5-49-53_PM_1024x1024.jpg?7174960393118038727'),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      // Read the image file as bytes
      chooseImage = true;
      newImageBytes = await pickedFile.readAsBytes();

      setState(() {
        _image = pickedFile;
      });

      print("Succesful");
    }

  }

  Future<void> sendImageToServer(List<int> imageBytes) async {
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/api/clubs/updateClubImage'),
        headers: await getHeaders(),
        body: jsonEncode(<String, dynamic>{
          "image": imageBytes,
          "id": widget.club.id
        }),
      );

      print(widget.club.id);

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        setState(() {});
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading image: $error');
    }

    setState(() {

    });
  }

  void submitEdit() async
  {
    String clubType = widget.club.type;
    if (indexPubOrPriv == 0) {
      clubType = "Private";
    }
    else {
      clubType = "Public";
    }

    String newClubName = "";
    String newClubDesc = "";

    if (newName.text == "")
      {
        newClubName = widget.club.name;
      }
    else
      {
        newClubName = newName.text;
      }

    if (newDesc.text == "")
      {
        newClubDesc = widget.club.description;
      }
    else
      {
        newClubDesc = newDesc.text;
      }




    String clubId = widget.club.id;

    Navigator.pop(context, [newClubName,newClubDesc,clubType,clubId,newImageBytes]);
  }

}