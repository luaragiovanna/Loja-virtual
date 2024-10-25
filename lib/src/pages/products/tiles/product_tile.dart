// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_project_store/src/pages/products/pages/product_page.dart';
import 'package:flutter/material.dart';

import 'package:firebase_project_store/src/data/product_data.dart';

class ProductTile extends StatelessWidget {
  final String type;
  final ProductData product;

  const ProductTile({super.key, required this.type, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ProductPage(product, productData: product,)));
      },
      child: Card(
        child: type == "grid"
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 0.9,
                    child: Image.network(
                      product.images[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(0.8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.brown.shade800),
                          ),
                          Text(
                            'R\$ ${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 118, 11, 3),
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Image.network(
                      product.images[0],
                      fit: BoxFit.cover,
                      height: 250.0,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(0.8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.brown.shade800),
                          ),
                          Text(
                            'R\$ ${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 118, 11, 3),
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
