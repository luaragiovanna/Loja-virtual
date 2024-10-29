import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  final String orderId;
  const OrderPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pedidor realizado'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check,
                color: Colors.green,
              ),
              Text(
                'Pediido realizado com sucesso',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              Text(
                'Codigo do pedido $orderId',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ));
  }
}
