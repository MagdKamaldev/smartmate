// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartmate/modules/login/login_screen.dart';
import 'package:smartmate/shared/components/components.dart';
import 'package:smartmate/shared/cubit/login/login_provider.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sp = context.read<LoginProvider>();
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              sp.userSignOut();
              navigateAndFinish(context, LoginScreen());
            },
            child: const Text("Sign Out")),
      ),
    );
  }
}
