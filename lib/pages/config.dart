import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

SharedPreferences ? prefs;
const Color primaryColor = Color(0xffFF0000);
const String token = "wjeiwenwejwkejwke98w9e8wewnew8wehwenj232jh32j3h2j3h2j";

const String pathApi = "http://192.168.0.105:82/flutterrestaurant/api/";
const String pathImages = "http://192.168.0.105:82/flutterrestaurant/images/";

String gCusIdVal = "";

const String gCusId = "cus_id";
const String gCusname = "cus_name";
const String gCusmobile = "cus_mobile";
const String gCusimage = "cus_image";

Future<bool> checkConnection() async {
  try {
    return true;
  } on SocketException catch (_) {
    print("not connect");
    return false;
  }
}
