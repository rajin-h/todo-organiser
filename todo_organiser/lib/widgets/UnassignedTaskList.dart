import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  TaskModel taskModel = TaskModel.fromMap(data, document.id);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 13),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Dismissible(
                        key: UniqueKey(),
                        onDismissed: (DismissDirection direction) {
                          if (direction == DismissDirection.endToStart) {
                            // deletion logic
                            FirebaseFirestore.instance
                                .collection("Tasks")
                                .doc(taskModel.tid)
                                .delete();
                          } else if (direction == DismissDirection.startToEnd) {
                            // mark done logic
                            FirebaseFirestore.instance
                                .collection("Tasks")
                                .doc(taskModel.tid)
                                .delete();
                          }
                        },
                        background: Container(
                            height: 60,
                            padding: const EdgeInsets.all(20),
                            width: 352,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                            ),
                            child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.check_box,
                                    color: Colors.white))),
                        secondaryBackground: Container(
                            height: 60,
                            padding: const EdgeInsets.all(20),
                            width: 352,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                            ),
                            child: const Align(
                                alignment: Alignment.centerRight,
                                child:
                                    Icon(Icons.delete, color: Colors.white))),
                        child: LongPressDraggable(
                          data: taskModel,
                          feedback: Material(
                            type: MaterialType.transparency,
                            child: Container(
                              height: 60,
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
                          childWhenDragging: Container(
                            height: 60,
                            padding: const EdgeInsets.all(20),
                            width: 352,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Container(
                            height: 60,
                            padding: const EdgeInsets.all(20),
                            width: 400,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
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
                        ),
                      ),
                    ),
                  );
                }).toList()),
          );
        }));
  }
}
