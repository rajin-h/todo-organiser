import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_organiser/models/BucketModel.dart';
import 'dart:math' as math;

import 'package:todo_organiser/models/TaskModel.dart';

class UnsassignedTaskList extends StatefulWidget {
  const UnsassignedTaskList({super.key, required this.uid});

  final String uid;

  @override
  State<UnsassignedTaskList> createState() => _UnsassignedTaskListState();
}

class _UnsassignedTaskListState extends State<UnsassignedTaskList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Tasks")
            .where("uid", isEqualTo: widget.uid)
            .where("bucket", isEqualTo: "")
            .snapshots(),
        builder:
            ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something Went Wrong");
          }

          if (!snapshot.hasData) {
            return const Text("Loading...");
          }

          print('just testing');

          return NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: ListView(
                scrollDirection: Axis.vertical,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  TaskModel taskModel = TaskModel.fromMap(data);
                  return LongPressDraggable(
                    data: taskModel,
                    childWhenDragging: Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(20),
                      width: 352,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    feedback: Material(
                      type: MaterialType.transparency,
                      child: Container(
                        height: 60,
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(20),
                        width: 352,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          taskModel.name,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    child: Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(20),
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        taskModel.name,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    onDragCompleted: () {
                      print('drag completed');
                    },
                    onDraggableCanceled: (velocity, offset) {
                      print('cancelled');
                    },
                  );
                }).toList()),
          );
        }));
  }
}
