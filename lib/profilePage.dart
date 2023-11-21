import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safeharbor/loginPage.dart';

class DisplayPage extends StatefulWidget {
  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  User? _currentUser;
  Map<String, dynamic>? _userDetails;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
    _fetchUserDetails();
  }

  Future<void> _fetchCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> _fetchUserDetails() async {
    if (_currentUser != null) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .get();
        if (snapshot.exists) {
          setState(() {
            _userDetails = snapshot.data() as Map<String, dynamic>?;
            _loading = false;
          });
        } else {
          _loading = false;
        }
      } catch (error) {
        print("Error fetching user details: $error");
        _loading = false;
      }
    }
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: _loading
            ? CircularProgressIndicator()
            : Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'Full Name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        _userDetails?['fullName'] ?? 'N/A',
                        style: TextStyle(fontSize: 16),
                      ),
                      leading: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        _currentUser?.email ?? 'N/A',
                        style: TextStyle(fontSize: 16),
                      ),
                      leading: Icon(
                        Icons.email,
                        size: 30,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'Mobile Number',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        _userDetails?['mobileNumber'] ?? 'N/A',
                        style: TextStyle(fontSize: 16),
                      ),
                      leading: Icon(
                        Icons.phone,
                        size: 30,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'Emergency Contact Name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        _userDetails?['emergencyName'] ?? 'N/A',
                        style: TextStyle(fontSize: 16),
                      ),
                      leading: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'Emergency Contact Number',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        _userDetails?['emergencyMobile'] ?? 'N/A',
                        style: TextStyle(fontSize: 16),
                      ),
                      leading: Icon(
                        Icons.phone,
                        size: 30,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _logout(context),
                      child: Text('Logout'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
