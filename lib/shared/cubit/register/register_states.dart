abstract class AppRegisterStates {}

class RegisterInitialState extends AppRegisterStates {}

class RegisterLoadingState extends AppRegisterStates {}

class RegisterSuccessState extends AppRegisterStates {}

class RegisterErrorState extends AppRegisterStates {

  final String error;

  RegisterErrorState(this.error);

}

class CreateUserSuccessState extends AppRegisterStates {}

class CreateUserErrorState extends AppRegisterStates {

  final String error;

  CreateUserErrorState(this.error);

}

class RegisterChangePasswordState extends AppRegisterStates {}
