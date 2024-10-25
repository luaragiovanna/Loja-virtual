import 'package:firebase_project_store/src/pages/home/tabs/home_tab.dart';
import 'package:firebase_project_store/src/pages/products/tab/products_tab.dart';
import 'package:firebase_project_store/src/widgets/cart/cart_widget_button.dart';
import 'package:firebase_project_store/src/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final _pageController = PageController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          body: const HomeTab(), //page  0
          drawer: CustomDrawer(
            pageController: _pageController,
          ),
          floatingActionButton: CartWidgetButton(),
        ),
        Scaffold(
          //page 1
          appBar: AppBar(
            title: const Text(
              'Produtos',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          drawer: CustomDrawer(pageController: _pageController),
          body: const ProductsTab(),
          floatingActionButton: CartWidgetButton(),
        ),
        Container(
          color: Colors.red,
        ),
        Container(
          color: Colors.black,
        )
      ],
    );
  }
}
