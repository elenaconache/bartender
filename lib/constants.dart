import 'package:bartender/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final blueGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [gradientStartColorDark, gradientEndColorDark],
);
final lightBlueGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [gradientStartColor, gradientEndColor],
);
const whiteExtraSmallTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.white,
  fontFamily: 'Poppins',
); //body2
