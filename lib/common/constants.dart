import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class AppColors {
  static final colors = [
    second_color,
    second_color,
    second_color,
    second_color,
  ];

  static const main_color = Color.fromARGB(255, 45, 58, 128);
  static const second_color = Color.fromARGB(255, 227, 30, 36);
  static const grey = Colors.grey;
  static const loading_indicator_color = Color.fromARGB(90, 45, 58, 128);
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

  static showDefaultErr() {
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
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static Widget image(String url, {Widget placeHolder, double height, double width}) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: url,
      placeholder: (context, _) => placeHolder,
    );
  }
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

  static Widget showOnMap(Color color, {double size = 24}) => SvgPicture.asset(
    'assets/show-on-map.svg',
    color: color,
    semanticsLabel: 'show on map',
    width: size,
    height: size,
  );

  static Widget googleMap(Color color, {double size = 24}) => SvgPicture.asset(
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
}
