import 'package:flutter/material.dart';


const kPrimaryColor = const Color(0xFFfafafa);
const kPrimaryLight = const Color(0xFFffffff);
const kPrimaryDark = const Color(0xFF8d8d8d);

//default secondary colors -currently green
Color kSecondaryColor = Color(0xFF2f5d07);
Color kSecondaryLight = Color(0xFF7cae50);
Color kSecondaryDark =  Color(0xFF244c00);

setThemeColors(String color){
  if(color == 'green'){
    kSecondaryColor = Color(0xFF2f5d07);
    kSecondaryLight = Color(0xFF7cae50);
    kSecondaryDark =  Color(0xFF244c00);
  } else if (color == 'red'){
    kSecondaryColor = Color(0xFF851b21);
    kSecondaryLight = Color(0xFFf08b90);
    kSecondaryDark = Color(0xFF4b0004);
  } else if (color == 'purple'){
    kSecondaryColor = Color(0xFF6b1648);
    kSecondaryLight = Color(0xFF9b4778);
    kSecondaryDark = Color(0xFF3d0024);
  }
}


final baseTheme = ThemeData(
//    primarySwatch: Colors.green,

    primaryColor: kPrimaryColor,
    primaryColorDark: kPrimaryDark,
    primaryColorLight: kPrimaryLight,

    accentColor: kSecondaryColor,
    buttonColor: kSecondaryColor,
    iconTheme: IconThemeData(
      color: kSecondaryColor,

    ),
    primaryIconTheme: IconThemeData(
      color: kSecondaryColor,

    ),
    accentIconTheme: IconThemeData(
      color: kSecondaryColor,

    ),
    indicatorColor: kSecondaryColor,
    splashColor: kSecondaryColor,
//    indicatorColor: kSecondaryColor,
    sliderTheme: SliderThemeData.fromPrimaryColors(
      primaryColor: kPrimaryColor,
      primaryColorDark: kPrimaryDark,
      primaryColorLight: kPrimaryLight,
      valueIndicatorTextStyle: TextStyle(),
    ),

    textTheme: TextTheme(
//      display4: ,
//            Extremely large text. [...]

//      display3: ,
//            Very, very large text. [...]

//      display2: ,
//        Very large text.

//      display1: ,
//        Large text.

      title: TextStyle(
        color: Colors.black,
        fontFamily: 'WorkSans',
        fontSize: 20.0,
        fontWeight: FontWeight.w200,
        letterSpacing: -0.5,
      ),
//        Used for the primary text in app bars and dialogs (e.g., AppBar.title and AlertDialog.title).


      headline: TextStyle(
       color: Colors.black,
       fontFamily: 'WorkSans',
       fontWeight: FontWeight.w600,
       fontSize: 20.0,
      ),
//        Used for large text in dialogs (e.g., the month and year in the dialog shown by showDatePicker).

      subhead: TextStyle(
        color: Colors.black,
        fontFamily: 'WorkSans',
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
      ),
//          Used for the primary text in lists (e.g., ListTile.title).

      body1: TextStyle(
        color: Colors.black,
        fontFamily: 'WorkSans',
        fontSize: 14.0,
      ),
//        Used for the default text style for Material.


      body2: TextStyle(
        color: Colors.black,
        fontFamily: 'WorkSans',
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
//        Used for emphasizing text that would otherwise be body1.


      button: TextStyle(
        color: Colors.black,
        fontFamily: 'Merriweather'
      ),
//        Used for text on RaisedButton and FlatButton.


      caption: TextStyle(
          color: Colors.black,
          fontFamily: 'WorkSans',
          fontSize: 12.0,
          fontWeight: FontWeight.w300,

      ),
//        Used for auxiliary text associated with images.

    ),



//ALL POSSIBLE THEM VALUES
//    brightness: ,
//    primarySwatch: ,
//      primaryColor: ,
//      primaryColorBrightness: ,
//      primaryColorLight: ,
//      primaryColorDark,
//      accentColor: ,
//      accentColorBrightness:,
//      canvasColor:,
//      scaffoldBackgroundColor:,
//      bottomAppBarColor: ,
//      cardColor: ,
//      dividerColor: ,
//      highlightColor: ,
//      splashColor: ,
//      splashFactory: ,
//      selectedRowColor: ,
//      unselectedWidgetColor: ,
//      disabledColor: ,
//      buttonColor: ,
//      buttonTheme: ,
//      secondaryHeaderColor: ,
//      textSelectionColor: ,
//      cursorColor: ,
//      textSelectionHandleColor: ,
//      backgroundColor: ,
//      dialogBackgroundColor: ,
//      indicatorColor: ,
//      hintColor: ,
//      errorColor: ,
//      toggleableActiveColor: ,
//      fontFamily: ,
//      textTheme: ,
//      primaryTextTheme,
//      accentTextTheme,
//      inputDecorationTheme,
//      iconTheme,
//      primaryIconTheme,
//      accentIconTheme,
//      sliderTheme,
//      tabBarTheme,
//      chipTheme,
//      platform,
//      materialTapTargetSize,
//      pageTransitionsTheme

);
