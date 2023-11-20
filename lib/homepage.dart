import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(Homepage());
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late String fullName = ''; // Initialize fullName with an empty string

  @override
  void initState() {
    super.initState();
    fetchFullName();
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
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journey-Mate',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
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
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome ${fullName}', // Display the full name if available
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Guardians at Your Fingertips: Your safety is paramount, whether at home, on the move, or in the workplace. Feel protected, respected, and empowered. No need to fear the unknown – a single tap connects you to your safety confidant.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
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
          );
        },
      ),
    );
  }
}
