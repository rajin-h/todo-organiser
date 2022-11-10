import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:todo_organiser/home_page.dart';
import 'package:todo_organiser/misc/RandomHex.dart';
import 'package:todo_organiser/models/TaskModel.dart';
import 'package:todo_organiser/widgets/BucketList.dart';
import 'package:todo_organiser/widgets/DefaultButton.dart';
import 'package:todo_organiser/widgets/InputBox.dart';

import 'misc/FadeInRoute.dart';
import 'models/BucketModel.dart';
import 'planner_page.dart';

class BucketsPage extends StatefulWidget {
  const BucketsPage({super.key});

  @override
  State<BucketsPage> createState() => _BucketsPageState();
}

class _BucketsPageState extends State<BucketsPage> {
  final user = FirebaseAuth.instance.currentUser;

  final TextEditingController _bucketNameController = TextEditingController();
  final TextEditingController _flexibilityController = TextEditingController();
  final TextEditingController _urgencyContrller = TextEditingController();
  final TextEditingController _daysController = TextEditingController();

  @override
  void dispose() {
    _bucketNameController.dispose();
    _flexibilityController.dispose();
    _urgencyContrller.dispose();
    _daysController.dispose();
    super.dispose();
  }

  // Sign Out Method
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  Future addTask() async {
    if (_bucketNameController.text.trim() == "" ||
        _flexibilityController.text.trim() == "" ||
        _urgencyContrller.text.trim() == "" ||
        _daysController.text.trim() == "") {
      return;
    }

    if (FirebaseAuth.instance.currentUser != null) {
      try {
        final _random = Random();
        BucketModel bucketModel = BucketModel(
            uid: FirebaseAuth.instance.currentUser!.uid,
            name: _bucketNameController.text.trim(),
            flexibility: int.parse(_flexibilityController.text.trim()),
            urgency: int.parse(_urgencyContrller.text.trim()),
            colour: RandomHex(),
            daysLeft: int.parse(_daysController.text.trim()));

        await FirebaseFirestore.instance
            .collection('Buckets')
            .doc()
            .set(bucketModel.toMap());

        _bucketNameController.clear();
        _flexibilityController.clear();
        _urgencyContrller.clear();
        _daysController.clear();
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
            selectedIndex: 0,
            gap: 8,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
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
                                "Buckets",
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
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // Vertical Scrollview - For Buckets

                      Expanded(
                          child: BucketList(
                        uid: user!.uid,
                        isVertical: true,
                      )),

                      const SizedBox(height: 20),
                      InputBox(
                          controller: _bucketNameController,
                          labelText: "",
                          isReadOnly: false,
                          isPassword: false,
                          isPrimary: true,
                          maxLines: 2,
                          hintText: "Bucket Name ..."),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Flexible(
                            child: InputBox(
                                controller: _flexibilityController,
                                labelText: "",
                                isReadOnly: false,
                                isPassword: false,
                                isPrimary: true,
                                maxLines: 1,
                                hintText: "Flexibility (1-100)",
                                isNumber: true),
                          ),
                          const SizedBox(
                            height: 20,
                            width: 20,
                          ),
                          Flexible(
                            child: InputBox(
                                controller: _urgencyContrller,
                                labelText: "",
                                isReadOnly: false,
                                isPassword: false,
                                isPrimary: true,
                                maxLines: 1,
                                hintText: "Urgency (1-100)",
                                isNumber: true),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      InputBox(
                          controller: _daysController,
                          labelText: "",
                          isReadOnly: false,
                          isPassword: false,
                          isPrimary: true,
                          maxLines: 1,
                          hintText: "Days (1-7)",
                          isNumber: true),
                      const SizedBox(height: 20),
                      DefaultButton(
                        labelText: "Add Bucket",
                        onTap: addTask,
                        isPrimary: false,
                      )
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
