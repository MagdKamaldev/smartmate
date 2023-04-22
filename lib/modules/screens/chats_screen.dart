import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartmate/models/user_model.dart';
import 'package:smartmate/shared/components/components.dart';
import 'package:smartmate/shared/cubit/app/app_cubit.dart';
import 'package:smartmate/shared/cubit/app/app_states.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        // AppCubit.get(context).getLastMessages();
      },
      builder: (context, state) {
        List<UserModel> users = AppCubit.get(context).users;
        return Container(
          color: Colors.grey[300],
          child: ListView.separated(
            itemBuilder: (context, index) => Builder(builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(children: [
                  buildChatItem(
                    model: AppCubit.get(context).users[index],
                    context: context,
                    index: index,
                  ),
                ]),
              );
            }),
            itemCount: users.length,
            separatorBuilder: (context, index) => myDivider(),
          ),
        );
      },
    );
  }
}
