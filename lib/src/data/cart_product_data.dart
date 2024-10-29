// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_project_store/src/data/product_data.dart';

class CartProductData {
  String? cart_id; // Agora deve ser inicializado antes do uso
  String? category_product;
  String? product_id;
  int? product_quantity;
  String? size;
  ProductData? productData;
  CartProductData();

  CartProductData.fromDocument(DocumentSnapshot document) {
    cart_id = document.id; // Agora isso é seguro
    category_product = document["category"];
    product_id = document["product_id"];
    product_quantity = document["product_quantity"];
    size = document["size"];
  }

  Map<String, dynamic> toMap() {
    return {
      "category": category_product,
      "product_id": product_id,
      "product_quantity": product_quantity,
      "size": size,
      "product": productData?.toResumeMap(),
    };
  }
}
