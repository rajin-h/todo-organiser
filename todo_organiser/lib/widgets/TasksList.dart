import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_organiser/misc/HexColor.dart';
import 'package:todo_organiser/models/BucketModel.dart';

import 'package:todo_organiser/models/TaskModel.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key, required this.uid});

  final String uid;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  // Stream Transformation
  var streamTransformer = StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
      List<TaskModel>>.fromHandlers(
    handleData: (QuerySnapshot<Map<String, dynamic>> data,
        EventSink<List<TaskModel>> sink) async {
      final tasks = data.docs
          .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
          .toList();

      List<BucketModel> buckets = [];
      for (TaskModel task in tasks) {
        await FirebaseFirestore.instance
            .collection("Buckets")
            .doc(task.bucket)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            buckets.add(BucketModel.fromMap(
                documentSnapshot.data() as Map<String, dynamic>,
                documentSnapshot.id));
          }
        });
      }

      // remove the tasks with invalid difficulties
      for (var i = 0; i < tasks.length; i++) {
        if (tasks[i].difficulty > 5) {
          tasks.removeAt(i);
        }
      }

      // sort tasks in descneding order of difficulty
      tasks.sort((a, b) => b.difficulty.compareTo(a.difficulty));

      // sort buckets by urgency
      List<TaskModel> newTasksList = [];
      buckets.sort(((a, b) => b.urgency.compareTo(a.urgency)));
      for (var i = 0; i < buckets.length; i++) {
        for (var j = 0; j < tasks.length; j++) {
          if (buckets[i].bid == tasks[j].bucket) {
            tasks[j].bucketModel = buckets[i];
            newTasksList.add(tasks[j]);
            tasks.removeAt(j);
          }
        }
      }

      sink.add(newTasksList);
    },
    handleError: (error, stacktrace, sink) {
      sink.addError('Something went wrong: $error');
    },
    handleDone: (sink) {
      sink.close();
    },
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Tasks")
            .where("uid", isEqualTo: widget.uid)
            .where("bucket", isNotEqualTo: "")
            .snapshots()
            .transform(streamTransformer),
        builder:
            ((BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something Went Wrong");
          }

          if (!snapshot.hasData) {
            return Text(
              "Recalculating...",
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            );
          }

          return NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: ListView(
                scrollDirection: Axis.vertical,
                children: snapshot.data!.map((TaskModel taskModel) {
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
                            height: 80,
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
                            height: 80,
                            padding: const EdgeInsets.all(20),
                            width: 352,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                            ),
                            child: const Align(
                                alignment: Alignment.centerRight,
                                child:
                                    Icon(Icons.delete, color: Colors.white))),
                        child: Container(
                          height: 80,
                          padding: const EdgeInsets.all(20),
                          width: 400,
                          decoration: BoxDecoration(
                            color: HexColor(
                                taskModel.bucketModel?.colour ?? "#FFFFFFF"),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                taskModel.name,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "Difficulty: ${taskModel.difficulty}",
                                textAlign: TextAlign.start,
                                style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList()),
          );
        }));
  }
}
