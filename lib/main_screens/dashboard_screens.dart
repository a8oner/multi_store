import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_project/dashboard_components/edit_business.dart';
import 'package:flutter_new_project/dashboard_components/manage_products.dart';
import 'package:flutter_new_project/dashboard_components/supp_balance.dart';
import 'package:flutter_new_project/dashboard_components/supp_orders.dart';
import 'package:flutter_new_project/dashboard_components/supp_statics.dart';
import 'package:flutter_new_project/main_screens/visit_store.dart';
import 'package:flutter_new_project/widgets/appbar_widgets.dart';

import '../widgets/alert_dialog.dart';

List<String> label = [
  'my store',
  'orders',
  'edit profile',
  'manage products',
  'balance',
  'statics'
];

List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.edit,
  Icons.settings_applications,
  Icons.attach_money,
  Icons.show_chart,
];
List<Widget> pages = [
  VisitStore(suppId: FirebaseAuth.instance.currentUser!.uid),
  const SupplierOrders(),
  const EditBusiness(),
  ManageProducts(),
  const Balance(),
  const Statics()
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
            title: 'Dashboard'), //AppBarTitle hazırlanmış widget idi
        actions: [
          IconButton(
              onPressed: () {
                MyAlertDialog.showMyDialog(
                    context: context,
                    title: 'Log Out',
                    content: 'Are you sure to log out ?',
                    tabNo: () {
                      Navigator.pop(context);
                    },
                    tabYes: () async {
                      await FirebaseAuth.instance
                          .signOut(); // firebase'den çıkış yapıldı
                      // ignore: use_build_context_synchronously
                      Navigator.pop(
                          context); //Çıkış yaptıktan sonra login'e tıklandığında hata veriyordu düzeltmek için eklendi
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(
                          context, '/welcome_screen');
                    });
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing:
            50, //spacing'ler cartlar arasındaki boşluk miktarıyla ilgili
        crossAxisSpacing: 50,
        children: List.generate(6, (index) {
          return InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => pages[index]));
            },
            child: Card(
              elevation: 20,
              shadowColor: Colors.purpleAccent.shade200,
              color: Colors.blueGrey.withOpacity(0.7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    icons[index],
                    size: 50,
                    color: Colors.yellowAccent,
                  ),
                  Text(
                    label[index].toUpperCase(),
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.yellowAccent,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        fontFamily: 'Acme'),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
