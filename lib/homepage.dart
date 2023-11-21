import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'profilePage.dart';


class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late String fullName = '';
  late String emergencyPhoneNumber;
  int _currentIndex = 0;
  String currentLocation = '';
  String currentDateTime = '';

  @override
  void initState() {
    super.initState();
    fetchFullName();
    updateDateTime();
    fetchLocation();
  }

  Future<void> fetchFullName() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? userData =
            snapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData['fullName'] != null) {
          setState(() {
            fullName = userData['fullName'];
            emergencyPhoneNumber = userData['emergencyMobile'] ?? '';
          });
        }
      }
    }
  }

  Future<void> updateDateTime() async {
    String formattedDateTime =
        DateFormat('EEE, MMM d, y hh:mm a').format(DateTime.now());
    setState(() {
      currentDateTime = formattedDateTime;
    });
  }

  Future<void> fetchLocation() async {
    try {
      var status = await Permission.location.status;
      print('Location permission status: $status');

      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        print('Location obtained: $position');

        setState(() {
          currentLocation =
              'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
          print(currentLocation);
        });
      } else {
        // Request location permission
        print('Requesting location permission...');
        await Permission.location.request();
        print(
            'Location permission granted: ${await Permission.location.status}');
      }
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        currentLocation = 'Location not available';
      });
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (_currentIndex) {
      case 0:
        // Current page is the home page (already on it)
        break;
      case 1:
        // Navigate to ProfilePage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DisplayPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe Harbor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Safe Harbor',
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
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome ${fullName}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Guardians at Your Fingertips:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Your safety is paramount, whether at home, on the move, or in the workplace. Feel protected, respected, and empowered. No need to fear the unknown – a single tap connects you to your safety confidant.',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 30),
              Text(
                'Current Location: $currentLocation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Current Date and Time: $currentDateTime',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Add your logic to handle "Get Help" action
                },
                child: Text('Get Help'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onNavItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
