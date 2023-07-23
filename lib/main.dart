import 'package:flutter/material.dart';
import 'package:flutter_new_project/auth/customer_login.dart';
import 'package:flutter_new_project/auth/customer_signup.dart';
import 'package:flutter_new_project/auth/supplier_login.dart';
import 'package:flutter_new_project/auth/supplier_signup.dart';
import 'package:flutter_new_project/main_screens/customer_home.dart';
import 'package:flutter_new_project/main_screens/supplier_home.dart';
import 'package:flutter_new_project/main_screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_new_project/providers/cart_provider.dart';
import 'package:flutter_new_project/providers/wish_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Flutter uygulamasında gerekli olan widgetlerin ve servislerin yüklenmesi ve hazırlanması işlemini başlatmak için kullanılır.
  await Firebase.initializeApp(); //run it

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Cart()),
    ChangeNotifierProvider(create: (_) => Wish()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: WelcomeScreen(),
      initialRoute: '/welcome_screen',
      routes: {
        '/welcome_screen': (context) => const WelcomeScreen(),
        '/customer_home': (context) => const CustomerHomeScreen(),
        '/supplier_home': (context) => const SupplierHomeScreen(),
        '/customer_signup': (context) => const CustomerRegister(),
        '/customer_login': (context) => const CustomerLogin(),
        '/supplier_signup': (context) => const SupplieRegister(),
        '/supplier_login': (context) => const SupplierLogin(),
      },
    );
  }
}

//add two number?

