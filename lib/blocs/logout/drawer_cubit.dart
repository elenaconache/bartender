import 'package:bartender/blocs/logout/drawer_state.dart';
import 'package:bartender/data/repository/google_signin_repository.dart';
import 'package:cubit/cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class LogoutCubit extends CubitStream<DrawerScreenState> {
  final GoogleSignInRepository repository;

  LogoutCubit({@required this.repository})
      : assert(repository != null),
        super(DrawerInitial());

 /* void getUser() async {
    emit(DrawerLoading());
    FirebaseUser user = await repository.getCurrentUser();
    emit(AccountLoaded(user));
  }*/

  void logout() async {
    try {
      emit(DrawerLoading());
      await repository.signOut();
      emit(LogoutFinished());
    } catch (e) {
      print(e);
      emit(LogoutFinished());
    }
  }
}
