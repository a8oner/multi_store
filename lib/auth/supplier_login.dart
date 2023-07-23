import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_project/widgets/auth_widgets.dart';

import '../widgets/snacbar.dart';

/*  VERİ KAYDETME 1.YOL
final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _emailcontroller = TextEditingController();
final TextEditingController _passwordcontroller = TextEditingController();
*/

class SupplierLogin extends StatefulWidget {
  const SupplierLogin({super.key});

  @override
  State<SupplierLogin> createState() => _SupplierLoginState();
}

class _SupplierLoginState extends State<SupplierLogin> {
  late String email;
  late String password;

  bool processing =
      false; //sign up yapılırken dönen indikatör oluşması için ayarlandı
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); //key için eklendi
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>(); //scaffoldKey için eklendi

  bool passwordVisible = false;

  void logIn() async {
    setState(() {
      processing = true;
      debugPrint('setstate process value $processing');
    });
    debugPrint('logIn button');
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        _formKey.currentState!.reset();

        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(
            context, '/supplier_home'); //buraya eklenmesi çok önemli
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            processing = false;
          });
          MyMessageHandler.showSnackBar(
              scaffoldKey, 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          setState(() {
            processing = false;
          });
          MyMessageHandler.showSnackBar(
              scaffoldKey, 'Wrong password provided for that user.');
        }
      }

      /*  //  VERİ KAYDETME 1.YOL
                                setState(() {
                                name =
                                    _namecontroller.text; //Verilerin kaydedilmesi
                                email = _emailcontroller.text;
                                password = _passwordcontroller.text;
                              });
                              */
    } else {
      setState(() {
        processing = false;
      });
      MyMessageHandler.showSnackBar(scaffoldKey, 'please fill all fields');

      /*  //SONRASINDA YUKARDA voidshowSnacbar eklendi
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.yellow,
                                content: Text(
                                  'please fill all fields',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ));
                             */
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      //ScaffoldMessenger Snacbar için eklendi ardından scaffoldKey eklendi,ondan sonra yukarda ekleme yapıldı
      key: scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key:
                      _formKey, // TextFormfield'lardaki value değeri için oluşturuldu
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthHeaderLabel(
                        headerLabel: 'Log In',
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email';
                            } else if (value.isValidEmail() == false) {
                              //email test kodu 'validator' işlemi
                              return 'invalid email';
                            } else if (value.isValidEmail() == true) {
                              //email test kodu 'validator' işlemi
                              return null;
                            }
                            return null;
                          },

                          onChanged: (value) {
                            //VERİ KAYDETME 2.YOL
                            email = value;
                          },

                          //   controller: _emailcontroller,  VERİ KAYDETME 1.YOL
                          keyboardType: TextInputType.emailAddress,
                          decoration: textFormDecoration.copyWith(
                              labelText: 'Email Address',
                              hintText: 'Enter your email'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your password';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            //VERİ KAYDETME 2.YOL
                            password = value;
                          },
                          //  controller: _passwordcontroller,   VERİ KAYDETME 1.YOL
                          obscureText: passwordVisible,
                          decoration: textFormDecoration.copyWith(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.purple,
                                  )),
                              labelText: 'Password',
                              hintText: 'Enter your password'),
                        ),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forget Password',
                            style: TextStyle(
                                fontSize: 18, fontStyle: FontStyle.italic),
                          )),
                      HaveAccount(
                        haveAccount: 'Don\'t Have Account? ',
                        actionLabel: 'Sign Up',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/supplier_signup');
                        },
                      ),
                      processing == true
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Colors.purple,
                            ))
                          : AuthMainButton(
                              mainButtonLabel: 'Log In',
                              onPressed: () {
                                logIn();
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//HAZIR SINIFLAR İLKİN AŞAĞIYA CONSTRACT EDİLDİ SONRASINDA KESİLİP WİDGETS DOSYASINA EKLENDİ
