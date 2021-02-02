import 'package:bartender/blocs/profile/profile_states.dart';
import 'package:bartender/data/repository/google_signin_repository.dart';
import 'package:bartender/main.dart';
import 'package:cubit/cubit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

const String profileAvatarDirectory = "avatars";

class ProfileCubit extends CubitStream<ProfileState> {
  final GoogleSignInRepository repository;

  ProfileCubit({@required this.repository})
      : assert(repository != null),
        super(ProfileLoading());

  void getInitialData() async{
    //try {
      emit(ProfileLoading());

      var user = getCurrentUser();
      if(user != null){
        try {
          if (FirebaseStorage.instance.ref().child(user.uid) != null) {
            String url = await FirebaseStorage.instance
                .ref()
                .child("$profileAvatarDirectory/${user.uid}")
                .getDownloadURL();
            emit(ProfileSuccess(user, url));
          } else {
            emit(ProfileIncomplete(user));
          }
        } on Exception catch (e) {
          print(e.toString());
          emit(ProfileIncomplete(user));
        }
      }else{
        emit(ProfileEmpty());
      }

      /*repository.checkAlreadySignedIn(onAccount: (account) async {
        if (account != null) {
          print(account.toString());
          try {
            if (FirebaseStorage.instance.ref().child(account.id) != null) {
              String url = await FirebaseStorage.instance
                  .ref()
                  .child("$profileAvatarDirectory/${account.id}")
                  .getDownloadURL();
              emit(ProfileSuccess(account, url));
            } else {
              emit(ProfileIncomplete(account));
            }
          } on Exception catch (e) {
            print(e.toString());
            emit(ProfileIncomplete(account));
          }
        } else {
          emit(ProfileEmpty());
        }
      }, onError: (Object exception) {
        print(exception.toString());
        emit(ProfileError());
      });
    } catch (e) {
      print(e.toString());
      emit(ProfileError());
    }*/
  }
}
