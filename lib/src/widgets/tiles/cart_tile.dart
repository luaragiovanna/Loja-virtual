import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project_store/src/data/cart_product_data.dart';
import 'package:firebase_project_store/src/data/product_data.dart';
import 'package:firebase_project_store/src/models/cart/cart_model.dart';
import 'package:flutter/material.dart';

class CartTile extends StatelessWidget {
  final CartProductData cartProductData;

  const CartTile(CartProductData product,
      {super.key, required this.cartProductData});

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      CartModel.of(context).updatePrices();
      return Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            width: 120,
            child: Image.network(
              cartProductData.productData!.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  cartProductData!.productData!.title,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                ),
                Text(
                  'Tamanho: ${cartProductData!.size}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                    'R\$ ${cartProductData!.productData!.price.toStringAsFixed(2)}'),
                Row(
                  children: [
                    IconButton(
                        onPressed: cartProductData.product_quantity! > 1
                            ? () {
                                CartModel.of(context)
                                    .decProduct(cartProductData);
                              }
                            : null,
                        icon: Icon(Icons.remove)),
                    Text(cartProductData!.product_quantity.toString()),
                    IconButton(
                      onPressed: () {
                        CartModel.of(context).incProduct(cartProductData);
                      },
                      icon: Icon(Icons.add),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                        ),
                        onPressed: () {
                          CartModel.of(context).removeCartItem(cartProductData);
                        },
                        child: Text(
                          'Remover',
                          style: TextStyle(
                            color: Colors.grey.shade300,
                          ),
                        ))
                  ],
                )
              ],
            ),
          ))
        ],
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      //se snapshot ocontem dado, armazena no cart product
      child: cartProductData!.productData == null
          ? FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("products")
                  .doc(cartProductData.category_product)
                  .collection("items")
                  .doc(cartProductData.product_id)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  cartProductData.productData =
                      ProductData.fromDocument(snapshot.data!);
                  return _buildContent();
                } else {
                  return Container(
                    height: 70,
                    child: const CircularProgressIndicator(),
                    alignment: Alignment.center,
                  );
                }
              },
            )
          : _buildContent(),
    );
  }
}
