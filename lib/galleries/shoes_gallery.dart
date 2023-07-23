import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../models/product_model.dart';

class ShoesGalleryScreen extends StatefulWidget {
  const ShoesGalleryScreen({super.key});

  @override
  State<ShoesGalleryScreen> createState() => _ShoesGalleryScreenState();
}

class _ShoesGalleryScreenState extends State<ShoesGalleryScreen> {
  final Stream<QuerySnapshot>
      _productsStream = //firestore'a kaydedilen verilerin ekrana aktarımı yapılıyor
      FirebaseFirestore.instance
          .collection('product')
          .where('maincateg', isEqualTo: 'shoes')
          .snapshots();

  @override
  Widget build(BuildContext context) {
    debugPrint(_productsStream.toString());
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        //https://firebase.flutter.dev/docs/firestore/usage#realtime-changes 'ten otomatik eklendi

        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          debugPrint('snapshot : ${snapshot.data!.docs}');
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
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
              staggeredTileBuilder: (context) => const StaggeredTile.fit(
                  1)); //staggeredgridview pubsec_yaml'a eklendi
        },
      ),
    );
  }
}
