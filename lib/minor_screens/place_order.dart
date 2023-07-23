import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_project/minor_screens/payment_screen.dart';
import 'package:flutter_new_project/providers/cart_provider.dart';
import 'package:flutter_new_project/widgets/appbar_widgets.dart';
import 'package:flutter_new_project/widgets/yellow_buton.dart';
import 'package:provider/provider.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  CollectionReference customers = FirebaseFirestore.instance.collection(
      'customers'); // https://firebase.flutter.dev/docs/firestore/usage#one-time-read burdan alındı

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;

    return //futurebuilder...   https://firebase.flutter.dev/docs/firestore/usage#one-time-read burdan alındı
        FutureBuilder<DocumentSnapshot>(
            future: customers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
            //yukarda oluşturulan documentId farklı bir sayfada olduğu için widget. ile aldık
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return const Center(child: Text("Document does not exist"));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Material(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data = snapshot.data!.data() as Map<String,
                    dynamic>; //firestore database'deki en sağdaki haritanın değeri dynamic yani string,int vs
                return Material(
                  color: Colors.grey.shade200,
                  child: SafeArea(
                    child: Scaffold(
                      backgroundColor: Colors.grey.shade200,
                      appBar: AppBar(
                        elevation: 0,
                        backgroundColor: Colors.grey.shade200,
                        leading: const AppBarBackButton(),
                        title: const Text('Place Order'),
                      ),
                      body: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                        child: Column(
                          children: [
                            Container(
                              height: 90,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Name:${data['name']}'),
                                    Text('Phone:${data['phone']}'),
                                    Text('Address:${data['address']}'),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Consumer<Cart>(
                                    builder: (context, cart, child) {
                                  return ListView.builder(
                                      itemCount: cart.count,
                                      itemBuilder: (context, index) {
                                        final order = cart.getItems[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 0.3),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    15),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15)),
                                                    child: SizedBox(
                                                      height: 100,
                                                      width: 100,
                                                      child: Image.network(order
                                                          .imagesUrl.first),
                                                    )),
                                                Flexible(
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      order.name,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey.shade600),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4,
                                                          horizontal: 12),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            order.price
                                                                .toStringAsFixed(
                                                                    2),
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600),
                                                          ),
                                                          Text(
                                                            'x ${order.qty.toString()}',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      bottomSheet: Container(
                          color: Colors.grey.shade200,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: YellowButton(
                              label:
                                  'Confirm ${totalPrice.toStringAsFixed(2)} USD',
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PaymentScreen()));
                              },
                              width: 1,
                            ),
                          )),
                    ),
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
  }
}
