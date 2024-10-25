import 'package:flutter/material.dart';

class CustomDrawerTiles extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController pageController;
  final int page; //qual pag item corresponde

  const CustomDrawerTiles(
      {super.key,
      required this.icon,
      required this.text,
      required this.pageController,
      required this.page});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      //efeito visual ao clicar icone
      child: InkWell(
        onTap: () {
          pageController.jumpToPage(page);
          Navigator.of(context).pop();
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: pageController.page!.round() == page
                    ? Colors.white
                    : Colors.white.withOpacity(0.6),
              ),
              //espaco antes do texto
              const SizedBox(
                width: 32,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: pageController.page!.round() == page
                      ? Colors.white
                      : Colors.white.withOpacity(0.6),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
