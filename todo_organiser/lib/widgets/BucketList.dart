import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_organiser/misc/HexColor.dart';
import 'package:todo_organiser/models/BucketModel.dart';

import '../models/TaskModel.dart';

class BucketList extends StatefulWidget {
  const BucketList({super.key, required this.uid, required this.isVertical});

  final String uid;
  final bool isVertical;

  @override
  State<BucketList> createState() => _BucketListState();
}

class _BucketListState extends State<BucketList> {
  // Method to handle bucket assignment (Firebase calls are made here)
  Future assignBucket(TaskModel taskModel, BucketModel bucketModel) async {
    // Get task document and update the bucket ID property
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection("Tasks")
            .doc(taskModel.tid)
            .update({"bucket": bucketModel.bid});
      } catch (e) {
        print(e);
      } finally {}
    }
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
                    BucketModel bucketModel =
                        BucketModel.fromMap(data, document.id);

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
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
                    BucketModel bucketModel =
                        BucketModel.fromMap(data, document.id);

                    return DragTarget<TaskModel>(
                      builder: (context, candidateData, rejectedData) {
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
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          )),
                        );
                      },
                      onWillAccept: (data) {
                        return true;
                      },
                      onAccept: (data) {
                        print('on Accept');
                        assignBucket(data, bucketModel);
                      },
                    );
                  }).toList()),
            );
          }
        }));
  }
}
