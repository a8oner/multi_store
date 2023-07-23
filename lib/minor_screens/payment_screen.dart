/*
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [
        BackButton(),
      ]),
      body: Container(
        color: Colors.red,
      ),
    );
  }
}
*/

// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, use_build_context_synchronously, unused_import, deprecated_member_use

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_project/providers/cart_provider.dart';
import 'package:flutter_new_project/widgets/appbar_widgets.dart';
import 'package:flutter_new_project/widgets/yellow_buton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedValue = 1;
  late String orderId;
  CollectionReference customers = FirebaseFirestore.instance.collection(
      'customers'); // https://firebase.flutter.dev/docs/firestore/usage#one-time-read burdan alındı

  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: 'please wait..', progressBgColor: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    double totalPaid = context.watch<Cart>().totalPrice + 10.0;

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
                        title: const Text('Payment'),
                      ),
                      body: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                        child: Column(
                          children: [
                            Container(
                              height: 120,
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Total',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          '${totalPaid.toStringAsFixed(2)} USD',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Total order',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        Text(
                                          '${totalPrice.toStringAsFixed(2)} USD',
                                          style: const TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Shipping Coast',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        Text(
                                          '10.00' + ('USD'),
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                      ],
                                    ),
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
                                child: Column(
                                  children: [
                                    RadioListTile(
                                      value: 1,
                                      groupValue: selectedValue,
                                      onChanged: (int? value) {
                                        setState(() {
                                          selectedValue = value!;
                                        });
                                      },
                                      title: const Text('Cash On Delivery'),
                                      subtitle: const Text('Pay Cash At Home'),
                                    ),
                                    RadioListTile(
                                      value: 2,
                                      groupValue: selectedValue,
                                      onChanged: (int? value) {
                                        setState(() {
                                          selectedValue = value!;
                                        });
                                      },
                                      title: const Text(
                                          'Pay via visa / Master Card'),
                                      subtitle: const Row(
                                        children: [
                                          Icon(
                                            Icons.payment,
                                            color: Colors.blue,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Icon(
                                              FontAwesomeIcons.ccMastercard,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          Icon(
                                            FontAwesomeIcons.ccVisa,
                                            color: Colors.blue,
                                          ),
                                        ],
                                      ),
                                    ),
                                    RadioListTile(
                                      value: 3,
                                      groupValue: selectedValue,
                                      onChanged: (int? value) {
                                        setState(() {
                                          selectedValue = value!;
                                        });
                                      },
                                      title: const Text('Pay via Paypal'),
                                      subtitle: const Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.paypal,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Icon(
                                            FontAwesomeIcons.ccPaypal,
                                            color: Colors.blue,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
                                  'Confirm ${totalPaid.toStringAsFixed(2)} USD',
                              onPressed: () async {
                                if (selectedValue == 1) {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) => SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  'Pay At Home ${totalPaid.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                      fontSize: 24),
                                                ),
                                                YellowButton(
                                                    label:
                                                        'Confirm ${totalPaid.toStringAsFixed(2)}',
                                                    onPressed: () async {
                                                      showProgress();
                                                      for (var item in context
                                                          .read<Cart>()
                                                          .getItems) {
                                                        CollectionReference
                                                            orderRef =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'orders');
                                                        orderId =
                                                            const Uuid().v4();
                                                        await orderRef
                                                            .doc(orderId)
                                                            .set({
                                                          'cid': data['cid'],
                                                          'custname':
                                                              data['name'],
                                                          'email':
                                                              data['email'],
                                                          'address':
                                                              data['address'],
                                                          'phone':
                                                              data['phone'],
                                                          'profileimage': data[
                                                              'profileimage'],
                                                          'sid': item.suppId,
                                                          'proid':
                                                              item.documentId,
                                                          'orderid': orderId,
                                                          'ordername':
                                                              item.name,
                                                          'orderimage': item
                                                              .imagesUrl.first,
                                                          'orderqty': item.qty,
                                                          'orderprice':
                                                              item.qty *
                                                                  item.price,
                                                          'deliverystatus':
                                                              'preparing',
                                                          'deliverydate': '',
                                                          'orderdate':
                                                              DateTime.now(),
                                                          'paymentstatus':
                                                              'cash on delivery',
                                                          'orderreview': false,
                                                        }).whenComplete(
                                                                () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .runTransaction(
                                                                  (transaction) async {
                                                            DocumentReference
                                                                documentReference =
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'product')
                                                                    .doc(item
                                                                        .documentId);
                                                            DocumentSnapshot
                                                                snapshot2 =
                                                                await transaction
                                                                    .get(
                                                                        documentReference);
                                                            transaction.update(
                                                                documentReference,
                                                                {
                                                                  'instock':
                                                                      snapshot2[
                                                                              'instock'] -
                                                                          item.qty
                                                                });
                                                          });
                                                        });
                                                      }
                                                      context
                                                          .read<Cart>()
                                                          .clearCart();
                                                      Navigator.popUntil(
                                                          context,
                                                          ModalRoute.withName(
                                                              '/customer_home'));
                                                    },
                                                    width: 0.9)
                                              ],
                                            ),
                                          ));
                                } else if (selectedValue == 2) {
                                  print('visa');
                                } else if (selectedValue == 3) {
                                  print('paypal');
                                }
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

/*
 displayPaymentSheet() async {
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            setupIntentClientSecret: paymentIntentData!['client_secret'],
            allowsDelayedPaymentMethods: true));
  }
*/

