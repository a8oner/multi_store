// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_new_project/providers/product_class.dart';
import 'package:flutter_new_project/providers/wish_provider.dart';
import 'package:flutter_new_project/widgets/appbar_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/wish_model.dart';
import '../providers/cart_provider.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/yellow_buton.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({
    super.key,
  });

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: const AppBarBackButton(),
            title: const AppBarTitle(title: 'Wishlist'),
            actions: [
              context.watch<Wish>().getWishItems.isEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        MyAlertDialog.showMyDialog(
                            context: context,
                            title: 'Clear Wishlist',
                            content: 'Are you sure to clear Wishlist',
                            tabNo: () {
                              Navigator.pop(context);
                            },
                            tabYes: () {
                              context.read<Wish>().clearWishlist(); //provider
                              Navigator.pop(context);
                            });
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                      )),
            ],
          ),

          //provider pub get edildi.we used provider at the bottom
          body: context.watch<Wish>().getWishItems.isNotEmpty
              ? const WishItems() //main.dart'a provider eklemesi yapıldı

              : const EmptyWishlist(),
        ),
      ),
    );
  }
}

class EmptyWishlist extends StatelessWidget {
  const EmptyWishlist({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Your Wishlist Is Empty',
          style: TextStyle(fontSize: 30),
        ),
      ]),
    );
  }
}

class WishItems extends StatelessWidget {
  const WishItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Wish>(
      builder: (context, wish, child) {
        return ListView.builder(
            itemCount: wish.getWishItems.length,
            itemBuilder: (context, index) {
              final product = wish.getWishItems[index];
              return WishlistModel(product: product);
            });
      },
    );
  }
}
