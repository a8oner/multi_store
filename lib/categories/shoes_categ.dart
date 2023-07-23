import 'package:flutter/material.dart';
import 'package:flutter_new_project/utilities/categ_list.dart';

import '../widgets/categ_widgets.dart';

class ShoesCategory extends StatelessWidget {
  const ShoesCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(children: [
        Positioned(
          bottom: 0,
          left: 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CategHeaderLabel(
                  headerLabel: 'Shoes',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: GridView.count(
                    mainAxisSpacing: 70,
                    crossAxisSpacing: 15,
                    crossAxisCount: 3,
                    children: List.generate(shoes.length - 1, (index) {
                      return SubcategModel(
                        mainCategName: 'shoes',
                        subCategName: shoes[index + 1],
                        assetName: 'images/shoes/shoes$index.jpg',
                        subcategLabel: shoes[index + 1],
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
        ),
        const Positioned(
            right: 0,
            child: SliderBar(
              maincategName: 'shoes',
            )),
      ]),
    );
  }
}
