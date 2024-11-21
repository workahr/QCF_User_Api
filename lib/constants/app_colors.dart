import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/base_controller.dart';

class AppColors {
  bool darkTheme = false;

  BaseController baseCtrl = Get.put(BaseController());
  // _MyAppState() {
  //   print('baseCtrl ${baseCtrl.isDarkModeEnabled.value}');
  //   baseCtrl.isDarkModeEnabled.listen((value) {
  //     refresh();
  //   });
  // }
  AppColors() {
    // print('darkTheme $darkTheme');
    baseCtrl.isDarkModeEnabled.listen((value) {
      changeColors();
    });
  }

  changeColors() {
    if (darkTheme == true) {
      dark = Colors.white;
    } else {
      dark = Colors.black;
    }
  }

  static const Color primary = Color(0xFF10B0C3);
  static const Color primaryLight = Color(0xFF10B0C3);
  static const Color primaryDark = Color(0xFF365F76);
  static const Color primaryDark2 = Color(0xFF2e3e53);
  static const Color primary2 = Color(0xFF004586); // quotation
  static const Color primaryLight2 = Color(0xFF4292F3); // bills

  static const Color secondary = Color(0xFFFFA726);
  static const Color secondaryLight = Color(0xFFFFF263);
  static const Color secondaryDark = Color(0xFFFF6F00);

  static const Color warning = Color(0xFFDC4F0D);
  static const Color warning2 = Color(0xFFFF6C00); // for bills
  static const Color warning3 = Color(0xFFF36F56); // for bills
  static const Color warningLight2 = Color(0xFFFFE6D4); // for bills

  static const Color warningDark = Color(0xFFE9D25B);
  static const Color warningDark1 = Color(0xFFAB9005);
  static const Color offerwarning = Color(0xFFa31e00);

  static const Color danger = Color(0xFFFF5252);
  static const Color dangerLight = Color(0xFFFFCDD2);
  static const Color success = Color(0xFF4CAF50);
  static const Color success2 = Color(0xFF0CC172); // for quotation
  static const Color successLight2 = Color(0xFF77B944); // for quotation
  static const Color successLight3 = Color(0xFF4ED86F); // for quotation
  static const Color successLight4 = Color(0xFFEBFBEF); // for quotation
  static const Color successLight = Color(0xFF3ec457);

  static const Color successDark = Color(0xFF007645);
  static const Color info = Color(0xFF2196F3);
  static const Color background = Color(0xFFEFEFEF);
  static const Color light = Colors.white;

  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFB2B2B2);
  static const Color lightGrey2 = Color(0xFFEEEEEE);
  static const Color lightGrey3 = Color(0xFFE8E8E8);
  static const Color lightGrey4 = Color(0xFFf8f8f8);
  static const Color lightGrey5 = Color(0xFFa7a8a8);
  static const Color lightGrey6 = Color(0xFF929292); // for quotation page
  static const Color lightGrey7 = Color(0xFF747474); // for quotation page
  static const Color lightGrey8 = Color(0xFF545454); // for quotation page
  static const Color lightGrey9 = Color(0xFFCEDFEF); // for quotation page
  static const Color lightGrey10 = Color(0xFFDEEEFC); // for quotation page
  static const Color lightGrey11 = Color(0xFFEAEAEA);
  static const Color lightGrey12 = Color(0xFF9D9D9D);
  static const Color lightGrey13 = Color(0xFFF0F0F0);
  static const Color lightGrey14 = Color(0xFF5E5E5E);
  static const Color lightGrey15 = Color(0xFF515050);
  static const Color lightRed = Color(0xFFFEE0E0);
  static const Color lightGreen = Color(0xFFE1FFE3);

  static const Color darkGreen = Color(0xFF196B23);
  static const Color darkBlue = Color(0xFF0E58D4);

  static const Color lightBlue = Color(0xFFCBDFF7);
  static const Color lightYellow = Color(0xFFF5F5DC);

  static const Color lightGreen1 = Color(0xFF5DCE6A);

  static const Color grey1 = Color(0xFFF1F0F5);
  static const Color darkGrey = Color(0xFF696A6A);

  static const Color gold = Color(0xFFFCB019);
  static const Color black = Color(0xFF2A2A2A);
  static const Color shadowBlack = Color(0xFF6E6E6E);

  static const Color red = Color(0xFFE23744);
  static const Color lightred = Color(0xFFFBEDEE);
  static const Color blue = Color(0xFF2F64FE);
  static const Color bluetone = Color(0xFF91A0B8);
  static const Color n_black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  Color loadingGrey = Colors.grey[300]!;
  Color loadingGrey2 = Colors.grey[100]!;

  static Color dark = Colors.black;
  static const Color pink = Colors.pink;

  static ColorScheme myColorScheme = ColorScheme(
    primary: primary,
    // primary: const Color(0x0005233b),
    secondary: primaryLight,
    surface: light,
    background: light,
    // background: Colors.grey.shade200,
    // outline: Colors.grey.shade400,
    error: Colors.red,
    onPrimary: const Color(0x0005233b),
    onSecondary: light,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: light,
    brightness: Brightness.light,

    // surfaceTint: Color(0xff6A707C) // grey,
    // surfaceTint: colorCodeToVal('B2B2B2') // grey,
  );
}

// import 'package:flutter/material.dart';

// class AppColors {
//   static final ColorScheme lightColorScheme = const ColorScheme.light(
//     primary: Color(0xFF336699),
//     primaryVariant: Color(0xFF0D47A1),
//     secondary: Color(0xFFFFA726),
//     secondaryVariant: Color(0xFFFF6F00),
//     surface: Colors.white,
//     background: Color(0xFFEFEFEF),
//     error: Color(0xFFFF5252),
//     onPrimary: Colors.white,
//     onSecondary: Colors.black,
//     onSurface: Colors.black,
//     onBackground: Colors.black,
//     onError: Colors.white,
//     brightness: Brightness.light,
//   );

//   static final ColorScheme darkColorScheme = ColorScheme.dark(
//     primary: Color(0xFF336699),
//     primaryVariant: Color(0xFF0D47A1),
//     secondary: Color(0xFFFFA726),
//     secondaryVariant: Color(0xFFFF6F00),
//     surface: Color(0xFF1E1E1E),
//     background: Color(0xFF121212),
//     error: Color(0xFFFF5252),
//     onPrimary: Colors.white,
//     onSecondary: Colors.black,
//     onSurface: Colors.white,
//     onBackground: Colors.white,
//     onError: Colors.white,
//     brightness: Brightness.dark,
//   );

//   static final ThemeData lightTheme = ThemeData.from(
//     colorScheme: lightColorScheme,
//     textTheme: TextTheme(
//       headline6: TextStyle(color: Colors.black),
//       bodyText2: TextStyle(color: Colors.black),
//     ),
//     // define other theme properties
//   );

//   static final ThemeData darkTheme = ThemeData.from(
//     colorScheme: darkColorScheme,
//     textTheme: TextTheme(
//       headline6: TextStyle(color: Colors.white),
//       bodyText2: TextStyle(color: Colors.white),
//     ),
//     // define other theme properties
//   );
// }
