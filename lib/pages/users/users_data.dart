import 'dart:async';
import 'dart:convert';

import 'package:e_commers_app/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../function.dart';
import 'edit.dart';

List<UsersData>? userList;

class UsersData {
  String useid;
  String usename;
  String usepwd;
  String usemobile;
  bool useactive;
  String uselastdate;
  String usenote;
  UsersData(
      {required this.useid,
      required this.usename,
      required this.usepwd,
      required this.uselastdate,
      required this.usemobile,
      required this.useactive,
      required this.usenote});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UsersData &&
      other.useid == useid &&
      other.usename == usename &&
      other.usepwd == usepwd &&
      other.usemobile == usemobile &&
      other.useactive == useactive &&
      other.uselastdate == uselastdate &&
      other.usenote == usenote;
  }

  @override
  int get hashCode {
    return useid.hashCode ^
      usename.hashCode ^
      usepwd.hashCode ^
      usemobile.hashCode ^
      useactive.hashCode ^
      uselastdate.hashCode ^
      usenote.hashCode;
  }
}

class SingleUser extends StatelessWidget {
  int useindex;
  UsersData users;
  SingleUser({Key? key, required this.useindex, required this.users})
   : super(key: key);
  @override
  Widget build(BuildContext context) {
    var providerUser = Provider.of<LoadingControl>(context);
    return Card(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              userList!.removeAt(useindex);
              deleteData("use_id", users.useid, "users/delete_user.php");
              providerUser.addLoading();
            },
            child: Container(
              alignment: Alignment.topRight,
              child: const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            ),
          ),
          ListTile(
            title: Text(
              users.usename,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(users.usemobile), Text(users.uselastdate)]),
            trailing: SizedBox(
              width: 30.0,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  EditUsers(
                                    useindex: useindex,
                                    users: users,
                                  )));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: const FaIcon(
                        FontAwesomeIcons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}