import 'package:bartender/ui/backdrop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final blueGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [gradientStartColor, gradientEndColor],
);
const whiteSmallTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
  fontFamily: 'Poppins',
);
const whiteExtraSmallTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.white,
  fontFamily: 'Poppins',
);
