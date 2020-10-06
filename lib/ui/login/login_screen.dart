import 'package:bartender/blocs/list/drinks_list_cubit.dart';
import 'package:bartender/blocs/login/login_cubit.dart';
import 'package:bartender/blocs/login/login_states.dart';
import 'package:bartender/data/api/api_client.dart';
import 'package:bartender/data/repository/bartender_repository.dart';
import 'package:bartender/ui/list/drinks_list_screen.dart';
import 'package:bartender/ui/list/filters_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../backdrop.dart';

class LoginScreen extends StatefulWidget {
  @override
  State createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  void _handleSignIn() {
    final loginCubit = context.cubit<LoginCubit>();
    loginCubit.signIn();
  }

  //Future<void> _handleSignOut() => _googleSignIn.disconnect();//todo use for sign out button

  Widget _buildBody(LoginState state) {
    if (state is LoginEmpty) {
      return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [gradientStartColor, gradientEndColor],
          )),
          child: Stack(
            children: [
              _buildWelcomeImage(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[_buildWelcomeTexts(), _buildSignInButton()],
              )
            ],
          ));
    } else {
      //login success/ already logged in/ initial
      return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [gradientStartColor, gradientEndColor],
          )),
          child: Center(
            child: CircularProgressIndicator(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CubitConsumer<LoginCubit, LoginState>(
        builder: (context, state) {
          return _buildBody(state);
        },
        listener: (context, state) {
          if (state is AlreadyLoggedIn || state is LoginSuccess) {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return CubitProvider<DrinksListCubit>(
                create: (context) => DrinksListCubit(
                    repository: BartenderRepository(apiClient: ApiClient())),
                child: DrinksListScreen(),
              );
            }), (Route<dynamic> route) => false);
          } else {
            return _buildBody(state);
          }
        },
      ),
    );
  }

  Widget _buildWelcomeImage() {
    return Center(
      child: Container(
          margin: EdgeInsets.all(12),
          child: Image.asset(
            'assets/images/alcohol.png',
            fit: BoxFit.contain,
          )),
    );
  }

  Widget _buildWelcomeTexts() {
    return Container(
        margin: EdgeInsets.all(24),
        height: 200,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                    height: double.infinity,
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                            fontSize: 56,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500),
                      ),
                    ))),
            Expanded(
                flex: 3,
                child: Container(
                  height: double.infinity,
                  child: Text(
                    'The Bartender will offer you creative drinks ideas. Are you ready to be impressed?',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ))
          ],
        ));
  }

  Widget _buildSignInButton() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 48, bottom: 24, left: 24, right: 24),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.white, width: 2)),
            padding: EdgeInsets.only(left: 56, right: 56, top: 16, bottom: 16),
            onPressed: () => {_handleSignIn()},
            color: iconColor,
            child: PlatformText(
              'Join with Google',
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Poppins', fontSize: 16),
            ),
          ),
        ));
  }
}
