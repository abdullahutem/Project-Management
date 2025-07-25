import 'package:cmp/presentation/resources/font_manager.dart';
import 'package:flutter/material.dart';

TextStyle _textStyle(double fontSize, FontWeight fontWeight, Color color) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: FontConstants.fontFamily,
    color: color,
    fontWeight: fontWeight,
  );
}

// regular Style
TextStyle getRegelurTextStyle({
  double fontSize = FontSize.s14,
  required Color color,
}) {
  return _textStyle(fontSize, FontWeightManager.medium, color);
}

// medium Style
TextStyle getMediumTextStyle({
  double fontSize = FontSize.s12,
  required Color color,
}) {
  return _textStyle(fontSize, FontWeightManager.medium, color);
}

// light Style
TextStyle getLightTextStyle({
  double fontSize = FontSize.s12,
  required Color color,
}) {
  return _textStyle(fontSize, FontWeightManager.lighter, color);
}

// bold Style
TextStyle getBoldTextStyle({
  double fontSize = FontSize.s12,
  required Color color,
}) {
  return _textStyle(fontSize, FontWeightManager.bold, color);
}

// semiBold Style
TextStyle getSemiBoldTextStyle({
  double fontSize = FontSize.s12,
  required Color color,
}) {
  return _textStyle(fontSize, FontWeightManager.semiBold, color);
}

// lable larg Style
TextStyle getLableLargeTextStyle({
  double fontSize = FontSize.s12,
  required Color color,
}) {
  return _textStyle(fontSize, FontWeightManager.semiBold, color);
}

// lable larg Style
TextStyle getLableMediaTextStyle({
  double fontSize = FontSize.s12,
  required Color color,
}) {
  return _textStyle(fontSize, FontWeightManager.semiBold, color);
}

// lable larg Style
TextStyle getLableSmallTextStyle({
  double fontSize = FontSize.s8,
  required Color color,
}) {
  return _textStyle(fontSize, FontWeightManager.semiBold, color);
}

// New price Style
TextStyle getNewPriceTextStyle({
  double fontSize = FontSize.s14,
  required Color color,
}) {
  return _textStyle(fontSize, FontWeightManager.semiBold, color);
}
