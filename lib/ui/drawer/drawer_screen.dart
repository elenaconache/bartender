import 'dart:io';

import 'package:bartender/blocs/list/drinks_list_cubit.dart';
import 'package:bartender/blocs/login/login_cubit.dart';
import 'package:bartender/blocs/logout/logout_cubit.dart';
import 'package:bartender/blocs/logout/logout_state.dart';
import 'package:bartender/constants.dart';
import 'package:bartender/dependency_injection.dart';
import 'package:bartender/i18n/bartender_localizations.dart';
import 'package:bartender/ui/backdrop.dart';
import 'package:bartender/ui/drawer/drawer_item.dart';
import 'package:bartender/ui/favorites_screen.dart';
import 'package:bartender/ui/list/drinks_list_screen.dart';
import 'package:bartender/ui/list/filters_panel.dart';
import 'package:bartender/ui/login_screen.dart';
import 'package:bartender/ui/profile_screen.dart';
import 'package:bartender/ui/stats_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DrawerScreen extends StatefulWidget {
  DrawerScreen();

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen>
    with SingleTickerProviderStateMixin {
  int _drawerSelectionIndex = 1;
  var _drawerItems;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _drawerItems = [
      DrawerItem(BartenderLocalizations.of(context).profileLabel,
          Icons.account_circle),
      DrawerItem(
          BartenderLocalizations.of(context).drinksLabel, Icons.local_bar),
      DrawerItem(
          BartenderLocalizations.of(context).statsLabel, Icons.show_chart),
      DrawerItem(
          BartenderLocalizations.of(context).favoritesLabel, Icons.favorite),
      DrawerItem(
          BartenderLocalizations.of(context).logoutLabel, Icons.exit_to_app)
    ];
  }

  Widget _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return ProfileScreen();
      case 1:
        return CubitProvider<DrinksListCubit>(
          create: (context) => getIt.get<DrinksListCubit>(),
          child: DrinksListScreen(),
        );
      case 2:
        return StatsScreen();
      case 3:
        return FavoritesScreen();
    }
    return null;
  }

  _onSelectItem(BuildContext context, int index) {
    if (index == 4) {
      Navigator.of(context).pop();
      if (Platform.isAndroid) {
        showMaterialLogoutDialog(context);
      } else if (Platform.isIOS) {
        showCupertinoLogoutDialog(context);
      }
    } else {
      setState(() => _drawerSelectionIndex = index);
      Navigator.of(context).pop();
    }
    // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return CubitConsumer<LogoutCubit, LogoutState>(
      builder: (context, state) {
        return _buildDrawerScreen(context, state);
      },
      listener: (context, state) {
        if (state is LogoutFinished) {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return CubitProvider<LoginCubit>(
              create: (context) => getIt.get<LoginCubit>(),
              child: LoginScreen(),
            );
          }), (Route<dynamic> route) => false);
        } else {
          return _buildDrawerScreen(context, state);
        }
      },
    );
  }

  Widget _buildBackTitle(String text) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontSize: 20),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size(double.infinity, kToolbarHeight),
      child: Builder(
        builder: (context) => AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: _drawerSelectionIndex == 0
              ? gradientStartColor
              : Colors.transparent,
          leading: IconButton(
            onPressed: () => {Scaffold.of(context).openDrawer()},
            iconSize: 30,
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
          title: _buildBackTitle(_drawerItems[_drawerSelectionIndex].title),
          actionsIconTheme: IconThemeData(
            size: 30.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  showMaterialLogoutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(BartenderLocalizations.of(context).logoutLabel),
              content:
                  new Text(BartenderLocalizations.of(context).logoutMessage),
              actions: <Widget>[
                FlatButton(
                  child: PlatformText(BartenderLocalizations.of(context).yes,
                      style: TextStyle(color: gradientStartColor)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _logout();
                  },
                ),
                FlatButton(
                  child: PlatformText(
                    BartenderLocalizations.of(context).no,
                    style: TextStyle(color: gradientStartColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Future<void> _logout() async {
    final logoutCubit = context.cubit<LogoutCubit>();
    logoutCubit.logout();
  }

  showCupertinoLogoutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: new Text(BartenderLocalizations.of(context).logoutLabel),
              content:
                  new Text(BartenderLocalizations.of(context).logoutMessage),
              actions: <Widget>[
                FlatButton(
                  child: Text(BartenderLocalizations.of(context).yes,
                      style: TextStyle(color: gradientStartColor)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _logout();
                  },
                ),
                FlatButton(
                  child: Text(BartenderLocalizations.of(context).no,
                      style: TextStyle(color: gradientStartColor)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Widget _buildDrawerScreen(BuildContext context, LogoutState state) {
    if (state is LogoutLoading) {
      return _buildDrawerScreenLoading();
    } else {
      if (MediaQuery.of(context).orientation == Orientation.landscape) {
        return _buildDrawerScreenInitialLandscape();
      } else {
        return _buildDrawerScreenInitial();
      }
    }
  }

  Widget _buildDrawerScreenInitial() {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < _drawerItems.length; i++) {
      var d = _drawerItems[i];
      drawerOptions.add(
        _buildDrawerOptionTile(d, i),
      );
    }
    return Container(
        decoration: BoxDecoration(gradient: blueGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(),
          drawer: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            child: Drawer(
              child: new Column(
                children: <Widget>[
                  Container(
                      child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      gradient: blueGradient,
                    ),
                    accountName: new Text(
                        getIt.get<GoogleSignIn>().currentUser.displayName,
                        style: whiteSmallTextStyle),
                    accountEmail: Text(
                      getIt.get<GoogleSignIn>().currentUser.email,
                      style: whiteExtraSmallTextStyle,
                    ),
                  )),
                  new Column(children: drawerOptions)
                ],
              ),
            ),
          ),
          body: _getDrawerItemWidget(_drawerSelectionIndex),
        ));
  }

  Widget _buildDrawerScreenInitialLandscape() {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < _drawerItems.length; i++) {
      var d = _drawerItems[i];
      drawerOptions.add(
        _buildDrawerOptionTileLandscape(d, i),
      );
    }
    return Container(
        decoration: BoxDecoration(gradient: blueGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(),
          drawer: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            child: Drawer(
              child: new Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(24.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: blueGradient,
                      ),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                getIt
                                    .get<GoogleSignIn>()
                                    .currentUser
                                    .displayName,
                                style: whiteSmallTextStyle)),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              getIt.get<GoogleSignIn>().currentUser.email,
                              style: whiteExtraSmallTextStyle,
                            )),
                      ])),
                  Column(
                    children: drawerOptions,
                  )
                ],
              ),
            ),
          ),
          body: _getDrawerItemWidget(_drawerSelectionIndex),
        ));
  }

  Widget _buildDrawerOptionTile(DrawerItem d, int index) {
    return Container(
      child: ListTile(
        leading: new Icon(
          d.icon,
          color: _drawerSelectionIndex == index
              ? gradientStartColor
              : dropdownArrowColor,
        ),
        title: Text(
          d.title,
          style: TextStyle(
              color: _drawerSelectionIndex == index
                  ? gradientStartColor
                  : dropdownArrowColor),
        ),
        selected: index == _drawerSelectionIndex,
        onTap: () => _onSelectItem(context, index),
      ),
    );
  }

  Widget _buildDrawerOptionTileLandscape(DrawerItem d, int index) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: new Icon(
          d.icon,
          color: _drawerSelectionIndex == index
              ? gradientStartColor
              : dropdownArrowColor,
        ),
        title: Text(
          d.title,
          style: TextStyle(
              color: _drawerSelectionIndex == index
                  ? gradientStartColor
                  : dropdownArrowColor),
        ),
        selected: index == _drawerSelectionIndex,
        onTap: () => _onSelectItem(context, index),
      ),
    );
  }

  Widget _buildDrawerScreenLoading() {
    return Container(
        decoration: BoxDecoration(gradient: blueGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(),
          body: CircularProgressIndicator(),
        ));
  }
}
