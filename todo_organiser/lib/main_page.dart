import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:todo_organiser/login_page.dart';

import 'home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(41, 41, 41, 1),
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return HomePage();
              } else {
                return LoginPage();
              }
            })));
  }
}
