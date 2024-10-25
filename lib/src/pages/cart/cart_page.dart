import 'package:firebase_project_store/src/models/cart/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPagge extends StatelessWidget {
  const CartPagge({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Meu carrinho"),
        actions: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 10.0),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int p = model.products.length; //qnt de produto
                return Text('${p ?? 0} ${p == 1 ? "Item" : "Itens"}');
              },
            ),
          )
        ],
      ),
    );
  }
}
