import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_project/widgets/yellow_buton.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; //animated text kite pub dev den inceleyebilirsin

const textColors = [
  Colors.yellowAccent,
  Colors.red,
  Colors.blueAccent,
  Colors.green,
  Colors.purple,
  Colors.teal,
];
const textStyle =
    TextStyle(fontSize: 45, fontWeight: FontWeight.bold, fontFamily: 'Acme');

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  // with SingleTickerProviderStateMixin animasyon için eklendi
  late AnimationController _controller;
  bool processing = false;
  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');
  late String _uid;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/inapp/bgimage.jpg'),
                fit: BoxFit.cover)),
        constraints: const BoxConstraints.expand(), //tüm sayfaya dağıttı
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText('WELCOME',
                      textStyle: textStyle, colors: textColors),
                  ColorizeAnimatedText('Duck Store',
                      textStyle: textStyle, colors: textColors),
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
              ),
              /* const Text(
                'WELCOME',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),   */
              const SizedBox(
                height: 120,
                width: 200,
                child: Image(image: AssetImage('images/inapp/logo.jpg')),
              ),
              SizedBox(
                height: 80,
                child: DefaultTextStyle(
                  style: const TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlueAccent,
                      fontFamily: 'Acme'),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      RotateAnimatedText('Buy'),
                      RotateAnimatedText('Shop'),
                      RotateAnimatedText('Duck Store'),
                    ],
                    repeatForever: true,
                  ),
                ),
              ),
              /*
              const Text(
                'SHOP',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),  */
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomLeft: Radius.circular(50))),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Suppliers only',
                            style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: const BoxDecoration(
                                  color: Colors.white38,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      bottomLeft: Radius.circular(50))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AnimatedLogo(controller: _controller),
                                  YellowButton(
                                      label: 'Log In',
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                            context, '/supplier_login');
                                      },
                                      width: 0.25),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: YellowButton(
                                        label: 'Sign Up',
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, '/supplier_signup');
                                        },
                                        width: 0.25),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50))),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: YellowButton(
                            label: 'Log In',
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/customer_login');
                            },
                            width: 0.25),
                      ),
                      YellowButton(
                          label: 'Sign Up',
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/customer_signup');
                          },
                          width: 0.25),
                      AnimatedLogo(controller: _controller),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.white38.withOpacity(0.3)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GoogleFacebookLogIn(
                        label: 'Google',
                        child: const Image(
                            image: AssetImage('images/inapp/google.jpg')),
                        onPressed: () {},
                      ),
                      GoogleFacebookLogIn(
                        label: 'Facebook',
                        child: const Image(
                            image: AssetImage('images/inapp/facebook.jpg')),
                        onPressed: () {},
                      ),
                      processing == true
                          ? const CircularProgressIndicator()
                          : GoogleFacebookLogIn(
                              label: 'Guest',
                              onPressed: () async {
                                setState(() {
                                  processing = true;
                                });
                                //alttaki kod anonim giriş için gerekli kodlamadır
                                await FirebaseAuth.instance
                                    .signInAnonymously()
                                    .whenComplete(() async {
                                  _uid = FirebaseAuth.instance.currentUser!.uid;
                                  await anonymous.doc().set({
                                    'name': '',
                                    'email': '',
                                    'profileimage': '',
                                    'phone': '',
                                    'address': '',
                                    'cid': _uid, //customer id
                                  });
                                });
//PROFILE kısmında hata çıkıyordu. 'document does not exist ' bunun çözümü için yukardaki 'whenComplete' tasarlandı.

// ignore: use_build_context_synchronously
                                Navigator.pushReplacementNamed(
                                    context, '/customer_home');
                              },

                              //yukardaki iki kodun birleşmiş hali
                              // await FirebaseAuth.instance .signInAnonymously().then((value) =>Navigator.pushReplacementNamed( context, '/customer_home') } );

                              child: const Icon(
                                Icons.person,
                                size: 55,
                                color: Colors.lightBlueAccent,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    super.key,
    required AnimationController controller,
  }) : _controller = controller;

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: child,
        );
      },
      child: const Image(image: AssetImage('images/inapp/logo.jpg')),
    );
  }
}

class GoogleFacebookLogIn extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Widget child;
  const GoogleFacebookLogIn({
    super.key,
    required this.label,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            SizedBox(height: 50, width: 50, child: child),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
