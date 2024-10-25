// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  late String category;
  late String id;
  late String title;
  late String description;
  late double price;
  late List images;
  late List sizes;

  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    title = snapshot.get('title');
    description = snapshot.get('description');
    price = snapshot.get('price');
    images = snapshot.get('images');
    sizes = snapshot.get('size');
  }

  Map<String, dynamic> toResumeMap() {
    //info do pedido
    return {
      "title": title,
      "description": description,
      "price": price,
    };
  }
}
