// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartmate/modules/login/login_screen.dart';
import 'package:smartmate/shared/components/components.dart';
import 'package:smartmate/shared/cubit/login/login_cubit.dart';
import 'package:smartmate/shared/cubit/login/login_states.dart';
import 'package:smartmate/shared/styles/colors.dart';

class PhoneLogin extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                navigateAndFinish(context, LoginScreen());
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Center(
                        child: Text(
                          "Login With Phone Number",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 20),
                        ),
                      ),
                      const SizedBox(
                        height: 75,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "name can not be empty";
                          } else {
                            return null;
                          }
                        },
                        controller: nameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.account_circle,
                            color: Colors.green,
                          ),
                          hintText: "username",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: defaultColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "email adress can not be empty";
                          } else {
                            return null;
                          }
                        },
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.green,
                          ),
                          hintText: "email address",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: defaultColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "phone number can not be empty";
                          } else {
                            return null;
                          }
                        },
                        controller: phoneController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.green,
                          ),
                          hintText: "phone number",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: defaultColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Don't forget to add +2",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            LoginCubit.get(context).phoneLogin(
                                context,
                                phoneController.text.trim(),
                                formKey,
                                otpCodeController,
                                emailController,
                                nameController);
                          },
                          child: const Text("Confirm"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: defaultColor),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }
}
