// ignore_for_file: must_be_immutable
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartmate/layout/home_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/register/register_cubit.dart';
import '../../shared/cubit/register/register_states.dart';
import '../../shared/styles/colors.dart';
import '../login/login_screen.dart';
import '../privacy_policy/privacy.dart';


class RegisterScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, AppRegisterStates>(
        listener: (context, state) {
          if (state is CreateUserSuccessState) {
            navigateAndFinish(context, HomeScreen());
          }
        },
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
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "REGISTER",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 24, color: defaultColor),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Register now to join our network",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          defaultFormField(
                              controller: nameController,
                              type: TextInputType.name,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return "Please enter your name";
                                }
                              },
                              onSubmit: () {},
                              onTab: () {},
                              onChanged: () {},
                              label: "User Name",
                              prefix: Icons.person),
                          SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return "Please enter your email adress";
                                }
                              },
                              onSubmit: () {},
                              onTab: () {},
                              onChanged: () {},
                              label: "E-mail adress",
                              prefix: Icons.email),
                          SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                              controller: passwordController,
                              type: TextInputType.visiblePassword,
                              suffix: RegisterCubit.get(context).suffix,
                              suffixPressed: () {
                                RegisterCubit.get(context)
                                    .changePasswordVisibility();
                              },
                              isPassword: RegisterCubit.get(context).isPassword,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return "Password is too short";
                                }
                              },
                              onSubmit: () {},
                              onTab: () {},
                              onChanged: () {},
                              label: "password",
                              prefix: Icons.lock),
                          SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                              controller: phoneController,
                              type: TextInputType.phone,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return "Please enter your phone number";
                                }
                              },
                              onSubmit: () {},
                              onTab: () {},
                              onChanged: () {},
                              label: "phone number",
                              prefix: Icons.phone),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Text(
                                "   by Clicking Register you accept the ",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontSize: 13),
                              ),
                              GestureDetector(
                                onTap: () {
                                  navigateTo(context, Privacy());
                                },
                                child: Text(
                                  "Privacy Policy",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: defaultColor),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ConditionalBuilder(
                            condition: state is! RegisterLoadingState,
                            builder: (context) => defaultButton(
                                radius: 20,
                                height: 50,
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    RegisterCubit.get(context).userRegister(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        context: context);
                                  }
                                },
                                text: "register",
                                isUpperCase: true),
                            fallback: (context) =>
                                Center(child: CircularProgressIndicator()),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
