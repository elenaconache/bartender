import 'package:bartender/blocs/stats/stats_cubit.dart';
import 'package:bartender/blocs/stats/stats_state.dart';
import 'package:bartender/constants.dart';
import 'package:bartender/i18n/bartender_localizations.dart';
import 'package:bartender/ui/stats/chart_legend_item.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

final List<Color> chartColors = [
  Colors.amber,
  Colors.pink,
  Colors.deepOrange,
  Colors.deepPurple,
  Colors.green,
  Colors.teal,
  Colors.cyan,
  Colors.blue,
  Colors.brown,
  Colors.purple,
  Colors.purpleAccent
];

class StatsScreen extends StatefulWidget {
  StatsScreen();

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int selectedIndex;
  Map<String, double> ingredientPercentage;

  @override
  Widget build(BuildContext context) {
    return CubitConsumer<StatsCubit, StatsState>(
      builder: (context, state) {
        return _buildWidget(state);
      },
      listener: (context, state) {
        return _buildWidget(state);
      },
    );
  }

  List<PieChartSectionData> showingSections(
      Map<String, double> ingredientPercent) {
    return List.generate(ingredientPercent.entries.length, (i) {
      final isTouched = i == selectedIndex;
      final double fontSize = isTouched ? 20 : 12;
      final double radius = isTouched ? 130 : 110;
      return PieChartSectionData(
        color: chartColors[i],
        value: ingredientPercent.entries.elementAt(i).value,
        title: ingredientPercent.entries.elementAt(i).value > 10.0
            ? '${ingredientPercent.entries.elementAt(i).value.toStringAsFixed(1)}%'
            : '',
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, color: Colors.white),
      );
    });
  }

  Widget _buildWidget(StatsState state) {
    if (state is StatsSuccess) {
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        return Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          _buildChartTitle(),
          _buildPieChart(state.ingredientPercent),
          _buildLegend(state.ingredientPercent)
        ]);
      } else {
        return Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          _buildChartTitle(),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildPieChart(state.ingredientPercent),
              ),
              Expanded(flex: 1, child: _buildLegend(state.ingredientPercent))
            ],
          )
        ]);
      }
    } else if (state is StatsLoading || state is StatsInitial) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Container(); //todo throw errors on else if all states are handled
    }
  }

  Widget _buildChartTitle() {
    return Align(
        alignment: Alignment.topCenter,
        child: Text(
          BartenderLocalizations.of(context).titleIngredientsChart,
          style: whiteMediumTextStyle,
        ));
  }

  Widget _buildPieChart(Map<String, double> ingredientPercent) {
    return Center(
        child: PieChart(
      PieChartData(
          pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
            setState(() {
              if (pieTouchResponse.touchInput is FlLongPressEnd ||
                  pieTouchResponse.touchInput is FlPanEnd) {
                selectedIndex = -1;
              } else {
                selectedIndex = pieTouchResponse.touchedSectionIndex;
              }
            });
          }),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 5,
          centerSpaceRadius: 0,
          sections: showingSections(ingredientPercent)),
      swapAnimationDuration: Duration(milliseconds: 300),
    ));
  }

  Widget _buildLegend(Map<String, double> ingredientPercent) {
    return Align(
        alignment: Alignment.bottomRight,
        child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 3,
            child: Padding(
              padding: EdgeInsets.only(right: 24, top: 36),
              child: ListView.builder(
                  itemCount: ingredientPercent.entries.length,
                  itemBuilder: (context, index) {
                    var key = ingredientPercent.entries.elementAt(index).key;
                    if (key == other) {
                      key = BartenderLocalizations.of(context).labelOther;
                    } else if (key == unknown) {
                      key = BartenderLocalizations.of(context).labelUnknown;
                    }
                    return LegendItem(
                      color: chartColors[index],
                      text: key,
                      isSquare: true,
                    );
                  }),
            )));
  }
}
