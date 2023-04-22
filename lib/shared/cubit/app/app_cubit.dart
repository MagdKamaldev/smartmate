import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartmate/modules/screens/chats_screen.dart';
import 'package:smartmate/modules/screens/groups_screen.dart';
import 'package:smartmate/modules/screens/profile_screen.dart';
import 'package:smartmate/shared/components/constants.dart';
import 'package:smartmate/shared/networks/local/cache_helper.dart';
import '../../../models/messege_model.dart';
import '../../../models/user_model.dart';
import 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitalState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    ChatsScreen(),
    GroupsScreen(),
    ProfileScreen(),
  ];
  List<String> titles = [
    "Home",
    "Chats",
    "profile",
  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    if (index == 0) {
      getUsers();
    }
    if (index == 2) {
      getUserData();
    }
    emit(ChangeBottomNavState());
  }

  UserModel? userModel;

  void getUserData() {
    emit(GetUserLoadingState());

    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(GetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUserErrorState());
    });
  }

  List<UserModel> users = [];

  void getUsers() {
    users = [];
    FirebaseFirestore.instance.collection("users").get().then((value) {
      for (var element in value.docs) {
        if (element.data()["uid"] != CacheHelper.getData(key: "uid")) {
          users.add(UserModel.fromJson(element.data()));
        }
      }

      emit(GetAllUsersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetAllUsersErrorState());
    });
  }

  void sendMessege({
    required String recieverId,
    required String dateTime,
    required String text,
  }) {
    MessegeModel model = MessegeModel(
      text: text,
      senderId: CacheHelper.getData(key: "uid"),
      recieverId: recieverId,
      dateTime: dateTime,
    );
    // print(CacheHelper.getData(key: "uid"));
    //sender
    FirebaseFirestore.instance
        .collection("users")
        .doc(CacheHelper.getData(key: "uid"))
        .collection("chats")
        .doc(recieverId)
        .collection("messeges")
        .add(model.toMap())
        .then((value) {
      emit(SendMessegeSuccessState());
    }).catchError((error) {
      emit(SendMessegeErrorState());
    });
    //reciever
    FirebaseFirestore.instance
        .collection("users")
        .doc(recieverId)
        .collection("chats")
        .doc(CacheHelper.getData(key: "uid"))
        .collection("messeges")
        .add(model.toMap())
        .then((value) {
      emit(SendMessegeSuccessState());
    }).catchError((error) {
      emit(SendMessegeErrorState());
    });
  }

  List<MessegeModel> messeges = [];
  void getMesseges({
    required String recieverId,
  }) {
    emit(GetMessegeLoadingState());
    FirebaseFirestore.instance
        .collection("users")
        .doc(CacheHelper.getData(key: "uid"))
        .collection("chats")
        .doc(recieverId)
        .collection("messeges")
        .orderBy("dateTime")
        .snapshots()
        .listen((event) {
      messeges = [];
      for (var element in event.docs) {
        messeges.add(MessegeModel.fromJson(element.data()));
      }
      emit(GetMessegeSuccessState());
    });
  }

  
}
