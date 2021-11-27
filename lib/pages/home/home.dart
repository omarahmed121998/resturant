import 'package:e_commers_app/pages/category/category.dart';
import 'package:e_commers_app/pages/delivery/delivery.dart';
import 'package:e_commers_app/pages/drawer/mydrawer.dart';
import 'package:e_commers_app/pages/users/users.dart';

import 'package:flutter/material.dart';

import '../config.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text("ادارة المطعم"),
          centerTitle: true,
        ),
        backgroundColor: Colors.grey[100],
        endDrawer: const MyDrawer(),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                   Expanded(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Users()));
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Column(
                              children: const <Widget>[
                                 Icon(
                                  Icons.home,
                                  size: 80.0,
                                  color: Colors.green,
                                ),
                                 Text(
                                  "المستخدمين",
                                  style: TextStyle(fontSize: 18.0),
                                )
                              ],
                            ),
                          ))),
                   Expanded(
                      child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const Category()));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Column(
                        children: const <Widget>[
                           Icon(
                            Icons.category,
                            size: 80.0,
                            color: Colors.orange,
                          ),
                           Text(
                            "التصنيفات",
                            style: TextStyle(fontSize: 18.0),
                          )
                        ],
                      ),
                    ),
                  )),
                ],
              ),
              Row(
                children: <Widget>[
                   Expanded(
                      child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const Delivery()));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Column(
                        children: const <Widget>[
                           Icon(
                            Icons.fastfood,
                            size: 80.0,
                            color: Colors.red,
                          ),
                           Text(
                            "الدليفري",
                            style: TextStyle(fontSize: 18.0),
                          )
                        ],
                      ),
                    ),
                  )),
                   Expanded(
                      child: Container(
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Column(
                      children: const <Widget>[
                         Icon(
                          Icons.message,
                          size: 80.0,
                          color: Colors.blue,
                        ),
                         Text(
                          "الطلبيات",
                          style: TextStyle(fontSize: 18.0),
                        )
                      ],
                    ),
                  )),
                ],
              ),
              Row(
                children: <Widget>[
                   Expanded(
                      child: Container(
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Column(
                      children: const <Widget>[
                         Icon(
                          Icons.notifications,
                          size: 80.0,
                          color: Colors.lime,
                        ),
                         Text(
                          "الاشعارات",
                          style: TextStyle(fontSize: 18.0),
                        )
                      ],
                    ),
                  )),
                   Expanded(
                      child: Container(
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Column(
                      children: const <Widget>[
                         Icon(
                          Icons.access_alarms,
                          size: 80.0,
                          color: Colors.orange,
                        ),
                         Text(
                          "الطلبيات قيد التنفيذ",
                          style: TextStyle(fontSize: 18.0),
                        )
                      ],
                    ),
                  )),
                ],
              ),
            ],
          ),
        ));
  }
}