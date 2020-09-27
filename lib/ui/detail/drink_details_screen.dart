import 'package:bartender/blocs/detail/drink_cubit.dart';
import 'package:bartender/blocs/detail/drink_state.dart';
import 'package:bartender/data/models/drink.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.55,
              child: Stack(fit: StackFit.expand, children: [
                _buildImageWidget(),
                _buildNameOverlayWidget(),
              ])),
          _buildTagsWidgets(drink),
          _buildLabelWidget('Instructions'),
          _buildTextWidget(drink.instructions),
        ]));
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

  Widget _buildImageWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(48),
      ),
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
    );
  }

  Widget _buildNameOverlayWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Wrap(
        children: [
          Container(
              width: double.infinity,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.transparent),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(48.0)),
                  color: Color(
                      0x80000000) // Specifies the background color and the opacity
                  ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Text(
                    widget.drink.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildTagsWidgets(Drink drink) {
    return Container(
        margin: EdgeInsets.only(top: 24, left: 32, right: 32),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.pan_tool,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
              Text(
                drink.alcoholic, //todo null safety
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Poppins', fontSize: 18),
              ),
            ],
          ),
          Padding(
              padding: EdgeInsets.only(top: 12),
              child: Row(children: [
                Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.local_drink,
                      color: Colors.white,
                    )),
                Text(
                  drink.glass,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Poppins', fontSize: 18),
                ),
              ])),
          Padding(
              padding: EdgeInsets.only(top: 12),
              child: Row(children: [
                Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.category,
                      color: Colors.white,
                    )),
                Text(
                  drink.category,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Poppins', fontSize: 18),
                ),
              ]))
        ]));
  }

  Widget _buildLabelWidget(String s) {
    return Padding(
      padding: EdgeInsets.only(left: 24, top: 24, right: 24),
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
}
