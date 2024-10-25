import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project_store/src/pages/category/tiles/category_tile.dart';
import 'package:firebase_project_store/src/widgets/tiles/custom_category_tile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class ProductsTab extends StatelessWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("products").get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView(
            //categorias com nome e icone
            children: snapshot.data!.docs.map(
              (doc) {
                return CategoryTile(snapshot: doc);
              },
            ).toList(),
          );
        }
      },
    );
  }
}
