import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetHelpPage extends StatelessWidget {
  final String fullName;
  final String emergencyPhoneNumber;

  GetHelpPage({
    required this.fullName,
    required this.emergencyPhoneNumber,
  });

  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // Handle the case where location permission is denied
      return Future.error('Location permission denied');
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<void> sendEmergencySMS(String location, String dateTime) async {
    try {
      String message = '$fullName needs your help. Location: $location. Date & Time: $dateTime';
      String uri = 'sms:$emergencyPhoneNumber?body=$message';

      if (await canLaunch(uri)) {
        await launch(uri);

        // Store the help request information in Firestore
        await FirebaseFirestore.instance.collection('help_requests').add({
          'fullName': fullName,
          'emergencyPhoneNumber': emergencyPhoneNumber,
          'location': location,
          'dateTime': dateTime,
        });
      } else {
        // Handle error, e.g., show a snackbar or print an error message
        print('Error launching SMS');
      }
    } catch (e) {
      // Handle exceptions, e.g., location permission denied
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Get Help',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: Colors.pink,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              Position position = await getCurrentLocation();
              String location = '${position.latitude}, ${position.longitude}';
              String dateTime = DateTime.now().toString();
              sendEmergencySMS(location, dateTime);
            } catch (e) {
              // Handle exceptions, e.g., location permission denied
              print('Error: $e');
            }
          },
          child: Text('Get Help'),
        ),
      ),
    );
  }
}
