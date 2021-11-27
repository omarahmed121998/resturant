import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

import 'config.dart';

Future<bool> saveData(Map arrInsert, String urlPage, BuildContext context,
    Widget Function() movePage, String type) async {
  String url = pathApi + "$urlPage?token=" + token;

  http.Response respone = await http.post(Uri.parse(url), body: arrInsert);
  if (json.decode(respone.body)["code"] == "200") {
    if (type == "insert") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => movePage()));
    } else {
      Navigator.pop(context);
    }
    print("success");
    return true;
  } else {
    print("Failer");
    return false;
  }
}

Future<bool> uploadFileWithData(
    dynamic imageFile,
    Map arrInsert,
    String urlPage,
    BuildContext context,
    Widget Function() movePage,
    String type) async {
  if (imageFile == null) {
    await saveData(arrInsert, urlPage, context, movePage, type);
    return false;
  }
  // ignore: deprecated_member_use
  var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));

  var length = await imageFile.length();
  String url = pathApi + "$urlPage?token=" + token;
  var uri = Uri.parse(url);
  print(uri.path);
  var request =  http.MultipartRequest("POST", uri);
  var multipartFile =  http.MultipartFile("file", stream, length,
      filename: basename(imageFile.path));
  for (var entry in arrInsert.entries) {
    request.fields[entry.key] = entry.value;
  }

  request.files.add(multipartFile);
  var response = await request.send();

  if (response.statusCode == 200) {
    print("Send succefull");
    if (type == "update") {
      Navigator.pop(context);
    } else if (type == "insert") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => movePage()));
    }
    return true;
  } else {
    return false;
  }
}

Future<List?> getData(
    int count, String urlPage, String strSearch, String param) async {
  String url = pathApi +
      "$urlPage?${param}txtsearch=$strSearch&start=$count&end=10&token=" +
      token;
  print(url);
  http.Response respone = await http.post(Uri.parse(url));

  if (json.decode(respone.body)["code"] == "200") {
    {
      List arr = (json.decode(respone.body)["message"]);
      print(arr);
      return arr;
    }
  }
}

Future<bool> deleteData(String colid, String valid, String urlPage) async {
  String url = pathApi + "$urlPage?$colid=$valid&token=" + token;
  print(url);
  http.Response respone = await http.post(Uri.parse(url));

  if (json.decode(respone.body)["code"] == "200") {
    return true;
  } else {
    return false;
  }
}





// import "package:e_commers_app/pages/config.dart";
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart';
// import 'package:async/async.dart';

// Future<bool> saveData(Map arrInsert, String urlPage,
//  BuildContext context,
//     Widget Function() movePage, String type) async {
//   String url = pathApi + "$urlPage?token=" + token;

//   http.Response respone = await http.post(Uri.parse(url), body: arrInsert);
//   if (json.decode(respone.body)["code"] == "200") {
//     if (type == "insert") {
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => movePage()));
//     } else {
//       Navigator.pop(context);
//     }
//     print("success");
//     return true;
//   } else {
//     print("Failer");
//     return false;
//   }
// }

// Future<Map?> saveDataList(
//     Map arrInsert, String urlPage, BuildContext context, String type) async {
//   String url = pathApi + "$urlPage?token=" + token;

//   http.Response respone = await http.post(Uri.parse(url), body: arrInsert);
//   print(respone.body);
//   if (json.decode(respone.body)["code"] == "200") {
//     Map arr = json.decode(respone.body)["message"];

//     print("success");
//     return arr;
//   } else {
//     print("Failer");
//     return null;
//   }
// }

// Future<bool> uploadFileWithData(
//     dynamic imageFile,
//     Map arrInsert,
//     String urlPage,
//     BuildContext context,
//     Widget Function() movePage,
//     String type) async {
//   if (imageFile == null) {
//     await saveData(arrInsert, urlPage, context, movePage, type);
//     return false;
//   }

//   // ignore: deprecated_member_use
//   var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));

//   var length = await imageFile.length();
//   String url = pathApi + "$urlPage?token=" + token;
//   var uri = Uri.parse(url);
//   print(uri.path);
//   var request =  http.MultipartRequest("POST", uri);
//   var multipartFile =  http.MultipartFile("file", stream, length,
//       filename: basename(imageFile.path));
//   for (var entry in arrInsert.entries) {
//     request.fields[entry.key] = entry.value;
//   }

//   request.files.add(multipartFile);
//   var response = await request.send();

//   if (response.statusCode == 200) {
//     print("Send succefull");
//     if (type == "update") {
//       Navigator.pop(context);
//     } else if (type == "insert") {
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => movePage()));
//     }
//     return true;
//   } else {
//     return false;
//   }
// }

// Future<List?> getData(
//     int start, int end, String urlPage, String strSearch, String param) async {
//   String url = pathApi +
//       "$urlPage?${param}txtsearch=$strSearch&start=$start&end=$end&token=" +
//       token;
//   http.Response respone = await http.post(Uri.parse(url));

//   if (json.decode(respone.body)["code"] == "200") {
//     {
//       List arr = (json.decode(respone.body)["message"]);
//       print(arr);
//       return arr;
//     }
//   } else {
//     return null;
//   }
// }

// Future<bool> deleteData(String colId, String valId, String urlPage) async {
//   String url = pathApi + "$urlPage?$colId=$valId&token=" + token;
//   print(url);
//   http.Response respone = await http.post(Uri.parse(url));

//   if (json.decode(respone.body)["code"] == "200") {
//     return true;
//   } else {
//     return false;
//   }
// }