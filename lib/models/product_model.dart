// ignore_for_file: depend_on_referenced_packages, prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_project/minor_screens/product_details.dart';
import 'package:provider/provider.dart';

import '../providers/wish_provider.dart';
import 'package:collection/collection.dart';

class ProductModel extends StatefulWidget {
  final dynamic
      products; //Padding extract edildikten sonra çıkan hata sonrası oluşturuldu
  const ProductModel({
    super.key,
    required this.products,
  });

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    var onSale = widget.products['discount'];
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                      proList: widget.products,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: Container(
                      constraints:
                          const BoxConstraints(minHeight: 100, maxHeight: 250),
                      child: Image(
                          image: NetworkImage(widget.products['proimages'][0])),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: Column(
                          children: [
                            Text(
                              widget.products['proname'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '\$' +
                                          widget.products['price']
                                              .toStringAsFixed(2),
                                      style: onSale != 0
                                          ? const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontWeight: FontWeight.bold)
                                          : const TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    onSale != 0
                                        ? Text(
                                            '\$' +
                                                ((1 -
                                                            (widget.products[
                                                                    'discount'] /
                                                                100)) *
                                                        widget
                                                            .products['price'])
                                                    .toStringAsFixed(2),
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : const Text(''),
                                  ],
                                ),
                                widget.products['sid'] ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.red,
                                        ))
                                    : IconButton(
                                        onPressed: () {
                                          var existingItemWishlist = context
                                              .read<Wish>()
                                              .getWishItems
                                              .firstWhereOrNull(
                                                  //is it avaliable or not
                                                  (product) =>
                                                      product.documentId ==
                                                      widget.products['proid']);
                                          existingItemWishlist != null
                                              ? context.read<Wish>().removeThis(
                                                  widget.products['proid'])
                                              : context
                                                  .read<Wish>()
                                                  .addWishItem(
                                                    widget.products['proname'],
                                                    onSale != 0
                                                        ? ((1 -
                                                                (widget.products[
                                                                        'discount'] /
                                                                    100)) *
                                                            widget.products[
                                                                'price'])
                                                        : widget
                                                            .products['price'],
                                                    1,
                                                    widget.products['instock'],
                                                    widget
                                                        .products['proimages'],
                                                    widget.products['proid'],
                                                    widget.products['sid'],
                                                  );
                                        },
                                        icon: context
                                                    .watch<Wish>()
                                                    .getWishItems
                                                    .firstWhereOrNull(
                                                        //read>watch'a çevrildi read çalışmadı
                                                        //is it avaliable or not
                                                        (product) =>
                                                            product
                                                                .documentId ==
                                                            widget.products[
                                                                'proid']) !=
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
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
            onSale != 0
                ? Positioned(
                    top: 30,
                    left: 0,
                    child: Container(
                      height: 25,
                      width: 80,
                      decoration: const BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15))),
                      child: Center(
                        child: Text(
                            'Save ${widget.products['discount'].toString()}%'),
                      ),
                    ))
                : Container(
                    color: Colors.transparent,
                  )
          ],
        ),
      ),
    );
  }
}
