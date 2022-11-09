import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_organiser/models/BucketModel.dart';
import 'dart:math' as math;

class BucketList extends StatefulWidget {
  const BucketList({super.key, required this.uid});

  final String uid;

  @override
  State<BucketList> createState() => _BucketListState();
}

class _BucketListState extends State<BucketList> {
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

          return ListView(
              scrollDirection: Axis.horizontal,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                BucketModel bucketModel = BucketModel.fromMap(data);

                return Container(
                  margin: EdgeInsets.only(right: 20),
                  padding: EdgeInsets.all(20),
                  child: Center(
                      child: Text(
                    bucketModel.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )),
                  width: 115,
                  decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent,
                      borderRadius: BorderRadius.circular(10)),
                );
              }).toList());
        }));
  }
}
