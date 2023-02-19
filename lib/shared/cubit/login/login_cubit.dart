// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartmate/shared/cubit/login/login_states.dart';
import '../../../layout/home_layout.dart';
import '../../components/components.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitalState());
  static LoginCubit get(context) => BlocProvider.of(context);

  //instance of firebase Auht,facebook and google
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _provider;
  String? get provider => _provider;

  String? _uid;
  String? get uid => _uid;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;


  SignInProvider() {
    checkSignIn();
  }


  Future checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("signed_in") ?? false;
    emit(CheckSignInState());
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("signed_in", true);
    _isSignedIn = true;
    emit(SetSignInState());
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      //execute authentication
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        //signing to firebase user instance
        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        //save user details
        _name = userDetails.displayName;
        _email = userDetails.email;
        _uid = userDetails.uid;
        _imageUrl = userDetails.photoURL;
        _provider = "Google";
        emit(SignInWithGoogleSuccesState());
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "acconut-exists-with-different-credentials":
            _errorCode = "you already have an account use a different provider";
            _hasError = true;
            emit(SignInWithGoogleErrorState());
            break;
          case "null":
            _errorCode = "unexpected error while trying to sign in";
            _hasError = true;
            emit(SignInWithGoogleErrorState());
            break;
          default:
            _errorCode = error.toString();
            _hasError = true;
            emit(SignInWithGoogleErrorState());
        }
      }
    } else {
      _hasError = true;
      emit(SignInWithGoogleErrorState());
    }
  }


   bool _hasInternet = false;
  bool get hasInternet => _hasInternet;

  InternetProviders() {
    checkInternetConnection();
  }

  Future checkInternetConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _hasInternet = false;
    } else {
      _hasInternet = true;
      emit(CheckCinnectionState());
    }
  }
  

   handleAfterSignIn(context) {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      navigateAndFinish(
        context,
        WelcomeScreen(),
      );
    });
  }

   Future handleGoogleSignIn(googleController,context) async {
    
    await checkInternetConnection();

    if (hasInternet == false) {
      openSnackBar(context, "check your connection !", Colors.red);
      googleController.reset();
    } else {
      await signInWithGoogle().then((value) {
        if (hasError == true) {
          openSnackBar(context, "falied", Colors.red);
          googleController.reset();
        } else {
          checkIfUserExists().then((value) async {
            if (value == true) {
              await getUserDataFromFirebase(uid).then((value) => saveDataToSharedPreferences()
                  .then((value) => setSignIn().then((value) {
                        googleController.success();
                        handleAfterSignIn(context);
                      })));
            } else {
              saveDataToFireBase().then((value) {
                saveDataToSharedPreferences().then((value) {
                  setSignIn().then((value) {
                    googleController.success();
                    handleAfterSignIn(context);
                  });
                });
              });
            }
          });
        }
      });
    }
  }


  Future getUserDataFromFirebase(uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) => {
              _uid = snapshot["uid"],
              _name = snapshot["name"],
              _email = snapshot["email"],
              _imageUrl = snapshot["imageUrl"],
              _provider = snapshot["provider"],
            });
  }

  Future saveDataToFireBase() async {
    final DocumentReference r =
        FirebaseFirestore.instance.collection("users").doc(uid);
    await r.set({
      "name": _name,
      "email": _email,
      "imageUrl": _imageUrl,
      "provider": _provider,
      "uid": _uid,
    });
    emit(SaveDataToFireBaseState());
  }

  Future saveDataToSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("name", _name!);
    await s.setString("email", _email!);
    await s.setString("imageUrl", _imageUrl!);
    await s.setString("provider", _provider!);
    await s.setString("uid", _uid!);
    emit(SaveDataToSharedPreferncesState());
  }

  Future getDataFromSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _name = s.getString("name");
    _email = s.getString("email");
    _imageUrl = s.getString("imageUrl");
    _provider = s.getString("provider");
    _uid = s.getString("uid");
    emit(GetDataFromSharedPreferencesState());
  }

  Future<bool> checkIfUserExists() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("users").doc(_uid).get();
    if (snap.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future userSignOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
    _isSignedIn = false;
    emit(SignOutState());
    clearStoredData();
  }

  Future clearStoredData() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.clear();
  }
  
}
