import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_organiser/misc/HexColor.dart';
import 'package:todo_organiser/models/BucketModel.dart';
import 'dart:math' as math;

import '../models/TaskModel.dart';

class BucketList extends StatefulWidget {
  const BucketList({super.key, required this.uid, required this.isVertical});

  final String uid;
  final bool isVertical;

  @override
  State<BucketList> createState() => _BucketListState();
}

class _BucketListState extends State<BucketList> {
  // Method to handle bucket assignment
  Future assignBucket(TaskModel taskModel) async {
    print('we received this..... -> ${taskModel.name}');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Buckets")
            .where("uid", isEqualTo: widget.uid)
            .snapshots(),
        builder:
            ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something Went Wrong");
          }

          if (!snapshot.hasData) {
            return const Text("Loading...");
          }

          if (widget.isVertical) {
            return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: ListView(
                  scrollDirection: Axis.vertical,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    BucketModel bucketModel = BucketModel.fromMap(data);

                    return DragTarget<TaskModel>(
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          height: 80,
                          margin: EdgeInsets.only(bottom: 20),
                          padding: EdgeInsets.all(20),
                          width: 115,
                          decoration: BoxDecoration(
                              color: HexColor(bucketModel.colour),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bucketModel.name,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                      onWillAccept: (data) {
                        return true;
                      },
                      onAccept: (data) {
                        print('here');
                        // assignBucket(data);
                      },
                    );
                  }).toList()),
            );
          } else {
            return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    BucketModel bucketModel = BucketModel.fromMap(data);

                    return Container(
                      margin: EdgeInsets.only(right: 20),
                      padding: EdgeInsets.all(20),
                      width: 115,
                      decoration: BoxDecoration(
                          color: HexColor(bucketModel.colour),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        bucketModel.name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                    );
                  }).toList()),
            );
          }
        }));
  }
}
