import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project_store/src/models/cart/cart_model.dart';
import 'package:flutter/material.dart';

class ShipCard extends StatelessWidget {
  const ShipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: const Text(
          'Calcular frete',
          textAlign: TextAlign.start,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        leading: const Icon(Icons.location_city),
        
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite seu CEP',
              ),
              initialValue: "",
              onFieldSubmitted: (text) {
                

              },
            ),
          )
        ],
      ),
    );
  }
}
