// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:smartmate/modules/login/phone_login.dart';
import 'package:smartmate/shared/components/components.dart';
import 'package:smartmate/shared/cubit/login/login_cubit.dart';
import 'package:smartmate/shared/cubit/login/login_states.dart';

import '../register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();

  final RoundedLoadingButtonController phoneController =
      RoundedLoadingButtonController();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          body: SingleChildScrollView(
            child: SafeArea(
                child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Image.asset(
                            "assets/images/Heading.png",
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Welcome to smart mate",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "The faster You login the more you enjoy the experience ",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontSize: 13.5, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Column(
                      children: [
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
                          height: 20,
                        ),
                        defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            suffix: LoginCubit.get(context).suffix,
                            suffixPressed: () {
                              LoginCubit.get(context)
                                  .changePasswordVisibility();
                            },
                            isPassword: LoginCubit.get(context).isPassword,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return "Password is too short";
                              }
                            },
                            onSubmit: () {
                              if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            onTab: () {},
                            onChanged: () {},
                            label: "password",
                            prefix: Icons.lock),
                        SizedBox(
                          height: 30,
                        ),
                        ConditionalBuilder(
                          condition: State is! LoginLoadingState,
                          builder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  LoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text,context: context);
                                }
                              },
                              radius: 20,
                              text: "Login",
                              isUpperCase: true),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account ?"),
                            defaultTextButton(
                                text: "register",
                                onpressed: () {
                                  navigateTo(
                                    context,
                                    RegisterScreen(),
                                  );
                                })
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        RoundedLoadingButton(
                          width: MediaQuery.of(context).size.width * 0.7,
                          color: Colors.red,
                          controller: googleController,
                          successColor: Colors.red,
                          onPressed: () {
                            LoginCubit.get(context)
                                .handleGoogleSignIn(googleController, context);
                          },
                          child: Wrap(
                            children: const [
                              Icon(
                                FontAwesomeIcons.google,
                                size: 20,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Sign in with Google",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RoundedLoadingButton(
                          width: MediaQuery.of(context).size.width * 0.7,
                          color: Colors.black,
                          controller: phoneController,
                          successColor: Colors.black,
                          onPressed: () {
                            navigateTo(context, PhoneLogin());
                            phoneController.reset();
                          },
                          child: Wrap(
                            children: const [
                              Icon(
                                FontAwesomeIcons.phone,
                                size: 20,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Sign in with Phone",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
          ),
        );
      },
    );
  }
}
