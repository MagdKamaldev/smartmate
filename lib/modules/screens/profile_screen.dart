// ignore_for_file: must_be_immutable, unnecessary_null_comparison
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:smartmate/models/user_model.dart';
import 'package:smartmate/modules/screens/edit_profile.dart';
import 'package:smartmate/shared/components/components.dart';
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
            builder: (context) => SingleChildScrollView(
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
                                              model!.image.toString()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
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
                            height: 50,
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
                          SizedBox(
                            height: 50,
                          ),
                          defaultButton(
                            function: () {
                              navigateTo(context, EditProfileScreen());
                            },
                            text: "Edit Profile",
                            radius: 15,
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.grey,
                            child: CircleAvatar(
                              radius: 50, // adjust the size as needed
                              backgroundImage:
                                  AssetImage('assets/images/Heading.png'),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Smart Mate",
                            style: TextStyle(color: defaultColor),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "By Magd",
                            style: TextStyle(color: Colors.grey[700]),
                          )
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
