// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/cupertino.dart';
import 'package:flutter_new_project/providers/product_class.dart';

class Wish extends ChangeNotifier {
//Özetle, ChangeNotifier sınıfı, durum yönetimi ve widget'ların güncellenmesi gibi işlemlerde kullanılan, notifyListeners() yöntemi ile dinleyicilere bildirim gönderen bir sınıftır.

  final List<Product> _list = [];
  List<Product> get getWishItems {
    return _list;
  }

  int? get count {
    _list.length;
  }

  Future<void> addWishItem(
    String name,
    double price,
    int qty,
    int qntty,
    List imagesUrl,
    String documentId,
    String suppId,
  ) async {
    final product = Product(
      documentId: documentId,
      imagesUrl: imagesUrl,
      name: name,
      price: price,
      qntty: qntty,
      qty: qty,
      suppId: suppId,
    );
    _list.add(product);
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearWishlist() {
    _list.clear();
    notifyListeners();
  }

  void removeThis(String id) {
    _list.removeWhere((element) => element.documentId == id);
    notifyListeners();
  }
}
