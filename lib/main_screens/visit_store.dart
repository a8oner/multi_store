// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_project/models/product_model.dart';
import 'package:flutter_new_project/widgets/appbar_widgets.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VisitStore extends StatefulWidget {
  final String suppId;
  const VisitStore({super.key, required this.suppId});

  @override
  State<VisitStore> createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {
  bool following = false;
  @override
  Widget build(BuildContext context) {
    //https://firebase.flutter.dev/docs/firestore/usage#one-time-read  burdan alındı
    CollectionReference suppliers =
        FirebaseFirestore.instance.collection('suppliers');

    final Stream<QuerySnapshot>
        _productsStream = //firestore'a kaydedilen verilerin ekrana aktarımı yapılıyor
        FirebaseFirestore.instance
            .collection('product')
            .where('sid', isEqualTo: widget.suppId)
            .snapshots();

    return FutureBuilder<DocumentSnapshot>(
      future: suppliers.doc(widget.suppId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.blueGrey.shade100,
            appBar: AppBar(
              toolbarHeight: 100,
              flexibleSpace: Image.asset(
                'images/inapp/coverimage.jpg',
                fit: BoxFit.cover,
              ),
              leading: const YellowBackButton(),
              title: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.yellow),
                        borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.network(
                        data['storeLogo'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(data['storeName'].toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.yellow)),
                              ),
                            ],
                          ),
                          data['sid'] == FirebaseAuth.instance.currentUser!.uid
                              ? Container(
                                  height: 35,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      border: Border.all(
                                          width: 3, color: Colors.black),
                                      borderRadius: BorderRadius.circular(25)),
                                  child: MaterialButton(
                                    onPressed: () {},
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text('Edit'),
                                        Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        )
                                      ],
                                    ),
                                  ))
                              : Container(
                                  height: 35,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      border: Border.all(
                                          width: 3, color: Colors.black),
                                      borderRadius: BorderRadius.circular(25)),
                                  child: MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        following = !following;
                                      });
                                    },
                                    child: following == true
                                        ? const Text('following')
                                        : const Text('FOLLOW'),
                                  ))
                        ]),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                //https://firebase.flutter.dev/docs/firestore/usage#realtime-changes 'ten otomatik eklendi

                stream: _productsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        'This Store \n\n has no items yet',
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.green,
              child: const Icon(
                FontAwesomeIcons.whatsapp, //fontawesome pub.get edildi
                color: Colors.white,
                size: 40,
              ),
            ),
          );
        }

        return const Text("loading");
      },
    );
  }
}
