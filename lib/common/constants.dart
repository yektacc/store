import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persian_datepicker/persian_datetime.dart';
import 'package:store/store/login_register/login/login_page.dart';
import 'package:url_launcher/url_launcher.dart';

class AppColors {
  static final colors = [
    main_color,
    main_color,
    main_color,
    main_color,
  ];


  static const int _r1 = 227;
  static const int _g1 = 30;
  static const int _b1 = 36;

  static const int _r2 = 45;
  static const int _g2 = 58;
  static const int _b2 = 128;

  static const Map<int, Color> _main_color_mat = {
    50: Color.fromRGBO(_r1, _g1, _b1, .1),
    100: Color.fromRGBO(_r1, _g1, _b1, .2),
    200: Color.fromRGBO(_r1, _g1, _b1, .3),
    300: Color.fromRGBO(_r1, _g1, _b1, .4),
    400: Color.fromRGBO(_r1, _g1, _b1, .5),
    500: Color.fromRGBO(_r1, _g1, _b1, .6),
    600: Color.fromRGBO(_r1, _g1, _b1, .7),
    700: Color.fromRGBO(_r1, _g1, _b1, .8),
    800: Color.fromRGBO(_r1, _g1, _b1, .9),
    900: Color.fromRGBO(_r1, _g1, _b1, 1),
  };

  static const Map<int, Color> _second_color_mat = {
    50: Color.fromRGBO(_r2, _g2, _b2, .1),
    100: Color.fromRGBO(_r2, _g2, _b2, .2),
    200: Color.fromRGBO(_r2, _g2, _b2, .3),
    300: Color.fromRGBO(_r2, _g2, _b2, .4),
    400: Color.fromRGBO(_r2, _g2, _b2, .5),
    500: Color.fromRGBO(_r2, _g2, _b2, .6),
    600: Color.fromRGBO(_r2, _g2, _b2, .7),
    700: Color.fromRGBO(_r2, _g2, _b2, .8),
    800: Color.fromRGBO(_r2, _g2, _b2, .9),
    900: Color.fromRGBO(_r2, _g2, _b2, 1),
  };

  static const MaterialColor main_color_mat =
  MaterialColor(0xffe31e24, _main_color_mat);

  static const main_color = _red;

  static const second_color = _blue;

  static const text_main = Color.fromARGB(255, 30, 30, 30);
  static const text_second = _blue;

  static const _red = Color.fromARGB(255, _r1, _g1, _b1);
  static const _blue = Color.fromARGB(255, _r2, _g2, _b2);

  static const grey = Colors.grey;

  static const loading_indicator_color = Color.fromARGB(90, _r1, _g1, _b1);
  static const light_loading_indicator_color = Color.fromARGB(
      200, 255, 255, 255);
}

class AppIcons {
  static final pets = [
    SvgPicture.asset('assets/dog.svg',
        color: AppColors.colors[0], semanticsLabel: 'A red up arrow'),
    SvgPicture.asset('assets/cat.svg',
        color: AppColors.colors[1], semanticsLabel: 'A red up arrow'),
    SvgPicture.asset('assets/parrot.svg',
        color: AppColors.colors[2], semanticsLabel: 'A red up arrow'),
    SvgPicture.asset('assets/horse.svg',
        color: AppColors.colors[3], semanticsLabel: 'A red up arrow')
  ];

  static Widget showOnMap(Color color, {double size = 24}) =>
      SvgPicture.asset(
        'assets/show-on-map.svg',
        color: color,
        semanticsLabel: 'show on map',
        width: size,
        height: size,
      );

  static Widget googleMap(Color color, {double size = 24}) =>
      SvgPicture.asset(
        'assets/google-maps.svg',
        color: color,
        semanticsLabel: 'show on map',
        width: size,
        height: size,
      );

  static final mapPin = SvgPicture.asset(
    'assets/map-pin.svg',
    color: AppColors.main_color,
    semanticsLabel: 'A red up arrow',
    width: 140,
    height: 140,
  );
}

class AppUrls {
  static const String base_url = 'http://79.143.85.121';
  static const String image_url = '$base_url/epet24/public/';
  static const String api_url = "$base_url/epet24/public/api/";
  static const String alt_api_url = "$base_url/epet24-upload/public/api/";
}

class AppDimensions {
  static double _hPadding = 14;
  static double _vPadding = 11;

  static EdgeInsets defaultFormPadding = EdgeInsets.symmetric(
      vertical: _vPadding, horizontal: _hPadding);
}

class Helpers {
  static showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: AppColors.main_color,
        textColor: Colors.white,
        fontSize: 13.0);
  }

  static changeSuccessfulToast([String message = 'تغییرات با موفقیت ثبت شد!']) {
    showToast(message);
  }

  static launchLogin(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  static errorToast() {
    Fluttertoast.showToast(
        msg: 'خطا! لطفا مجددا تلاش کنید',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: AppColors.main_color,
        textColor: Colors.white,
        fontSize: 13.0);
  }

  static openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static Widget image(String url,
      {Widget placeHolder, double height, double width}) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: url,
      placeholder: (context, _) => placeHolder,
    );
  }

  static String getPersianDate(String gregorianDateTime) {
    print('gregorian time to conver: $gregorianDateTime');
    var dateTime = gregorianDateTime.split(' ');

    if (dateTime.length == 2) {
      return PersianDateTime.fromGregorian(gregorianDateTime: dateTime[0])
          .toString();
    } else {
      return PersianDateTime.fromGregorian(gregorianDateTime: gregorianDateTime)
          .toString();
    }
  }

  static String getIranTime(String gregorianDateTime) {
    return gregorianDateTime.split(' ')[1].substring(0, 5);
  }
}
