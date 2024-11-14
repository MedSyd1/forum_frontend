import 'package:flutter/material.dart';
import 'package:forum_frontend/register_page.dart';
import 'package:provider/provider.dart';
import 'login_page.dart'; // Import the LoginPage
import 'user_provider.dart'; // Import the UserProvider

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(), 
      child: MaterialApp(
        title: 'User Registration',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/': (context) => RegisterPage(), 
          '/login': (context) => LoginPage(),
        },
      ),
    );
  }
}
