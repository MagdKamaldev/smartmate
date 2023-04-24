// ignore_for_file: must_be_immutable, unnecessary_null_comparison

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:smartmate/models/user_model.dart';
import 'package:smartmate/shared/components/components.dart';
import 'package:smartmate/shared/cubit/app/app_cubit.dart';
import 'package:smartmate/shared/cubit/app/app_states.dart';
import 'package:smartmate/shared/styles/colors.dart';

class ProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        UserModel? model = AppCubit.get(context).userModel;
        nameController.text = model!.name!;
        phoneController.text = model.phone!;
        bioController.text = model.bio!;
        return ConditionalBuilder(
            condition: model != null,
            builder: (context) => Container(
                  color: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: Column(
                        children: [
                          Column(
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
                                          backgroundImage: NetworkImage(
                                              model.image.toString()),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          AppCubit.get(context).getProfileImage(
                                            name: nameController.text,
                                            phone: phoneController.text,
                                            bio: bioController.text,
                                          );
                                        },
                                        icon: CircleAvatar(
                                          backgroundColor: defaultColor,
                                          radius: 20,
                                          child: Icon(
                                            Icons.camera_alt,
                                            size: 16,
                                            color: Colors.white,
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
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                model.bio!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Mail      ",
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(model.email!),
                                  ],
                                ),
                                SizedBox(height: 10),
                                myDivider(),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Phone  ",
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(model.phone!),
                                  ],
                                ),
                              ],
                            ),
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
