import 'package:flutter/material.dart';
import 'package:flutter_new_project/widgets/appbar_widgets.dart';

class MyStore extends StatelessWidget {
  const MyStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'My Store'),
        leading: const AppBarBackButton(),
      ),
    );
  }
}
