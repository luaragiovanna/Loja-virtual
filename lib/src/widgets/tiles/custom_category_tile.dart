import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomCategoryTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  //pega a lista de documento (categoria) e manda pro categori tile
  const CustomCategoryTile({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
 
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.get("icon")),
      ),
      title: Text(snapshot.get("title")),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: (){
        
      },
    );
  }
}
