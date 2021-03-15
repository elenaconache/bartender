import 'package:bartender/blocs/profile/profile_states.dart';
import 'package:bartender/data/models/drink.dart';
import 'package:bartender/data/repository/database_repository.dart';
import 'package:bartender/data/repository/google_signin_repository.dart';
import 'package:bartender/main.dart';
import 'package:cubit/cubit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

const String profileAvatarDirectory = "avatars";

class ProfileCubit extends CubitStream<ProfileState> {
  final GoogleSignInRepository signInRepository;
  final DatabaseRepository databaseRepository;

  ProfileCubit(
      {@required this.signInRepository, @required this.databaseRepository})
      : super(ProfileLoading());

  void getInitialData() async {
    emit(ProfileLoading());
    var drinks;
    try {
      drinks = await databaseRepository.getFavoriteDrinks();
    } catch (e) {
      drinks = [] as List<Drink>;
    }

    var user = getCurrentUser();
    if (user != null) {
      try {
        if (FirebaseStorage.instance.ref().child(user.uid) != null) {
          String url = await FirebaseStorage.instance
              .ref()
              .child("$profileAvatarDirectory/${user.uid}")
              .getDownloadURL();

          emit(ProfileSuccess(user, url, drinks));
        } else {
          emit(ProfileIncomplete(user, drinks));
        }
      } on Exception catch (e) {
        print(e.toString());
        emit(ProfileIncomplete(user, drinks));
      }
    } else {
      emit(ProfileEmpty());
    }
  }
}
