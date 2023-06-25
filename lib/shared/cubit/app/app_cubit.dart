// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartmate/modules/screens/chats_screen.dart';
import 'package:smartmate/modules/screens/groups_screen.dart';
import 'package:smartmate/shared/components/components.dart';
import 'package:smartmate/shared/components/constants.dart';
import 'package:smartmate/shared/networks/local/cache_helper.dart';
import '../../../models/messege_model.dart';
import '../../../models/story_model.dart';
import '../../../models/user_model.dart';
import '../../../modules/screens/profile_screen.dart';
import 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitalState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    ChatsScreen(),
    StoriesScreen(),
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
    if (index == 1) {
      getStories();
    }
    if (index == 2) {
      getUserData();
    }
    emit(ChangeBottomNavState());
  }

  late UserModel userModel;

  void getUserData() {
    emit(GetUserLoadingState());

    FirebaseFirestore.instance.collection("users").doc(uId).get().then((value) {
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
    uId = CacheHelper.getData(key: "uid");
    FirebaseFirestore.instance.collection("users").get().then((value) {
      for (var element in value.docs) {
        if (element.id != uId) {
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
      senderId: uId,
      recieverId: recieverId,
      dateTime: dateTime,
    );
    // print(CacheHelper.getData(key: "uid"));
    //sender
    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
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
        .doc(uId)
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
        .doc(uId)
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

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      uploadProfileImage(
        name: name,
        phone: phone,
        bio: bio,
      );
      emit(ProfileImagePickedSuccessState());
    } else {
      emit(ProfileImagePickedErrorState());
    }
  }

  void updateUser({
    required String name,
    required String phone,
    String? cover,
    String? image,
    String? bio,
  }) {
    UserModel model = UserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: userModel.email,
      image: image ?? userModel.image,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(UpdateUserDataErrorState());
    });
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(UpdateUserDataLoadingState());
    if (profileImage == null) {
      // handle the case where no profile image was selected
      emit(UploadProfileImageErrorState());
      return;
    }
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("users/${Uri.file(profileImage!.path).pathSegments.last}")
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, phone: phone, image: value, bio: bio);
        getUsers();
      }).catchError((error) {
        emit(UploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(UploadProfileImageErrorState());
    });
  }

  File? storyImage;

  Future<void> getStoryImagefromGallery(context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      storyImage = File(pickedFile.path);
      Navigator.pop(context);
      emit(StoryImagePickedFromGallerySuccessState());
    } else {
      showToast(text: "no image selected", state: ToasStates.error);
      emit(StoryImagePickedFromGalleryErrorState());
    }
  }

  Future<void> getStoryImagefromCamera(context) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      storyImage = File(pickedFile.path);
      Navigator.pop(context);
      emit(StoryImagePickedFromCameraSuccessState());
    } else {
      showToast(text: "no image selected", state: ToasStates.error);
      emit(StoryImagePickedFromCameraErrorState());
    }
  }

  void uploadStoryImage({
    required String dateTime,
    required String text,
  }) {
    emit(CreateStoryLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("stories/${Uri.file(storyImage!.path).pathSegments.last}")
        .putFile(storyImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createStory(dateTime: dateTime, text: text, storyImage: value);
      }).catchError((error) {
        emit(CreateStoryErrorState());
      });
    }).catchError((error) {
      emit(CreateStoryErrorState());
    });
  }

  void createStory({
    required String dateTime,
    required String text,
    String? storyImage,
  }) {
    emit(CreateStoryLoadingState());

    StoryModel model = StoryModel(
      name: userModel.name,
      image: userModel.image,
      uId: CacheHelper.getData(key: "uid"),
      dateTime: dateTime,
      text: text,
      storyImage: storyImage ?? "",
    );

    FirebaseFirestore.instance
        .collection('stories')
        .add(model.toMap())
        .then((value) {
      emit(CreateStorySuccesState());
    }).catchError((error) {
      emit(CreateStoryErrorState());
    });
  }

  List<StoryModel> stories = [];
  List<String> postId = [];

  getStories() {
    stories = [];
    FirebaseFirestore.instance.collection("stories").get().then((value) {
      for (var element in value.docs) {
        postId.add(element.id);
        stories.add(StoryModel.fromJson(element.data()));
        emit(GetStoriesSuccessState());
      }
    }).catchError((error) {
      emit(GetStoriesErrorState());
    });
  }

  List<StoryModel> userStoriesList = [];
  void getSingleUserStories(userId) {
    userStoriesList = [];
    emit(GetSingleUserstoryLoadingState());
    FirebaseFirestore.instance.collection("stories").get().then((value) {
      for (var element in value.docs) {
        if (StoryModel.fromJson(element.data()).uId ==
            FirebaseAuth.instance.currentUser!.uid) {
          userStoriesList.add(StoryModel.fromJson(element.data()));
          emit(GetSingleUserStorySuccessState());
        }
      }
    }).catchError((error) {
      emit(GetSingleUserStoryErrorState());
    });
  }

  void removeStoryImage() {
    storyImage = null;
    emit(RemoveStoryImageState());
  }
}
