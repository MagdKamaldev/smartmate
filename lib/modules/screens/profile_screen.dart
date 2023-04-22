import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:smartmate/models/user_model.dart';
import 'package:smartmate/shared/cubit/app/app_cubit.dart';
import 'package:smartmate/shared/cubit/app/app_states.dart';
import 'package:smartmate/shared/styles/colors.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        UserModel? model = AppCubit.get(context).userModel;
        return ConditionalBuilder(
            condition: model != null,
            builder: (context) => Container(
                  color: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: AlignmentDirectional.bottomEnd,
                                children: [
                                  CircleAvatar(
                                    radius: 64,
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                          NetworkImage(model!.image.toString()),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      //AppCubit.get(context).getProfileImage();
                                    },
                                    icon: CircleAvatar(
                                      backgroundColor: defaultColor,
                                      radius: 20,
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            model.name!,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            fallback: (context) => Center(
                  child: LottieBuilder.network(
                      "https://assets7.lottiefiles.com/packages/lf20_ztxhxdwa.json"),
                ));
      },
    );
  }
}
