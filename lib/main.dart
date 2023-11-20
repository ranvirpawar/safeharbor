import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'signUp.dart';
import 'loginPage.dart';
import 'profilePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAFE HARBOR',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: '/signin',
      routes: {
        '/signup': (context) => SignUpPage(),
        '/signin': (context) => LoginPage(),
        '/profile': (context) => DisplayPage(),
        // Add more routes as needed for other pages in your app
      },
    );
  }
}
