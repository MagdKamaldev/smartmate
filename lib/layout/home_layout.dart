// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartmate/shared/components/components.dart';
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
              IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              PopupMenuButton<String>(
                onSelected: (String value) {
                  // Do something when a menu item is selected
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'item1',
                    child: Center(
                        child: Column(
                      children: [
                        Text(
                          'New Group',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        myDivider()
                      ],
                    )),
                    onTap: () {},
                  ),
                  PopupMenuItem<String>(
                    value: 'item2',
                    child: Center(
                        child: Column(
                      children: [
                        Text(
                          'New Chat',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        myDivider()
                      ],
                    )),
                    onTap: () {},
                  ),
                  PopupMenuItem<String>(
                    value: 'item3',
                    child: Center(
                        child: Column(
                      children: [
                        Text(
                          'Settings',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        myDivider(),
                      ],
                    )),
                  ),
                  PopupMenuItem<String>(
                    value: 'item4',
                    child: Center(
                        child: Column(
                      children: [
                        Text(
                          'Logout',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(
                          height: 13,
                        ),
                      ],
                    )),
                    onTap: () {
                      signOut(context);
                    },
                  ),
                ],
              )
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: defaultColor,
            currentIndex: cubit.currentIndex,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.messenger), label: "chats"),
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
