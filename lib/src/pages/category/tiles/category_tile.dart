import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project_store/src/pages/category/category_page.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  //recebe o odcumento do banco(lista de categoria e manda pra category tile)
  const CategoryTile({super.key, required this.snapshot});
  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Ink.image(
            image: NetworkImage(
              snapshot.get('icon'),
            ),
            height: 120,
            fit: BoxFit.contain,
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                //LOOGICA
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CategoryPage(snapshot: snapshot)));
              },
            ),
          ),
          Text(
            snapshot.get('title'),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          )
        ],
      ),
    );
  }
}
