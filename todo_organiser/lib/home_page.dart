import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_organiser/models/BucketModel.dart';
import 'package:todo_organiser/models/TaskModel.dart';
import 'package:todo_organiser/widgets/BucketList.dart';
import 'package:todo_organiser/widgets/DefaultButton.dart';
import 'package:todo_organiser/widgets/InputBox.dart';
import 'package:todo_organiser/widgets/UnassignedTaskList.dart';

import 'models/UserModel.dart';

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
        TaskModel taskModel = TaskModel(
            uid: FirebaseAuth.instance.currentUser!.uid,
            name: _taskDescController.text.trim(),
            bucket: '',
            difficulty: int.parse(_taskDifficultyController.text.trim()));
        // Add the updated food item
        await FirebaseFirestore.instance
            .collection('Tasks')
            .doc()
            .set(taskModel.toMap());

        _taskDescController.clear();
        _taskDifficultyController.clear();
      } catch (e) {
        print(e);
      } finally {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(41, 41, 41, 1),
      body: SingleChildScrollView(
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

                    SizedBox(height: 200, child: BucketList(uid: user!.uid)),

                    // ConstrainedBox(
                    //   constraints: BoxConstraints(maxHeight: 200),
                    //   child: StreamBuilder(stream: FirebaseFirestore.instance.collection("Item").snapshots())
                    // ),
                    const SizedBox(
                      height: 20,
                    ),

                    // Vertical Scrollview - For Tasks

                    Expanded(child: UnsassignedTaskList(uid: user!.uid)),

                    // ListView.separated(
                    //     itemCount: 12,
                    //     separatorBuilder: ((context, index) {
                    //       return const SizedBox(height: 12);
                    //     }),
                    //     itemBuilder: ((context, index) {
                    //       return Container(
                    //         key: Key('${context}-${index}'),
                    //         child: Text('hey'),
                    //       );
                    //     })),
                    const SizedBox(height: 20),
                    InputBox(
                        controller: _taskDescController,
                        labelText: "",
                        isReadOnly: false,
                        isPassword: false,
                        isPrimary: true,
                        maxLines: 2,
                        hintText: "Your Task Name..."),
                    const SizedBox(height: 20),
                    InputBox(
                        controller: _taskDifficultyController,
                        labelText: "",
                        isReadOnly: false,
                        isPassword: false,
                        isPrimary: true,
                        maxLines: 1,
                        hintText: "Scale of 1-5 (Difficulty)",
                        isNumber: true),
                    const SizedBox(height: 20),
                    DefaultButton(
                      labelText: "Add Task",
                      onTap: addTask,
                      isPrimary: true,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
