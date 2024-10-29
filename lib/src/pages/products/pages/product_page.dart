import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:firebase_project_store/src/data/cart_product_data.dart';
import 'package:firebase_project_store/src/data/product_data.dart';
import 'package:firebase_project_store/src/models/cart/cart_model.dart';
import 'package:firebase_project_store/src/models/user/user_model.dart';
import 'package:firebase_project_store/src/pages/cart/cart_page.dart';
import 'package:firebase_project_store/src/pages/login/pages/login_page.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  String? size;
  final ProductData productData;

  ProductPage(ProductData product,
      {super.key, required this.productData, this.size});

  @override
  // ignore: no_logic_in_create_state
  State<ProductPage> createState() => _ProductPageState(productData);
}

class _ProductPageState extends State<ProductPage> {
  final ProductData productData;
  _ProductPageState(this.productData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          productData.title,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: AnotherCarousel(
              images: productData.images.map((url) {
                return NetworkImage(url);
              }).toList(),
              dotSize: 4.0,
              dotColor: Colors.yellow,
              dotSpacing: 15.0,
              dotBgColor: const Color.fromARGB(57, 54, 111, 244),
              autoplay: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  productData.title,
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown),
                ),
                Text(
                  "R\$ ${productData.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      color: const Color.fromARGB(255, 102, 55, 38),
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                const Text(
                  'TAM',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.brown,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 30.0,
                  child: GridView(
                    padding: const EdgeInsets.all(5.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.3),
                    children: productData.sizes.map((s) {
                      //mapeando a lista de string e transformando em outro tipo, no caso e retornando detector
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.size = s;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.5,
                                style: BorderStyle.solid,
                                color: s == widget.size
                                    ? const Color.fromARGB(255, 187, 67, 15)
                                    : Colors.brown.shade700,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              )),
                          width: 70,
                          alignment: Alignment.center,
                          child: Text(
                            s,
                            style: TextStyle(
                                fontSize: 15,
                                color: s == widget.size
                                    ? Colors.red
                                    : Colors.brown),
                          ),
                        ),
                      );
                    }).toList(),
                    //linha
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 50.0,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          disabledBackgroundColor:
                              Colors.brown.shade600.withOpacity(0.6),
                          backgroundColor: Colors.brown.shade900,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)))),
                      onPressed: widget.size != null
                          ? () {
                              if (UserModel.of(context).isLoggedIn()) {
                                //ADD AO CARRINHO
                                CartProductData cartProduct = CartProductData();
                                cartProduct.size = widget.size;
                                cartProduct.product_quantity = 1;
                                cartProduct.product_id = widget.productData.id;
                                cartProduct.category_product =
                                    widget.productData.category;
                                cartProduct.productData = widget.productData;
                                CartModel.of(context).addCartItem(cartProduct);

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const CartPagge()));
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                              }
                            }
                          : null,
                      child: Text(
                        UserModel.of(context).isLoggedIn()
                            ? 'Adicionar ao carrinho'
                            : 'Entre para comprar',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      )),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const Text(
                  'Descrição',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                ),
                Text(
                  productData.description,
                  style: const TextStyle(fontSize: 16.0),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
