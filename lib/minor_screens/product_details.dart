// ignore_for_file: unused_import, no_leading_underscores_for_local_identifiers, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_project/main_screens/cart.dart';
import 'package:flutter_new_project/main_screens/dashboard_screens.dart';
import 'package:flutter_new_project/main_screens/visit_store.dart';
import 'package:flutter_new_project/minor_screens/full_screen_view.dart';
import 'package:flutter_new_project/providers/cart_provider.dart';
import 'package:flutter_new_project/providers/wish_provider.dart';
import 'package:flutter_new_project/widgets/appbar_widgets.dart';
import 'package:flutter_new_project/widgets/snacbar.dart';
import 'package:flutter_new_project/widgets/yellow_buton.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:badges/badges.dart' as badges;

class ProductDetailsScreen extends StatefulWidget {
  final dynamic proList;
  const ProductDetailsScreen({super.key, required this.proList});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  //Swipper pub get ve import edildi
  late final Stream<QuerySnapshot>
      _productsStream = //firestore'a kaydedilen verilerin ekrana aktarımı yapılıyor
      FirebaseFirestore.instance
          .collection('product')
          .where('maincateg', isEqualTo: widget.proList['maincateg'])
          .where('subcateg', isEqualTo: widget.proList['subcateg'])
          .snapshots();

  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late List<dynamic> imagesList = widget.proList['proimages'];
  @override
  Widget build(BuildContext context) {
    var onSale = widget.proList['discount'];
    //Swipper pub get ve import edildi
    var existingItemCart = context.read<Cart>().getItems.firstWhereOrNull(
        //is it avaliable or not
        (product) => product.documentId == widget.proList['proid']);
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: scaffoldKey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullScreenView(
                                    imagesList: imagesList,
                                  )));
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Swiper(
                              pagination: const SwiperPagination(
                                  builder: SwiperPagination.fraction),
                              itemBuilder: (context, index) {
                                return Image(
                                    image: NetworkImage(imagesList[index]));
                              },
                              itemCount: imagesList.length),
                        ),
                        Positioned(
                            left: 15,
                            top: 20,
                            child: CircleAvatar(
                              backgroundColor: Colors.yellow,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.black,
                                  )),
                            )),
                        Positioned(
                            right: 15,
                            top: 20,
                            child: CircleAvatar(
                              backgroundColor: Colors.yellow,
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.share,
                                    color: Colors.black,
                                  )),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.proList['proname'],
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'USD',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.proList['price'].toStringAsFixed(2),
                            style: onSale != 0
                                ? const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.bold)
                                : const TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          onSale != 0
                              ? Text(
                                  ((1 - (widget.proList['discount'] / 100)) *
                                          widget.proList['price'])
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              : const Text(''),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          var existingItemWishlist = context
                              .read<Wish>()
                              .getWishItems
                              .firstWhereOrNull(
                                  //is it avaliable or not
                                  (product) =>
                                      product.documentId ==
                                      widget.proList['proid']);
                          existingItemWishlist != null
                              ? context
                                  .read<Wish>()
                                  .removeThis(widget.proList['proid'])
                              : context.read<Wish>().addWishItem(
                                    widget.proList['proname'],
                                    onSale != 0
                                        ? ((1 -
                                                (widget.proList['discount'] /
                                                    100)) *
                                            widget.proList['price'])
                                        : widget.proList['price'],
                                    1,
                                    widget.proList['instock'],
                                    widget.proList['proimages'],
                                    widget.proList['proid'],
                                    widget.proList['sid'],
                                  );
                        },
                        icon: context
                                    .watch<Wish>()
                                    .getWishItems
                                    .firstWhereOrNull(
                                        //read>watch'a çevrildi read çalışmadı
                                        //is it avaliable or not
                                        (product) =>
                                            product.documentId ==
                                            widget.proList['proid']) !=
                                null
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 30,
                              )
                            : const Icon(
                                Icons.favorite_outline,
                                color: Colors.red,
                                size: 30,
                              ),
                      )
                    ],
                  ),
                  widget.proList['instock'] == 0
                      ? const Text(
                          'this item is out of stock',
                          style:
                              TextStyle(fontSize: 16, color: Colors.blueGrey),
                        )
                      : Text(
                          (widget.proList['instock'].toString()) +
                              (' pieces available in stock'),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.blueGrey),
                        ),
                  const ProDetailsHeader(label: '  Item description  '),
                  Text(
                    widget.proList['prodesc'],
                    textScaleFactor: 1.1,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey.shade800),
                  ),
                  const ProDetailsHeader(
                    label: 'Similar Items',
                  ),
                  SizedBox(
                    child: StreamBuilder<QuerySnapshot>(
                      //https://firebase.flutter.dev/docs/firestore/usage#realtime-changes 'ten otomatik eklendi

                      stream: _productsStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        debugPrint('snapshot : ${snapshot.data!.docs}');
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                              'This category \n\n has no items yet',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 26,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Acme',
                                letterSpacing: 1.5,
                              ),
                            ),
                          );
                        }
                        return StaggeredGridView.countBuilder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            crossAxisCount: 2,
                            itemBuilder: (context, index) {
                              return ProductModel(
                                products: snapshot.data!.docs[index],
                              );
                            },
                            staggeredTileBuilder: (context) =>
                                const StaggeredTile.fit(
                                    1)); //staggeredgridview pubsec_yaml'a eklendi
                      },
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VisitStore(
                                        suppId: widget.proList['sid'])));
                          },
                          icon: const Icon(Icons.store)),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CartScreen(
                                          back: AppBarBackButton(),
                                        )));
                          },
                          icon: Padding(
                            padding: const EdgeInsets.all(2),
                            child: badges.Badge(
                                showBadge: context.read<Cart>().getItems.isEmpty
                                    ? false
                                    : true,
                                badgeContent: Text(
                                  context
                                      .watch<Cart>()
                                      .getItems
                                      .length
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                child: const Icon(
                                  Icons.shopping_cart,
                                )),
                          )),
                    ],
                  ),
                  YellowButton(
                      label: existingItemCart != null
                          ? 'added to cart'
                          : 'ADD TO CART',
                      onPressed: () {
                        try {
                          if (widget.proList['instock'] == 0) {
                            MyMessageHandler.showSnackBar(
                                scaffoldKey, 'this item is out of stock');
                          } else if (existingItemCart != null) {
                            MyMessageHandler.showSnackBar(
                                scaffoldKey, 'this item already in cart');
                          } else {
                            context.read<Cart>().addItem(
                                  widget.proList['proname'],
                                  onSale != 0
                                      ? ((1 -
                                              (widget.proList['discount'] /
                                                  100)) *
                                          widget.proList['price'])
                                      : widget.proList['price'],
                                  1,
                                  widget.proList['instock'],
                                  widget.proList['proimages'],
                                  widget.proList['proid'],
                                  widget.proList['sid'],
                                );
                          }
                        } catch (e) {
                          debugPrint('karta eklemede hata $e');
                        }
                      },
                      width: 0.5)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProDetailsHeader extends StatelessWidget {
  final String label;
  const ProDetailsHeader({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
          Text(
            label,
            style: TextStyle(
                color: Colors.yellow.shade900,
                fontSize: 24,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900, //ÇİZGİDİR
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
