// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/cupertino.dart';
import 'package:flutter_new_project/providers/product_class.dart';

class Cart extends ChangeNotifier {
//Özetle, ChangeNotifier sınıfı, durum yönetimi ve widget'ların güncellenmesi gibi işlemlerde kullanılan, notifyListeners() yöntemi ile dinleyicilere bildirim gönderen bir sınıftır.

  final List<Product> _list = [];
  List<Product> get getItems {
    return _list;
  }

  double get totalPrice {
    var total = 0.0;
    for (var item in _list) {
      total += item.price * item.qty;
    }
    return total;
  }

  int? get count {
    _list.length;
  }

  void addItem(
    String name,
    double price,
    int qty,
    int qntty,
    List imagesUrl,
    String documentId,
    String suppId,
  ) {
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

  void increment(Product product) {
    product.increase();
    notifyListeners();
  }

  void reduceByOne(Product product) {
    product.decrease();
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _list.clear();
    notifyListeners();
  }
}
