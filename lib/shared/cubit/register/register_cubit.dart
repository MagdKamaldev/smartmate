import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartmate/layout/home_layout.dart';
import 'package:smartmate/shared/components/components.dart';
import 'package:smartmate/shared/cubit/register/register_states.dart';

import '../../../models/user_model.dart';
import '../../networks/local/cache_helper.dart';

class RegisterCubit extends Cubit<AppRegisterStates> {
  RegisterCubit()
      : super(
            RegisterInitialState()); //3ashan fe constructor me7tag ya5od el initial state
  static RegisterCubit get(context) =>
      BlocProvider.of(context); //3ashan a3raf a5od object men el cubit

  void userRegister(
      {required String email,
      required String password,
      required String name,
      required String phone,
      context}) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUser(name: name, email: email, phone: phone, uId: value.user!.uid);
      CacheHelper.saveData(key: "uid", value: "user");
      navigateTo(context, HomeScreen());
      emit(RegisterSuccessState());
    }).catchError((error) {
      showToast(text: error.toString(), state: ToasStates.error);
      emit(RegisterErrorState(error.toString()));
    });
  }

  void createUser({
    required String name,
    required String email,
    required String phone,
    required String uId,
  }) {
    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      image:
          "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn4.iconfinder.com%2Fdata%2Ficons%2Fsocial-messaging-ui-color-and-shapes-3%2F177800%2F129-512.png&f=1&nofb=1&ipt=2e57bbfa1aa643cb1b506496b21cf4ddc891d8110ceb9c6a944ddc35a3e49b26&ipo=images",
    );

    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CreateUserErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterChangePasswordState());
  }
}
