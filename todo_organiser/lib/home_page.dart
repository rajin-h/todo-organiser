import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:todo_organiser/buckets_page.dart';
import 'package:todo_organiser/main_page.dart';
import 'package:todo_organiser/models/TaskModel.dart';
import 'package:todo_organiser/widgets/BucketList.dart';
import 'package:todo_organiser/widgets/DefaultButton.dart';
import 'package:todo_organiser/widgets/InputBox.dart';
import 'package:todo_organiser/widgets/UnassignedTaskList.dart';

import 'misc/FadeInRoute.dart';
import 'planner_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  final TextEditingController _taskDescController = TextEditingController();
  final TextEditingController _taskDifficultyController =
      TextEditingController();

  @override
  void dispose() {
    _taskDescController.dispose();
    _taskDifficultyController.dispose();
    super.dispose();
  }

  // Sign Out Method
  void signOut() {
    Navigator.push(
      context,
      FadeInRoute(
        routeName: "/main",
        page: const MainPage(),
      ),
    );
    FirebaseAuth.instance.signOut();
  }

  Future addTask() async {
    if (_taskDescController.text.trim() == "") {
      return;
    }

    if (_taskDifficultyController.text.trim() == "") {
      return;
    }

    if (FirebaseAuth.instance.currentUser != null) {
      try {
        DocumentReference docRef =
            await FirebaseFirestore.instance.collection('Tasks').doc();

        TaskModel taskModel = TaskModel(
            tid: docRef.id,
            uid: FirebaseAuth.instance.currentUser!.uid,
            name: _taskDescController.text.trim(),
            bucket: '',
            difficulty: int.parse(_taskDifficultyController.text.trim()));

        docRef.set(taskModel.toMap());

        _taskDescController.clear();
        _taskDifficultyController.clear();
      } catch (e) {
        print(e);
      } finally {}
    }
  }

  List<String> stringRoutes = ['buckets', 'home', 'planner'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: GNav(
            selectedIndex: 1,
            gap: 8,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            onTabChange: ((value) {
              Navigator.push(
                context,
                FadeInRoute(
                    routeName: "/${stringRoutes[value]}",
                    page: value == 0
                        ? const BucketsPage()
                        : value == 1
                            ? const HomePage()
                            : const PlannerPage()),
              );
            }),
            tabs: const [
              GButton(
                iconColor: Colors.white,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                icon: Icons.settings,
                text: "Buckets",
              ),
              GButton(
                iconColor: Colors.white,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                icon: Icons.home,
                text: "Home",
              ),
              GButton(
                iconColor: Colors.white,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                icon: Icons.list,
                text: "Planner",
              ),
            ]),
      ),
      backgroundColor: const Color.fromRGBO(41, 41, 41, 1),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, top: 30, bottom: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Home",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                ),
                              ),
                              Text(
                                "${user!.displayName}",
                                style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 150,
                          ),
                          Expanded(
                              child: DefaultButton(
                            labelText: "Log Out",
                            onTap: signOut,
                            isPrimary: true,
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // Horizontal Scrollview - For Buckets

                      SizedBox(
                          height: 150,
                          child: BucketList(
                            uid: user!.uid,
                            isVertical: false,
                          )),

                      const SizedBox(
                        height: 20,
                      ),

                      // Vertical Scrollview - For Tasks

                      Expanded(child: UnsassignedTaskList(uid: user!.uid)),

                      const SizedBox(height: 20),
                      InputBox(
                        controller: _taskDescController,
                        labelText: "",
                        isReadOnly: false,
                        isPassword: false,
                        isPrimary: true,
                        maxLines: 2,
                        hintText: "Task Name ...",
                      ),
                      const SizedBox(height: 20),
                      InputBox(
                          controller: _taskDifficultyController,
                          labelText: "",
                          isReadOnly: false,
                          isPassword: false,
                          isPrimary: true,
                          maxLines: 1,
                          hintText: "Difficulty (1-5)",
                          isNumber: true),
                      const SizedBox(height: 20),
                      DefaultButton(
                        labelText: "Add Task",
                        onTap: addTask,
                        isPrimary: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
