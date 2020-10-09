import 'package:bartender/blocs/logout/logout_state.dart';
import 'package:bartender/data/repository/google_signin_repository.dart';
import 'package:cubit/cubit.dart';
import 'package:meta/meta.dart';

class LogoutCubit extends CubitStream<LogoutState> {
  final GoogleSignInRepository repository;

  LogoutCubit({@required this.repository})
      : assert(repository != null),
        super(LogoutInitial()) {
    emit(LogoutInitial());
  }

  void logout() async {
    try {
      emit(LogoutLoading());
      await repository.signOut();
      emit(LogoutFinished());
    } catch (e) {
      print(e);
      emit(LogoutFinished());
    }
  }
}
