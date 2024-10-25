import 'package:firebase_project_store/src/pages/cart/cart_page.dart';
import 'package:flutter/material.dart';

class CartWidgetButton extends StatelessWidget {
  const CartWidgetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CartPagge(),
          ),
        );
        
      },
      backgroundColor: Colors.brown,
      
    );
  }
}
