import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';


class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() {
      //cria fundo cm degrade
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 77, 41, 18),
              Color.fromARGB(255, 117, 71, 43),
              Color.fromARGB(255, 134, 92, 67),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      );
    }

    return Stack(
      children: [
        _buildBodyBack(),
        CustomScrollView(
          slivers: [
            const SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Color.fromARGB(74, 200, 166, 93),
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Virtual Store',
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
              ),
            ),
            //future n obtem dados instantaneamente
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection("images")
                  .orderBy("pos")
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),
                  );
                } else {
                  return SliverToBoxAdapter(
                    child: GridView.custom(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverQuiltedGridDelegate(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        repeatPattern: QuiltedGridRepeatPattern.inverted,
                        pattern: const [
                          QuiltedGridTile(2, 2),
                          QuiltedGridTile(1, 1),
                        ],
                      ),
                      childrenDelegate: SliverChildBuilderDelegate(
                        (context, index) => FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: snapshot.data!.docs[index]['image'],
                          fit: BoxFit.cover,
                        ),
                        childCount: snapshot.data!.docs.length,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        )
      ],
    );
  }
}
