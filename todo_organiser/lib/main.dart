import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_organiser/buckets_page.dart';
import 'package:todo_organiser/home_page.dart';
import 'package:todo_organiser/login_page.dart';
import 'package:todo_organiser/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Organiser',
      initialRoute: '/main',
      routes: {
        '/main': (context) => const MainPage(),
        '/home': (context) => const HomePage(),
        '/buckets': (context) => const BucketsPage(),
      },
    );
  }
}
