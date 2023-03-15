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
      listener: (context, state) {},
      builder: (context, state) {
        List<UserModel> users = AppCubit.get(context).users;
        return ListView.separated(
          itemBuilder: (context, index) => Builder(builder: (context) {
            //  AppCubit.get(context).getMesseges(recieverId: AppCubit.get(context).users[index].uid.toString());
            return Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(children: [
                buildChatItem(
                  model: AppCubit.get(context).users[index],
                  context: context,
                ),
              ]),
            );
          }),
          itemCount: users.length,
          separatorBuilder: (context, index) => myDivider(),
        );
      },
    );
  }
}
