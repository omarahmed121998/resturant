import 'dart:convert';
import 'package:e_commers_app/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../config.dart';

Future<bool> loginUsers(
    String useMobile, String usePwd, BuildContext context) async {
  String url = pathApi +
      "users/login.php?use_mobile=" +
      useMobile +
      "&use_pwd=" +
      usePwd +
      "&token=" +
      token;

  http.Response respone = await http.get(Uri.parse(url));
  if (json.decode(respone.body)["code"] == "200") {
    Map arr = json.decode(respone.body)["message"];
    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.setString(gCusId, arr["use_id"]);
    sh.setString(gCusname, arr["use_name"]);
    sh.setString(gCusimage, arr["use_image"]);
    sh.setString(gCusmobile, arr["use_mobile"]);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Home()));

    print("success");
    return true;
  } else {
    print("Failer");
    return false;
  }
}