// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:firebase_project_store/src/data/cart_product_data.dart';
import 'package:firebase_project_store/src/models/user/user_model.dart';

class CartModel extends Model {
  UserModel user;
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);
  List<CartProductData> products = [];
  CartModel(
    Object model, {
    required this.user,
    required this.products,
  });

  void addCartItem(CartProductData cartProductData) {
    products.add(cartProductData);
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.user!.uid)
        .collection("cart")
        .add(cartProductData.toMap())
        .then((doc) {
      cartProductData.product_id = doc.id;
    });
    notifyListeners();
  }

  void removeCartItem(CartProductData cartProductData) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user?.firebaseUser?.user?.uid)
        .collection("cart")
        .doc(cartProductData.cart_id)
        .delete();
    products!.remove(cartProductData);
    notifyListeners();
  }
}
