// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:firebase_project_store/src/data/cart_product_data.dart';
import 'package:firebase_project_store/src/models/user/user_model.dart';

class CartModel extends Model {
  String? couponCode;
  int? discountPercentage = 0;

  UserModel user;
  bool isLoading = false;

  List<CartProductData> products = [];
  CartModel(this.user, {required List products, required bool isLoading}) {
    if (user.isLoggedIn()) {
      _loadCartItems();
    }
    ;
  }
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

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
        .doc(user.firebaseUser!.user!.uid)
        .collection("cart")
        .doc(cartProductData.cart_id)
        .delete();
    products!.remove(cartProductData);
    notifyListeners();
  }

  void decProduct(CartProductData cartProduct) {
    cartProduct.product_quantity = (cartProduct.product_quantity ?? 0) - 1;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.user!.uid)
        .collection("cart")
        .doc(cartProduct.cart_id)
        .get()
        .then((doc) {
      if (doc.exists) {
        // Atualizar o documento
        doc.reference.update(cartProduct.toMap());
      } else {
        // O documento não existe, você pode adicionar um novo
        FirebaseFirestore.instance
            .collection("users")
            .doc(user.firebaseUser!.user!.uid)
            .collection("cart")
            .add(cartProduct.toMap());
      }
    });
  }

  void incProduct(CartProductData cartProduct) async {
    cartProduct.product_quantity = (cartProduct.product_quantity ?? 0) + 1;

    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.user!.uid)
        .collection("cart")
        .doc(cartProduct.cart_id);

    // Verifica se o documento existe
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      // Atualiza o documento existente
      docRef.update(cartProduct.toMap());
    } else {
      // Se não existir, você pode criá-lo
      await docRef.set(cartProduct.toMap());
    }
  }

  void _loadCartItems() async {
    //obtendo todos os documentos
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.user!.uid)
        .collection("cart")
        .get();

    //config listas produtos
    products = query.docs
        .map((doc) => CartProductData.fromDocument(doc))
        .toList(); //transformando cada documento do firebase em cartProduct e coloca numa lsita
    notifyListeners();
  }

  void setCoupon(String? couponCode, int percent) {
    this.couponCode = couponCode;
    this.discountPercentage = percent;
  }

  double getProductsPrice() {
    //retornar subtotal
    double price = 0.0;
    for (CartProductData c in products) {
      if (c.productData != null) {
        price += (c.product_quantity! * c.productData!.price);
      }
    }
    return price;
  }

  double getShipPrice() {
    //retornar valor da entrega
    return 20;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage! / 100;
  }

  void updatePrices() {
    notifyListeners();
  }

  Future<String?> finishOrder() async {
    if (products.length == 0) return null;
    isLoading = true;
    notifyListeners();
    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();
    DocumentReference refOrder =
        await FirebaseFirestore.instance.collection("orders").add({
      //add pedido na colecao order e obtem uma ref pra ter o id pra salvar
      "clientId": user.firebaseUser!.user!.uid,
      "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
      "shipPrice": shipPrice,
      "productsPrice": productsPrice,
      "discount": discount,
      "totalPrice": productsPrice - discount + shipPrice,
      "status": 1
    });
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.user!.uid)
        .collection("orders")
        .doc(refOrder.id)
        .set(
      {
        "orderId": refOrder.id, //salvando order id dentro do user
      },
    );
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.user!.uid)
        .collection("cart")
        .get();
    for (DocumentSnapshot doc in query.docs) {
      //cada um do produto do carrinho e pega ref de deleta
      doc.reference.delete();
    }
    products.clear();
    discountPercentage = 0;
    couponCode = null;
    isLoading = false;
    notifyListeners();
    return refOrder.id;
  }
}
