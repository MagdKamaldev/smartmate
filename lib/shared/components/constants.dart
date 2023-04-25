import '../../modules/login/login_screen.dart';
import '../cubit/login/login_cubit.dart';
import 'components.dart';

void signOut(context) {
   LoginCubit.get(context).userSignOut(context).then((value) {
      Future.delayed(Duration(seconds: 3)).then((value) {
    navigateAndFinish(context, LoginScreen());
  });
    });
}

dynamic uId = "";
