import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_project_store/src/models/user/user_model.dart';
import 'package:firebase_project_store/src/pages/login/pages/login_page.dart';
import 'package:firebase_project_store/src/widgets/tiles/custom_drawer_tiles.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  const CustomDrawer({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          //cria fundo cm degrade

          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 192, 131, 88),
                Color.fromARGB(255, 203, 170, 107),
                Color.fromARGB(201, 221, 192, 135),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        );
    return Drawer(
      child: Stack(
        children: [
          _buildDrawerBack(),
          ListView(
            padding: const EdgeInsets.only(left: 25.0, top: 20.0),
            children: [
              //CONTAUDOS DA LISTA
              //HEADER DO TITULO
              Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 16.0, 4.0),
                height: 170.0,
                child: Stack(
                  children: [
                    const Positioned(
                      top: 6.0,
                      left: 0.0,
                      child: Text(
                        'Virtual Store \n By Fulanos',
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(97, 54, 2, 1)),
                      ),
                    ),
                    Positioned(
                        left: 0.0,
                        bottom: 2.0,
                        child: ScopedModelDescendant<UserModel>(
                            builder: (context, child, model) {
                          print(model.isLoggedIn());
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Olá, ${model.isLoggedIn() ? model.userData["name"] : ""}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color.fromRGBO(97, 54, 2, 1)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (!model.isLoggedIn()) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
                                    );
                                  } else {
                                    {
                                      model.signOut();
                                    }
                                  }
                                  ;
                                },
                                child: Text(
                                  !model.isLoggedIn()
                                      ? 'Entre ou cadastre-se'
                                      : 'Sair',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              )
                            ],
                          );
                        }))
                  ],
                ),
              ),
              const Divider(
                color: Color.fromARGB(97, 255, 255, 255),
                thickness: 0.2,

                //linha
              ),
              CustomDrawerTiles(
                icon: Icons.home,
                text: 'Início',
                pageController: pageController,
                page: 0,
              ),
              CustomDrawerTiles(
                icon: Icons.addchart,
                text: 'Produtos',
                pageController: pageController,
                page: 1,
              ),
              CustomDrawerTiles(
                icon: Icons.store_mall_directory,
                text: 'Lojas',
                pageController: pageController,
                page: 2,
              ),
              CustomDrawerTiles(
                icon: Icons.playlist_add_check,
                text: 'Meus pedidos',
                pageController: pageController,
                page: 3,
              ),
            ],
          )
        ],
      ),
    );
  }
}
