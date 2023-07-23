// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_project/widgets/auth_widgets.dart';

import '../widgets/snacbar.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart'
    as firebase_storage; //Fİrebase storage package

/*  VERİ KAYDETME 1.YOL
final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _emailcontroller = TextEditingController();
final TextEditingController _passwordcontroller = TextEditingController();
*/

class CustomerRegister extends StatefulWidget {
  const CustomerRegister({super.key});

  @override
  State<CustomerRegister> createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends State<CustomerRegister> {
  late String name;
  late String email;
  late String password;
  late String profileImage;
  late String _uid;
  bool processing =
      false; //sign up yapılırken dönen indikatör oluşması için ayarlandı
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); //key için eklendi
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>(); //scaffoldKey için eklendi

  bool passwordVisible = false;

  XFile? _imageFile;
  dynamic _pickImageError;
  CollectionReference
      customers = //ref ile ilgilidir .ref de kaydedilecek dosyaya path açar
      FirebaseFirestore.instance.collection('customers');

  final ImagePicker _picker = ImagePicker();

  void _pickImageFromCamera() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      print(_pickImageError);
    }
  }

  void _pickImageFromGallery() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      print(_pickImageError);
    }
  }

  void signUp() async {
    setState(() {
      processing = true;
      // debugPrint('setstate process value $processing');
    });
    // debugPrint('signup button');
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        try {
          await FirebaseAuth
              .instance //Firebase Authentication servisini kullanarak, kullanıcının e-posta ve şifre bilgilerini kullanarak yeni bir kullanıcı hesabı oluşturur
              .createUserWithEmailAndPassword(email: email, password: password);

          firebase_storage.Reference ref1 =
              firebase_storage.FirebaseStorage.instance.ref(
                  'cust-images/$email.jpg'); //email her bir kullanıcı için farklı olduğundan kullanıldı
          await ref1.putFile(File(
            _imageFile!.path,
          )); //bu ref ile dosyaları yükleyebileceğiz(kaydedebileceğiz). dosyaların ekleneceği yol açılır. path açılır
          _uid = FirebaseAuth.instance.currentUser!.uid; // ignore: unused_label
          profileImage = await ref1.getDownloadURL();
          await customers.doc(_uid).set({
            'name': name,
            'email': email,
            'profileimage': profileImage,
            'phone': '',
            'address': '',
            'cid': _uid, //customer id
          });

          _formKey.currentState!.reset();
          setState(() {
            _imageFile = null;
          });
          //Storage ve firebase database aktif edildi video 50. storage:images firestore database belge

          Navigator.pushReplacementNamed(context, '/customer_login');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            setState(() {
              processing = false;
            });
            MyMessageHandler.showSnackBar(
                scaffoldKey, 'The password provided is too weak.');
            print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            setState(() {
              processing = false;
            });
            MyMessageHandler.showSnackBar(
                scaffoldKey, 'The account already exists for that email.');
            print('The account already exists for that email.');
          }
        }
      } else {
        setState(() {
          processing = false;
        });
        try {
          MyMessageHandler.showSnackBar(scaffoldKey, 'please pick image first');
        } catch (e) {
          debugPrint('snackbar hata $e');
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
                    children: [
                      const AuthHeaderLabel(
                        headerLabel: 'Sign up',
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 40),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.purpleAccent,
                              backgroundImage: _imageFile == null
                                  ? null
                                  : FileImage(File(_imageFile!.path)),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    )),
                                child: IconButton(
                                    onPressed: () {
                                      _pickImageFromCamera();
                                    },
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    )),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    )),
                                child: IconButton(
                                    onPressed: () {
                                      _pickImageFromGallery();
                                    },
                                    icon: const Icon(
                                      Icons.photo,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your full name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            //VERİ KAYDETME 2.YOL
                            name = value;
                          },

                          //   controller: _namecontroller , VERİ KAYDETME 1.YOL

                          decoration: textFormDecoration.copyWith(
                              //************ */ textFormDecoration altta hazır komutu var
                              labelText: 'Full Name',
                              hintText: 'Enter your Full Name'),
                        ),
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
                      HaveAccount(
                        haveAccount: 'already have account? ',
                        actionLabel: 'Log In',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/customer_login');
                        },
                      ),
                      processing == true
                          ? const CircularProgressIndicator(
                              color: Colors.purple,
                            )
                          : AuthMainButton(
                              mainButtonLabel: 'Sign up',
                              onPressed: () {
                                signUp();
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
