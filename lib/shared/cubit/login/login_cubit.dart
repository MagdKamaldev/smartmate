// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartmate/shared/cubit/login/login_states.dart';
import 'package:smartmate/shared/networks/local/cache_helper.dart';
import '../../../layout/home_layout.dart';
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

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

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
              await getUserDataFromFirebase(uid).then((value) =>
                  saveDataToSharedPreferences()
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
    clearStoredData();
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
                                  await getUserDataFromFirebase(uid).then(
                                      (value) => saveDataToSharedPreferences()
                                          .then((value) =>
                                              setSignIn().then((value) {
                                                navigateAndFinish(
                                                    context, HomeScreen());
                                              })));
                                } else {
                                  saveDataToFireBase().then((value) {
                                    saveDataToSharedPreferences().then((value) {
                                      setSignIn().then((value) {
                                        navigateAndFinish(
                                            context, HomeScreen());
                                      });
                                    });
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

  void phoneNumberUser(User user, email, name) {
    _name = name;
    _email = email;
    _imageUrl =
        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn4.iconfinder.com%2Fdata%2Ficons%2Fsocial-messaging-ui-color-and-shapes-3%2F177800%2F129-512.png&f=1&nofb=1&ipt=2e57bbfa1aa643cb1b506496b21cf4ddc891d8110ceb9c6a944ddc35a3e49b26&ipo=images";
    _uid = user.phoneNumber;
    _provider = "Phone";
    _isSignedIn = true;
    emit(SavePhoneAuthDataState());
  }

  //                              email and password
  void userLogin({required String email, required String password, context}) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      CacheHelper.saveData(key: "uid", value: "user");
      navigateTo(context, HomeScreen());
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error) {
      showToast(text: error.toString(), state: ToasStates.error);
      emit(LoginErrodState(error.toString()));
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
