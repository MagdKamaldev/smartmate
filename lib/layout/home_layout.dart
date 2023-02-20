// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartmate/modules/login/login_screen.dart';
import 'package:smartmate/shared/components/components.dart';
import 'package:smartmate/shared/cubit/login/login_cubit.dart';
import 'package:smartmate/shared/cubit/login/login_states.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: MaterialButton(
              onPressed: () {
                LoginCubit.get(context).userSignOut().then((value) {
                  navigateAndFinish(context, LoginScreen());
                });
              },
              child: Text("signout"),
            ),
          ),
        );
      },
    );
  }
}
