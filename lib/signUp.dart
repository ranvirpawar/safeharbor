import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginPage.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emergencyNameController =
      TextEditingController();
  final TextEditingController _emergencyMobileController =
      TextEditingController();

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextFormField(
              controller: _mobileNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Mobile Number'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextFormField(
              controller: _emergencyNameController,
              decoration: InputDecoration(labelText: 'Emergency Contact Name'),
            ),
            TextFormField(
              controller: _emergencyMobileController,
              keyboardType: TextInputType.phone,
              decoration:
                  InputDecoration(labelText: 'Emergency Contact Number'),
            ),
            ElevatedButton(
              onPressed: () {
                signUp();
              },
              child: Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text("Login"),
            )
          ],
        ),
      ),
    );
  }

  void signUp() async {
    String fullName = _fullNameController.text;
    String mobileNumber = _mobileNumberController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String emergencyName = _emergencyNameController.text;
    String emergencyMobile = _emergencyMobileController.text;

    if (fullName.isEmpty ||
        mobileNumber.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        emergencyName.isEmpty ||
        emergencyMobile.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all the fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      // Store user data in Firestore
      User user =
          User(fullName, mobileNumber, email, emergencyName, emergencyMobile);
      _usersCollection.doc(userId).set(user.toJson());

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('User registered successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content:
                Text('An error occurred while registering the user. $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

class User {
  String fullName;
  String mobileNumber;
  String email;
  String emergencyName;
  String emergencyMobile;

  User(this.fullName, this.mobileNumber, this.email, this.emergencyName,
      this.emergencyMobile);

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'email': email,
      'emergencyName': emergencyName,
      'emergencyMobile': emergencyMobile,
    };
  }
}
