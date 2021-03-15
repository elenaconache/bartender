import 'dart:io';

import 'package:bartender/blocs/favorites/favorites_cubit.dart';
import 'package:bartender/blocs/list/drinks_list_cubit.dart';
import 'package:bartender/blocs/login/login_cubit.dart';
import 'package:bartender/blocs/logout/drawer_cubit.dart';
import 'package:bartender/blocs/logout/drawer_state.dart';
import 'package:bartender/blocs/profile/profile_cubit.dart';
import 'package:bartender/blocs/stats/stats_cubit.dart';
import 'package:bartender/constants.dart';
import 'package:bartender/data/repository/shared_preferences_repository.dart';
import 'package:bartender/dependency_injection.dart';
import 'package:bartender/i18n/bartender_localizations.dart';
import 'package:bartender/theme/colors.dart';
import 'package:bartender/theme/theme_helper.dart';
import 'package:bartender/ui/drawer/drawer_item.dart';
import 'package:bartender/ui/favorites/favorites_screen.dart';
import 'package:bartender/ui/list/drinks_list_screen.dart';
import 'package:bartender/ui/login_screen.dart';
import 'package:bartender/ui/profile_screen.dart';
import 'package:bartender/ui/stats/stats_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatefulWidget {
  final User currentUser;

  DrawerScreen(this.currentUser);

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
        return CubitProvider<ProfileCubit>(
          create: (context) => getIt.get<ProfileCubit>(),
          child: ProfileScreen(),
        );
      case 1:
        return CubitProvider<DrinksListCubit>(
          create: (context) => getIt.get<DrinksListCubit>(),
          child: DrinksListScreen(),
        );
      case 2:
        return CubitProvider<StatsCubit>(
          create: (context) => getIt.get<StatsCubit>(),
          child: StatsScreen(),
        );
      // return StatsScreen();
      case 3:
        return CubitProvider<FavoritesCubit>(
          create: (context) => getIt.get<FavoritesCubit>(),
          child: FavoritesScreen(),
        );
    }
    return CubitProvider<DrinksListCubit>(
      create: (context) => getIt.get<DrinksListCubit>(),
      child: DrinksListScreen(),
    );
  }

  _onSelectItem(BuildContext context, int index) {
    print("selected drawer item with index $index");
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
  }

  @override
  Widget build(BuildContext context) {
    print("build drawer screen");
    return ChangeNotifierProvider<ThemeHelper>(create: (context) {
      return getIt.get<ThemeHelper>();
    }, child: Consumer<ThemeHelper>(builder: (context, model, _) {
      return CubitConsumer<LogoutCubit, DrawerScreenState>(
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
    }));
  }

  Widget _buildBackTitle(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline2,
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size(double.infinity, kToolbarHeight),
      child: Builder(
        builder: (context) => AppBar(
          iconTheme: Theme.of(context).iconTheme,
          textTheme: Theme.of(context).textTheme,
          backgroundColor: _drawerSelectionIndex == 0
              ? getIt.get<ThemeHelper>().currentTheme == BartenderTheme.LIGHT
                  ? gradientStartColor
                  : gradientStartColorDark
              : Colors.transparent,
          leading: IconButton(
            onPressed: () => {Scaffold.of(context).openDrawer()},
            iconSize: 30,
            icon: Icon(
              Icons.menu,
            ),
          ),
          title: _buildBackTitle(_drawerItems[_drawerSelectionIndex].title),
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
                  child: Text(BartenderLocalizations.of(context).yes,
                      style: TextStyle(
                          color: getIt.get<ThemeHelper>().currentTheme ==
                                  BartenderTheme.LIGHT
                              ? gradientStartColorDark
                              : gradientStartColor)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _logout();
                  },
                ),
                FlatButton(
                  child: Text(
                    BartenderLocalizations.of(context).no,
                    style: TextStyle(
                        color: getIt.get<ThemeHelper>().currentTheme ==
                                BartenderTheme.LIGHT
                            ? gradientStartColorDark
                            : gradientStartColor),
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
                      style: TextStyle(
                          color: getIt.get<ThemeHelper>().currentTheme ==
                                  BartenderTheme.LIGHT
                              ? gradientStartColorDark
                              : gradientStartColor)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _logout();
                  },
                ),
                FlatButton(
                  child: Text(BartenderLocalizations.of(context).no,
                      style: TextStyle(
                          color: getIt.get<ThemeHelper>().currentTheme ==
                                  BartenderTheme.LIGHT
                              ? gradientStartColorDark
                              : gradientStartColor)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Widget _buildDrawerScreen(BuildContext context, DrawerScreenState state) {
    print("drawer screen logout state $state");
    if (state is DrawerLoading) {
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
        decoration: BoxDecoration(
            gradient:
                getIt.get<ThemeHelper>().currentTheme == BartenderTheme.LIGHT
                    ? lightBlueGradient
                    : blueGradient),
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
                  Expanded(
                    flex: 1,
                    child: Container(
                        decoration: BoxDecoration(
                            gradient: getIt.get<ThemeHelper>().currentTheme ==
                                    BartenderTheme.LIGHT
                                ? lightBlueGradient
                                : blueGradient),
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                      widget.currentUser == null
                                          ? ""
                                          : widget.currentUser.displayName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                  Text(
                                    widget.currentUser == null
                                        ? ""
                                        : widget.currentUser.email,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ))),
                  ),
                  Expanded(
                      flex: 3,
                      child: Container(
                        color: getIt.get<ThemeHelper>().currentTheme ==
                                BartenderTheme.DARK
                            ? Colors.black54
                            : Colors.white,
                        child: Column(
                          children: drawerOptions,
                          mainAxisSize: MainAxisSize.max,
                        ),
                      ))
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
        decoration: BoxDecoration(
            gradient:
                getIt.get<ThemeHelper>().currentTheme == BartenderTheme.LIGHT
                    ? lightBlueGradient
                    : blueGradient),
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
                          gradient: getIt.get<ThemeHelper>().currentTheme ==
                                  BartenderTheme.LIGHT
                              ? lightBlueGradient
                              : blueGradient),
                      child: Column(mainAxisSize: MainAxisSize.max, children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                widget.currentUser == null
                                    ? ""
                                    : widget.currentUser.displayName,
                                style: Theme.of(context).textTheme.bodyText1)),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.currentUser == null
                                  ? ""
                                  : widget.currentUser.email,
                              style: Theme.of(context).textTheme.bodyText2,
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
              ? getIt.get<ThemeHelper>().currentTheme == BartenderTheme.LIGHT
                  ? gradientStartColorDark
                  : gradientStartColor
              : dropdownArrowColor,
        ),
        title: Text(
          d.title,
          style: TextStyle(
              color: _drawerSelectionIndex == index
                  ? getIt.get<ThemeHelper>().currentTheme ==
                          BartenderTheme.LIGHT
                      ? gradientStartColorDark
                      : gradientStartColor
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
              ? getIt.get<ThemeHelper>().currentTheme == BartenderTheme.LIGHT
                  ? gradientStartColorDark
                  : gradientStartColor
              : dropdownArrowColor,
        ),
        title: Text(
          d.title,
          style: TextStyle(
              color: _drawerSelectionIndex == index
                  ? getIt.get<ThemeHelper>().currentTheme ==
                          BartenderTheme.LIGHT
                      ? gradientStartColorDark
                      : gradientStartColor
                  : dropdownArrowColor),
        ),
        selected: index == _drawerSelectionIndex,
        onTap: () => _onSelectItem(context, index),
      ),
    );
  }

  Widget _buildDrawerScreenLoading() {
    return Container(
        decoration: BoxDecoration(
            gradient:
                getIt.get<ThemeHelper>().currentTheme == BartenderTheme.LIGHT
                    ? lightBlueGradient
                    : blueGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(),
          body: CircularProgressIndicator(),
        ));
  }
}
