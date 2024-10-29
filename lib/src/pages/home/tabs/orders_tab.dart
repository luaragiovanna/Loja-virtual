import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project_store/src/models/user/user_model.dart';
import 'package:firebase_project_store/src/pages/login/pages/login_page.dart';
import 'package:firebase_project_store/src/widgets/tiles/order_tile.dart';
import 'package:flutter/material.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    //verificar se ta logado ou n
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser!.user!.uid;
      return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection("orders")
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                children: snapshot.data!.docs
                    .map((doc) => OrderTile(
                          orderId: doc.id,
                        ))
                    .toList().reversed.toList(),
              );
            }
          });
      //carrega pedido do usuario
    } else {
      //mostra q n tem pedidos igual do carrinho
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.view_list,
              size: 80,
              color: Colors.brown.withOpacity(0.6),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Faça login para acessar seus pedidos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade500,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text(
                  'Entrar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ))
          ],
        ),
      );
    }
  }
}
