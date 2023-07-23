import 'package:flutter/material.dart';
import 'package:flutter_new_project/categories/accessories_categ.dart';
import 'package:flutter_new_project/categories/bags_categ.dart';
import 'package:flutter_new_project/categories/beauty_category.dart';
import 'package:flutter_new_project/categories/electronics_category.dart';
import 'package:flutter_new_project/categories/home_garden_categ.dart';
import 'package:flutter_new_project/categories/kids_category.dart';
import 'package:flutter_new_project/categories/men_categ.dart';
import 'package:flutter_new_project/categories/shoes_categ.dart';
import 'package:flutter_new_project/categories/women_categ.dart';
import 'package:flutter_new_project/widgets/fake_search.dart';

List<ItemsData> items = [
  ItemsData(label: 'men'),
  ItemsData(label: 'women'),
  ItemsData(label: 'shoes'),
  ItemsData(label: 'bags'),
  ItemsData(label: 'electronics'),
  ItemsData(label: 'accessories'),
  ItemsData(label: 'home & garden'),
  ItemsData(label: 'kids'),
  ItemsData(label: 'beauty'),
];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final PageController _pageController = PageController();
  @override
  void initState() {
    for (var element in items) {
      // category'e geri dönüldüğünde men'i ana sayfada göstermek için
      element.isSelected = false;
    }
    setState(() {
      items[0].isSelected = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const FakeSearch(),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: sideNavigator(size),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: categView(size),
          ),
        ],
      ),
    );
  }

  Widget sideNavigator(Size size) {
    //Yukardaki size'ı çekebilmek için Size size eklendi
    return SizedBox(
      height: size.height * 0.8,
      width: size.width * 0.2,
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _pageController.jumpToPage(index);
                _pageController.animateToPage(index, //Yukardaki ile aynı işlev
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.bounceInOut);
                /*   Yukardakilerle benzer işlev
              
                 for (var element in items) {
                  //Bu döngü sayesinde sadece seçilen kategori beyaz renk alacak
                  element.isSelected = false;
                }
                setState(() {
                  items[index].isSelected = true;
                });
                */
              },
              child: Container(
                  color: items[index].isSelected == true
                      ? Colors.white
                      : Colors.grey.shade300,
                  height: 100,
                  child: Center(child: Text(items[index].label))),
            ); //items sadece String içermediğinden .label eklendi
          }),
    );
  }

  Widget categView(Size size) {
    //Yukardaki size'ı çekebilmek için Size size eklendi
    return Container(
      height: size.height * 0.8,
      width: size.width * 0.8,
      color: Colors.white,
      child: PageView(
          controller: _pageController,
          onPageChanged: (value) {
            for (var element in items) {
              element.isSelected = false;
            }
            setState(() {
              items[value].isSelected = true;
            });
          },
          scrollDirection:
              Axis.vertical, //yukardan aşağı sayfa değiştirmek için
          children: const [
            MenCategory(),
            WomenCategory(),
            ShoesCategory(),
            BagsCategory(),
            ElectronicsCategory(),
            AccessoriesCategory(),
            HomeGardenCategory(),
            KidsCategory(),
            BeautyCategory(),
          ]),
    );
  }
}

class ItemsData {
  String label;
  bool isSelected;
  ItemsData({required this.label, this.isSelected = false});
}
