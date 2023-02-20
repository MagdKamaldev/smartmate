abstract class LoginStates{}

class LoginInitalState extends LoginStates{}

class CheckSignInState extends LoginStates{}

class SetSignInState extends LoginStates{}

class SignInWithGoogleSuccesState extends LoginStates{}

class SignInWithGoogleErrorState extends LoginStates{}

class SaveDataToFireBaseState extends LoginStates{}

class SaveDataToSharedPreferncesState extends LoginStates{}

class GetDataFromSharedPreferencesState extends LoginStates{}

class SignOutState extends LoginStates{}

class CheckCinnectionState extends LoginStates{}

class SavePhoneAuthDataState extends LoginStates{}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final String uId;
  LoginSuccessState(this.uId);
}

class LoginErrodState extends LoginStates {
  final String error;

  LoginErrodState(this.error);
}

class LoginChangePasswordState extends LoginStates {}
