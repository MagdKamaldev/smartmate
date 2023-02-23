import '../../modules/login/login_screen.dart';
import '../cubit/login/login_cubit.dart';
import 'components.dart';

void signOut(context){
    LoginCubit.get(context).userSignOut().then((value) {
                  navigateAndFinish(context, LoginScreen());
                });
}

