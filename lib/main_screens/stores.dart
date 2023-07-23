import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_project/main_screens/visit_store.dart';
import 'package:flutter_new_project/widgets/appbar_widgets.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
            title: 'Stores'), //AppBarTitle hazır sınıftan çağrıldı
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('suppliers').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 25,
                      crossAxisSpacing: 25,
                      crossAxisCount: 2), // SliverGridDelegateWithFixedCrossAx1
                  itemBuilder: (context, index) {
                    try {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VisitStore(
                                        suppId: snapshot.data!.docs[index]
                                            ['sid'],
                                      )));
                          /*Get.to(VisitStore(suppId: snapshot.data!.docs[index]['sid'], ));  */
                        },
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: Image.asset('images/inapp/logo.jpg'),
                                ),
                                Positioned(
                                    bottom: 28,
                                    left: 100,
                                    child: SizedBox(
                                      height: 48,
                                      width: 100,
                                      child: Image.network(
                                        snapshot.data!.docs[index]['storeLogo'],
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ],
                            ),
                            Text(
                              snapshot.data!.docs[index]['storeName']
                                  .toLowerCase(),
                              style: const TextStyle(
                                  fontSize: 26, fontFamily: 'Akaya_Telivigala'),
                            ),
                          ],
                        ),
                      );
                    } catch (e) {
                      debugPrint('NETWORK HATA $e');
                    }
                    return null;
                  });
            }
            return const Center(
              child: Text('No Stores'),
            );
          },
        ),
      ),
    );
  }
}
