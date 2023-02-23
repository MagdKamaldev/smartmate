// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartmate/shared/cubit/login/login_cubit.dart';
import 'package:smartmate/shared/cubit/login/login_states.dart';
import 'package:smartmate/shared/styles/colors.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {},
      builder: (context, state) {
        late TabController _tabController;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: defaultColor,
            title: Text(
              "Smart Mate",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              PopupMenuButton<String>(
                onSelected: (String value) {
                  // Do something when a menu item is selected
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'item1',
                    child: Text('Settings'),
                  ),
                  PopupMenuItem<String>(
                    value: 'item2',
                    child: Text('Logout'),
                  ),
                ],
              )
            ],
          ),
          body: Column(),
        );
      },
    );
  }
}
