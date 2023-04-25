// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartmate/shared/components/constants.dart';
import 'package:smartmate/shared/styles/colors.dart';
import '../shared/cubit/app/app_cubit.dart';
import '../shared/cubit/app/app_states.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: defaultColor,
            title: Text(
              "Smart Mate",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white, fontSize: 20),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    signOut(context);
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors.white,
                  )),
            ],
          ),
          backgroundColor: Colors.grey[300],
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: defaultColor,
            selectedItemColor: Colors.white,
            currentIndex: cubit.currentIndex,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.messenger), label: "Users"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.smart_toy), label: "Bot"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
            ],
            onTap: (index) {
              cubit.changeBottomNavBar(index);
            },
          ),
        );
      },
    );
  }
}
