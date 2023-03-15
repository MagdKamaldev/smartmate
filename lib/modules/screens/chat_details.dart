// ignore_for_file: must_be_immutable
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartmate/shared/networks/local/cache_helper.dart';
import '../../models/messege_model.dart';
import '../../models/user_model.dart';
import '../../shared/cubit/app/app_cubit.dart';
import '../../shared/cubit/app/app_states.dart';
import '../../shared/styles/colors.dart';

class ChatDetails extends StatelessWidget {
  UserModel? userModel;
  ChatDetails({required this.userModel});

  var messegeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit.get(context).getMesseges(recieverId: userModel!.uid!);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: defaultColor,
            titleSpacing: 0.0,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(userModel!.image.toString()),
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(userModel!.name!),
              ],
            ),
          ),
          body: ConditionalBuilder(
            condition: AppCubit.get(context).messeges.isNotEmpty ||
                state is GetMessegeSuccessState,
            fallback: (context) => Center(child: CircularProgressIndicator()),
            builder: (context) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var messege = AppCubit.get(context).messeges[index];
                          if (CacheHelper.getData(key: "uid") ==
                              messege.senderId) {
                            return buildMyMessege(messege, context);
                          } else {
                            return buildMessege(messege, context);
                          }
                        },
                        separatorBuilder: (context, index) => SizedBox(
                              height: 15,
                            ),
                        itemCount: AppCubit.get(context).messeges.length),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                        borderRadius: BorderRadius.circular(15)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: TextFormField(
                          controller: messegeController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type Your messege !"),
                        )),
                        Container(
                            height: 50,
                            color: defaultColor,
                            child: MaterialButton(
                              minWidth: 1,
                              onPressed: () {
                                AppCubit.get(context).sendMessege(
                                    recieverId: userModel!.uid.toString(),
                                    dateTime: DateTime.now().toString(),
                                    text: messegeController.text);
                                messegeController.text = "";
                              },
                              child: const Icon(
                                Icons.send,
                                size: 16,
                                color: Colors.white,
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget buildMessege(MessegeModel model, context) => Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        width: MediaQuery.of(context).size.width * .5,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10),
              topStart: Radius.circular(10),
              topEnd: Radius.circular(10),
            )),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                model.text.toString(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                model.dateTime!.substring(11, 16).toString(),
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );

Widget buildMyMessege(MessegeModel model, context) => Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        width: MediaQuery.of(context).size.width * .5,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        decoration: BoxDecoration(
            color: defaultColor.withOpacity(.7),
            borderRadius: const BorderRadiusDirectional.only(
              bottomStart: Radius.circular(10),
              topStart: Radius.circular(10),
              topEnd: Radius.circular(10),
            )),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                model.text.toString(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                model.dateTime!.substring(11, 16).toString(),
                style: TextStyle(color: Colors.brown),
              ),
            )
          ],
        ),
      ),
    );
