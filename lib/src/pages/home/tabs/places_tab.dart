import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project_store/src/widgets/tiles/places_tile.dart';
import 'package:flutter/material.dart';

class PlacesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("places").get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          return ListView(
            children: snapshot.data!.docs
                .map((doc) => PlacesTile(
                      snapshot: doc,
                    ))
                .toList(),
          );
        }
      },
    );
  }
}
