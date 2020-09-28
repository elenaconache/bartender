import 'package:bartender/blocs/detail/drink_cubit.dart';
import 'package:bartender/blocs/detail/drink_state.dart';
import 'package:bartender/data/models/drink.dart';
import 'package:bartender/ui/detail/drink_persistent_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

import '../backdrop.dart';

const Color blueTextColor = Color(0xff004861);

class DrinkDetailsScreen extends StatefulWidget {
  final Drink drink;

  DrinkDetailsScreen(this.drink);

  @override
  _DrinkDetailsScreenState createState() => _DrinkDetailsScreenState();
}

//todo include refresh for detail request
class _DrinkDetailsScreenState extends State<DrinkDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _getDrinkDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CubitConsumer<DrinkCubit, DrinkState>(builder: (context, state) {
      return _buildWidget(state);
    }, listener: (context, state) {
      return _buildWidget(state);
    }));
  }

  Widget _buildWidget(DrinkState state) {
    if (state is DrinkLoading) {
      return _buildLoadingWidget(MediaQuery.of(context).orientation);
    } else if (state is DrinkError) {
      return _buildErrorWidget(MediaQuery.of(context).orientation);
    } else if (state is DrinkSuccess) {
      return _buildSuccessWidget(
          MediaQuery.of(context).orientation, state.drink);
    } else {
      return Container(); //todo unknown state view
    }
  }

  Widget _buildSuccessWidget(Orientation orientation, Drink drink) {
    //if (orientation == Orientation.portrait){
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [gradientStartColor, gradientEndColor],
        )),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              floating: false,
              pinned: true,
              delegate: DrinkPersistentHeader(
                  collapsedHeight: 56,
                  expandedHeight: 300,
                  paddingTop: 4,
                  drink: drink),
            ),
            SliverToBoxAdapter(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildTagsWidgets(drink),
                _buildLabelWidget('Instructions'),
                _buildTextWidget(drink.instructions),
              ],
            ))
          ],
        ));
    // }else{//todo different widget
  }

  Widget _buildLoadingWidget(Orientation orientation) {
    //if (orientation == Orientation.portrait){
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        height: 300,
        child: Hero(
          tag: widget.drink.imageURL,
          child: CachedNetworkImage(
            imageUrl: widget.drink.imageURL,
            placeholder: (context, url) => Center(
              child: SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Text(
        widget.drink.name,
        style: TextStyle(fontSize: 20),
      ),
      Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(),
        ),
      ),
    ]);
    // }else{//todo different widget
  }

  Widget _buildErrorWidget(Orientation orientation) {
    //if (orientation == Orientation.portrait){
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        height: 300,
        child: Hero(
          tag: widget.drink.imageURL,
          child: CachedNetworkImage(
            imageUrl: widget.drink.imageURL,
            placeholder: (context, url) => Center(
              child: SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Text(
        widget.drink.name,
        style: TextStyle(fontSize: 22, fontFamily: 'Poppins'),
      ),
      Text("No more data available"),
    ]);
    // }else{//todo different widget
  }

  Future<void> _getDrinkDetail() async {
    final drinkCubit = context.cubit<DrinkCubit>();
    drinkCubit.getDrinkData(widget.drink.id);
  }

  Widget _buildTagsWidgets(Drink drink) {
    return Container(
        margin: EdgeInsets.only(top: 12, left: 24, right: 24),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _buildTagWidget(drink.alcoholic, Icons.pan_tool),
          _buildTagWidget(drink.glass, Icons.local_drink),
          _buildTagWidget(drink.category, Icons.category),
        ]));
  }

  Widget _buildLabelWidget(String s) {
    return Padding(
      padding: EdgeInsets.only(left: 24, top: 12, right: 24),
      child: Text(
        s,
        style: TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.normal,
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTextWidget(String text) {
    return Padding(
        padding: EdgeInsets.only(left: 24, top: 4, right: 24),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ));
  }

  Widget _buildTagWidget(String text, IconData ic) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(
              ic,
              color: Colors.white,
              size: 24.0,
            ),
          ),
          Text(
            text, //todo null safety
            style: TextStyle(
                color: Colors.white, fontFamily: 'Poppins', fontSize: 18),
          ),
        ],
      ),
    );
  }
}
