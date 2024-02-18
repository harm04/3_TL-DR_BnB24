import 'dart:typed_data';

import 'package:corruption_watch/pages/chat.dart';
import 'package:corruption_watch/utils/image_picker.dart';
import 'package:corruption_watch/widgets/button.dart';
import 'package:corruption_watch/widgets/ministry_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String data = "";
  Uint8List? image;
  void getPosition() async {
    var status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      Position datas = await _determinedPosition();
      getAddressFromLong(datas);
      print("$data");
    }
  }

  void getAddressFromLong(Position datas) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(datas.latitude, datas.longitude);
    Placemark place = placemark[0];
    var address = "${place.street},${place.country}";
    setState(() {
      data = address;
    });
  }

  _determinedPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location service are disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permission denied foreover");
    }
    return await Geolocator.getCurrentPosition();
  }

  selectImage() async {
    Uint8List img = await pickImage(ImageSource.camera);
    setState(() {
      image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  size: 40,
                ),
                onPressed: () async {
                  await selectImage();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Upload evidence'),
                          content: const Text(
                              'your location will be shared with the respective authorities.Do you wish to go ahead?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: (){ Navigator.pop(context, 'OK');
                              getPosition();
                              //send data to investigator.
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      });
                  
                  // print('$data');
                },
              )),
        ],
        title: const Text(
          'Corruption watch',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Select Ministry',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChatPage(
                              title: 'Complain', ministry: 'Law')),
                    );
                  },
                  child: ministryCard(
                      context,
                      const AssetImage('assets/images/law.jpeg'),
                      'Law\'s and Judes'),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChatPage(
                              title: 'Complain', ministry: 'PanchayatiRaj')),
                    );
                  },
                  child: ministryCard(
                      context,
                      const AssetImage('assets/images/panchayatiRaj.jpeg'),
                      'Panchayati raj'),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChatPage(
                              title: 'Complain', ministry: 'Defence')),
                    );
                  },
                  child: ministryCard(
                      context,
                      const AssetImage('assets/images/defence.jpeg'),
                      'Defence'),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChatPage(
                              title: 'Complain', ministry: 'Revenue')),
                    );
                  },
                  child: ministryCard(
                      context,
                      const AssetImage('assets/images/revenue.jpeg'),
                      'Revenue'),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChatPage(
                            title: 'Complain', ministry: 'Others')),
                  );
                },
                child: button('Others', 50, 350, Colors.white)),
          ],
        ),
      ),
    );
  }
}
