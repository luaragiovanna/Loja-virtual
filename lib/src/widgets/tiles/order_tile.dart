import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final String orderId;

  const OrderTile({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("orders")
                .doc(orderId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                int status = snapshot.data!["status"];
                //stream builder tem conteudo retornar
                return Column(
                  children: [
                    Text(
                      'Codigo do pedido: ${snapshot.data!.id}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      _buildProductsText(snapshot.data),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCircle("1", "Preparando", status, 1),
                        Container(
                          height: 1.0,
                          width: 4.0,
                          color: Colors.grey,
                        ),
                        _buildCircle("2", "Transporte", status, 2),
                        Container(
                          height: 1.0,
                          width: 4.0,
                          color: Colors.grey,
                        ),
                        _buildCircle("3", "Entrega", status, 3),
                      ],
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }

  String _buildProductsText(DocumentSnapshot<Object?>? snapshot) {
    String text = "Descrição\n";
    for (LinkedHashMap p in snapshot!.get("products")) {
      text +=
          "${p["quantity"]}  x  ${p["products"]["title"]} (R\$ ${p["product"]["price"].toString()})\n";
    }
    text += "Total: R\$ ${snapshot.get("totalPrice").toString()}";
    return text;
  }

  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    Color backColor = Colors.white;
    Widget child;
    if (status < thisStatus) {
      backColor = Colors.grey;
      child = Text(
        title,
        style: TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      child = Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(
        Icons.check,
        color: Colors.white,
      );
    }
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: backColor,
          child: Text(subtitle),
        ),
      ],
    );
  }
}
