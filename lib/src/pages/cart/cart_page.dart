import 'package:firebase_project_store/src/models/cart/cart_model.dart';
import 'package:firebase_project_store/src/models/user/user_model.dart';
import 'package:firebase_project_store/src/pages/login/pages/login_page.dart';
import 'package:firebase_project_store/src/pages/order/order_page.dart';
import 'package:firebase_project_store/src/widgets/cart/cart_price.dart';
import 'package:firebase_project_store/src/widgets/cart/discount_card.dart';
import 'package:firebase_project_store/src/widgets/cart/ship_card.dart';
import 'package:firebase_project_store/src/widgets/tiles/cart_tile.dart';
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
          ),
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isLoggedIn()) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart_rounded,
                    size: 80.0,
                    color: Colors.brown.withOpacity(0.5),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Faça login para adicionar itens em seu carrinho!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown.shade600),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: const Text(
                      'Entrar',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )
                ],
              ),
            );
          } else if (model.products == null || model.products.length == 0) {
            return const Center(
              child: Center(
                child: Text(
                  'Nenhum produto no carrinho',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView(
            children: <Widget>[
              Column(
                children: model.products.map((product) {
                  return CartTile(
                    product,
                    cartProductData: product,
                  );
                }).toList(), //transformando cada um dos produtos da lista em CARTILE
              ),
              const DiscountCard(),
              const ShipCard(),
              CartPrice(
                buy: () async {
                  String? orderId = await model.finishOrder(); //retorna id
                  if (orderId != null) {
                    print(orderId);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => OrderPage(orderId: orderId)));
                  }
                },
              ),
            ],
          );

          // se user n logado
          //carrinho vazio
        },
      ),
    );
  }
}
