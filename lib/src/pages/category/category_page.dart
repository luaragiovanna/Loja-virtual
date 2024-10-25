import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project_store/src/data/product_data.dart';
import 'package:firebase_project_store/src/pages/products/tiles/product_tile.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const CategoryPage({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      //numero de tabs
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            snapshot.get('title'),
            style: const TextStyle(
                color: Color.fromARGB(255, 84, 43, 29),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.grid_on),
              ),
              Tab(
                icon: Icon(Icons.list),
              ),
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection("products")
              .doc(snapshot.id)
              .collection("items")
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  // oq  mostrar em cada uma das trabs
                  children: [
                    GridView.builder(
                      padding: EdgeInsets.all(4.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                              childAspectRatio:
                                  0.75), //qtds items tem na horizontal
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        ProductData data = ProductData.fromDocument(
                            snapshot.data!.docs[index]);
                        data.category = this.snapshot.id;
                        return ProductTile(type: "grid", product: data);
                      },
                    ),
                    ListView.builder(
                        padding: EdgeInsets.all(4.0),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          ProductData data = ProductData.fromDocument(
                              snapshot.data!.docs[index]);
                          data.category = this.snapshot.id;
                          return ProductTile(
                            type: "list",
                            product: data,
                          );
                        })
                  ]);
            }
          },
        ),
      ),
    );
  }
}
