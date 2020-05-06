import 'package:flutter/material.dart';

//primary swatch -- if using swatch
Color kPrimarySwatch = Colors.green;
Brightness kBrightness = Brightness.light;

setThemeColors(String color) {
  if (color == null || color == 'green') {
    kPrimarySwatch = Colors.green;
    kBrightness = Brightness.light;
  } else if (color.contains('red')) {
    kBrightness = Brightness.light;
    kPrimarySwatch = Colors.red;
  } else if (color.contains('purple')) {
    kBrightness = Brightness.light;
    kPrimarySwatch = Colors.purple;
  } else if (color.contains('gold')) {
    kPrimarySwatch = Colors.amber;
    kBrightness = Brightness.light;
  } else if (color.contains('white')) {
    kPrimarySwatch = Colors.grey;
    kBrightness = Brightness.light;
  }else if (color.contains('black') || color.contains('none')) {
    kPrimarySwatch = Colors.grey;
    kBrightness = Brightness.light;
  }
}

ThemeData baseThemeSwatch(
  ThemeData theme, [
  String color = 'green',
]) {
  setThemeColors(color);

  return ThemeData(
      primarySwatch: kPrimarySwatch,
      brightness: kBrightness,
      textTheme: TextTheme(
//      display4: ,
//            Extremely large text. [...]

//      display3: ,
//            Very, very large text. [...]

//      display2: ,
//        Very large text.

//      display1: ,
//        Large text.

        headline6: TextStyle(
//          color: Colors.black,
          fontFamily: 'Signika',
          fontSize: 22.0,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.0,
        ),
//        Used for the primary text in app bars and dialogs (e.g., AppBar.title and AlertDialog.title).

        headline5: TextStyle(
//          color: Colors.black,
          fontFamily: 'WorkSans',
          fontWeight: FontWeight.w600,
          fontSize: 20.0,
        ),
//        Used for large text in dialogs (e.g., the month and year in the dialog shown by showDatePicker).

        subtitle1: TextStyle(
//          color: Colors.black,
          fontFamily: 'WorkSans',
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
        ),
//          Used for the primary text in lists (e.g., ListTile.title).

        bodyText2: TextStyle(
//          color: Colors.black,
          fontFamily: 'WorkSans',
          fontSize: 14.0,
        ),
//        Used for the default text style for Material.

        bodyText1: TextStyle(
//          color: Colors.black,
          fontFamily: 'WorkSans',
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
//        Used for emphasizing text that would otherwise be body1.

        button: TextStyle(color: Colors.black, fontFamily: 'Merriweather'),
//        Used for text on RaisedButton and FlatButton.

        caption: TextStyle(
//          color: Colors.black,
          fontFamily: 'WorkSans',
          fontSize: 12.0,
          fontWeight: FontWeight.w300,
        ),
      ),

  );
}

TextStyle referenceAndSubtitleStyle = TextStyle(
  fontWeight: FontWeight.w600,
    color: Colors.black38,
);



