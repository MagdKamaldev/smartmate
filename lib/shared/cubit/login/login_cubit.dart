// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartmate/shared/cubit/login/login_states.dart';
import 'package:smartmate/shared/networks/local/cache_helper.dart';
import '../../../layout/home_layout.dart';
import '../../../models/user_model.dart';
import '../../components/components.dart';
import '../../styles/colors.dart';

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

  SignInProvider() {
    checkSignIn();
  }

  //                                   google

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

        createUser(
            name: userDetails.displayName!,
            email: userDetails.email!,
            phone: "null",
            uId: userDetails.uid,
            image: userDetails.photoURL);
        _provider = "Google";
        _uid = userDetails.uid;
        _isSignedIn = true;

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
        HomeScreen(),
      );
    });
  }

  Future handleGoogleSignIn(googleController, context) async {
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
              await setSignIn().then((value) {
                googleController.success();
                handleAfterSignIn(context);
              });
            } else {
              setSignIn().then((value) {
                googleController.success();
                handleAfterSignIn(context);
              });
            }
          });
        }
      });
    }
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

  Future userSignOut(context) async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
    _isSignedIn = false;
    clearStoredData();
    showDialog(
        context: context,
        builder: (context) => LottieBuilder.network(
            "https://assets7.lottiefiles.com/packages/lf20_ztxhxdwa.json"));

    emit(SignOutState());
  }

  Future clearStoredData() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.clear();
    CacheHelper.saveData(key: "onBoarding", value: true);
  }

  //                            phone number

  Future phoneLogin(
    BuildContext context,
    String number,
    GlobalKey<FormState> formKey,
    TextEditingController otpCodeController,
    TextEditingController emailController,
    TextEditingController nameController,
  ) async {
    await checkInternetConnection();
    if (hasInternet == false) {
      openSnackBar(context, "Check your Connection", Colors.red);
    } else {
      if (formKey.currentState!.validate()) {
        FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: number,
            verificationCompleted: (AuthCredential credential) async {
              await FirebaseAuth.instance.signInWithCredential(credential);
            },
            verificationFailed: (FirebaseAuthException error) {
              openSnackBar(context, error.toString(), Colors.red);
            },
            codeSent: (String verificationId, int? forceResendingToken) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Enter Code"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: otpCodeController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.code),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: defaultColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.grey)),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: defaultColor,
                            ),
                            onPressed: () async {
                              final code = otpCodeController.text.trim();
                              AuthCredential authCredential =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: code);
                              User user = (await FirebaseAuth.instance
                                      .signInWithCredential(authCredential))
                                  .user!;
                              phoneNumberUser(user, emailController.text,
                                  nameController.text);
                              //checking if the user exists

                              checkIfUserExists().then((value) async {
                                if (value == true) {
                                  await setSignIn().then((value) {
                                    navigateAndFinish(context, HomeScreen());
                                  });
                                } else {
                                  setSignIn().then((value) {
                                    navigateAndFinish(context, HomeScreen());
                                  });
                                }
                              });
                            },
                            child: const Text("confirm"),
                          ),
                        ],
                      ),
                    );
                  });
            },
            codeAutoRetrievalTimeout: (String verification) {});
      }
    }
  }

  void createUser({
    required String name,
    required String email,
    required String phone,
    required String uId,
    String? image,
  }) {
    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      image: image == "null"
          ? "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn4.iconfinder.com%2Fdata%2Ficons%2Fsocial-messaging-ui-color-and-shapes-3%2F177800%2F129-512.png&f=1&nofb=1&ipt=2e57bbfa1aa643cb1b506496b21cf4ddc891d8110ceb9c6a944ddc35a3e49b26&ipo=images"
          : image,
      uid: uId,
    );

    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      CacheHelper.saveData(key: "uid", value: uId);
      emit(CreateUserLoginSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CreateUserLoginErrorState());
    });
  }

  void phoneNumberUser(User user, email, name) {
    createUser(
        name: name,
        email: email,
        phone: user.phoneNumber!,
        uId: user.phoneNumber!,
        image:
            "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn4.iconfinder.com%2Fdata%2Ficons%2Fsocial-messaging-ui-color-and-shapes-3%2F177800%2F129-512.png&f=1&nofb=1&ipt=2e57bbfa1aa643cb1b506496b21cf4ddc891d8110ceb9c6a944ddc35a3e49b26&ipo=images");

    _provider = "Phone";
    _isSignedIn = true;
    emit(SavePhoneAuthDataState());
  }

  //                              email and password

  void userLogin({required String email, required String password, context}) {
    showDialog(
        context: context,
        builder: (context) => LottieBuilder.network(
            "https://assets7.lottiefiles.com/packages/lf20_ztxhxdwa.json"));

    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      CacheHelper.saveData(key: "uid", value: value.user!.uid);
      Future.delayed(const Duration(seconds: 3)).then((value) {
        navigateAndFinish(
          context,
          HomeScreen(),
        );
      });
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error) {
      if (context != null)
        showToast(text: error.toString(), state: ToasStates.error);
      emit(LoginErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(LoginChangePasswordState());
  }
}
