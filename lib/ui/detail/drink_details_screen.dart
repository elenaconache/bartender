import 'package:bartender/blocs/detail/drink_cubit.dart';
import 'package:bartender/blocs/detail/drink_state.dart';
import 'package:bartender/data/models/drink.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

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
    //todo call api with id in initState()
  }

  Widget _buildSuccessWidget(Orientation orientation, Drink drink) {
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
      Text(
        "Instructions: " + drink.instructions,
        style: TextStyle(fontSize: 16),
      ),
    ]);
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
        style: TextStyle(fontSize: 20),
      ),
      Text("No more data available"),
    ]);
    // }else{//todo different widget
  }

  Future<void> _getDrinkDetail() async {
    final drinkCubit = context.cubit<DrinkCubit>();
    drinkCubit.getDrinkData(widget.drink.id);
  }
}
