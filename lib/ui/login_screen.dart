import 'package:bartender/blocs/login/login_cubit.dart';
import 'package:bartender/blocs/login/login_states.dart';
import 'package:bartender/blocs/logout/logout_cubit.dart';
import 'package:bartender/constants.dart';
import 'package:bartender/dependency_injection.dart';
import 'package:bartender/i18n/bartender_localizations.dart';
import 'package:bartender/ui/detail/drink_details_screen.dart';
import 'package:bartender/ui/drawer/drawer_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  State createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  void _handleSignIn() {
    final loginCubit = context.cubit<LoginCubit>();
    loginCubit.signIn();
  }

  Widget _buildBody(LoginState state) {
    if (state is LoginEmpty) {
      return Container(
          height: double.infinity,
          width: double.infinity,
          color: blueTextColor,
          child: Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/coffee.jpg',
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: _buildWelcomeTextsPortrait(),
                      )
                    ],
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.all(24),
                      child: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? _buildPortraitLoginForm()
                          : _buildLandscapeLoginForm()))
            ],
          ));
    } else {
      //login success/ already logged in/ initial
      return Container(
          decoration: BoxDecoration(gradient: blueGradient),
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
              return CubitProvider<LogoutCubit>(
                create: (context) => getIt.get<LogoutCubit>(),
                child: DrawerScreen(),
              );
            }), (Route<dynamic> route) => false);
          } else {
            return _buildBody(state);
          }
        },
      ),
    );
  }

  Widget _buildWelcomeTextsPortrait() {
    return Container(
        margin: EdgeInsets.all(12),
        child: RotatedBox(
          quarterTurns: 1,
          child: Text(
            BartenderLocalizations.of(context).bartenderAppName,
            style: TextStyle(
              fontSize: 48,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
        ));
  }

  Widget _buildSignInButton() {
    return Container(
      width: double.infinity,
      height: 48,
      margin: EdgeInsets.only(top: 24, bottom: 24, left: 8, right: 8),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: blueTextColor)),
        padding: EdgeInsets.only(left: 56, right: 56, top: 16, bottom: 16),
        onPressed: () => {_handleSignIn()},
        color: blueTextColor,
        child: PlatformText(
          BartenderLocalizations.of(context).actionGoogle,
          style: whiteExtraSmallTextStyle,
        ),
      ),
    );
  }

  Widget _buildLandscapeLoginForm() {
    return Container(
      margin: EdgeInsets.only(left: 80, right: 80),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 12),
                child: Icon(
                  Icons.account_circle_sharp,
                  size: 64,
                )),
            Text(
              BartenderLocalizations.of(context).titleWelcome,
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500),
            ),
            Text(
              'Please sign in to continue',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
            ),
            Spacer(),
            Padding(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: _buildSignInButton())
          ],
        ),
      ),
    );
  }

  Widget _buildPortraitLoginForm() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 24),
                child: Icon(
                  Icons.account_circle_sharp,
                  size: 64,
                )),
            Text(
              BartenderLocalizations.of(context).titleWelcome,
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500),
            ),
            Text(
              'Please sign in to continue',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
            ),
            Spacer(),
            Padding(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: _buildSignInButton())
          ],
        ),
      ),
    );
  }
}
