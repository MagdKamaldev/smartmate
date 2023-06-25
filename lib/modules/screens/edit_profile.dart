// ignore_for_file: must_be_immutable, unnecessary_null_comparison
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartmate/models/user_model.dart';
import 'package:smartmate/shared/components/components.dart';
import 'package:smartmate/shared/cubit/app/app_cubit.dart';
import 'package:smartmate/shared/cubit/app/app_states.dart';
import 'package:smartmate/shared/styles/colors.dart';

import '../../shared/components/loading_animation.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        UserModel? model = AppCubit.get(context).userModel;
        nameController.text = model.name!;
        phoneController.text = model.phone!;
        bioController.text = model.bio!;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: defaultColor,
          ),
          backgroundColor: Colors.grey[300],
          body: ConditionalBuilder(
              condition: model != null,
              builder: (context) => SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
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
                                            AppCubit.get(context)
                                                .getProfileImage(
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
                                  height: 30,
                                ),
                                defaultFormField(
                                    controller: nameController,
                                    type: TextInputType.name,
                                    onSubmit: () {},
                                    onTab: () {},
                                    onChanged: () {},
                                    label: "User Name",
                                    prefix: Icons.person_2),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                    controller: bioController,
                                    type: TextInputType.name,
                                    onSubmit: () {},
                                    onTab: () {},
                                    onChanged: () {},
                                    label: "Bio",
                                    prefix: Icons.subject),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                    controller: phoneController,
                                    type: TextInputType.phone,
                                    onSubmit: () {},
                                    onTab: () {},
                                    onChanged: () {},
                                    label: "Phone Number",
                                    prefix: Icons.phone),
                                SizedBox(
                                  height: 30,
                                ),
                                defaultButton(
                                    function: () {
                                      AppCubit.get(context).updateUser(
                                          name: nameController.text,
                                          bio: bioController.text,
                                          phone: phoneController.text);
                                      Navigator.pop(context);
                                    },
                                    text: "Submit",
                                    radius: 15)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              fallback: (context) => Center(
                    child: LoadingAnimation(),
                  )),
        );
      },
    );
  }
}
