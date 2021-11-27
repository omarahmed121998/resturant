import 'package:e_commers_app/pages/account/login.dart';
import 'package:e_commers_app/pages/bill/bill.dart';
import 'package:flutter/material.dart';

import '../config.dart';


class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void logout(context) {
    prefs!.remove(gCusId);
    prefs!.remove(gCusname);
    prefs!.remove(gCusmobile);
    prefs!.remove(gCusimage);

    prefs!.clear();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) =>  const Login()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Drawer(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: const Text(
                "Omar Ahmed",
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              accountEmail: const Text(
                "omar@gmail.com",
                style: TextStyle(color: Colors.grey),
              ),
              currentAccountPicture: GestureDetector(
                child:  const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
              decoration: BoxDecoration(color: Colors.grey[100]),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {},
                    child: const ListTile(
                      title: Text(
                        "الصفحة الرئيسية",
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                      ),
                      leading: Icon(
                        Icons.home,
                        color: Colors.red,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 18.0,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new Category()));
                   */
                    },
                    child: const ListTile(
                      title: Text(
                        "قائمة التصنيفات",
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                      ),
                      leading: Icon(
                        Icons.restaurant,
                        color: Colors.red,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 18.0,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
            Theme(
              data: theme,
              child: ExpansionTile(
                title: const Text(
                  "حسابي",
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                children: <Widget>[
//======================child account
                  Container(
                    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new MyProfile()));
                         */
                          },
                          child: const ListTile(
                            title: Text(
                              "تغيير الاعدادات الشخصية",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            leading: Icon(
                              Icons.settings,
                              color: Colors.red,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 18.0,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[500],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            /*  Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new ChangePassword()));
                         */
                          },
                          child: const ListTile(
                            title: Text(
                              "تغيير كلمة المرور",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            leading: Icon(
                              Icons.lock_open,
                              color: Colors.red,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //======================end child account
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: Divider(
                color: Colors.grey[500],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      /*  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new Favorite()));
                    */
                    },
                    child: const ListTile(
                      title: Text(
                        "قائمة المأكولات",
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                      ),
                      leading: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 18.0,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  const Bill()));
                    },
                    child: const ListTile(
                      title: Text(
                        "طلبات الزبائن",
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                      ),
                      leading: Icon(
                        Icons.history,
                        color: Colors.red,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 18.0,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new Tracking()));*/
                    },
                    child: const ListTile(
                      title: Text(
                        "تتبع الطلبيات",
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                      ),
                      leading: Icon(
                        Icons.drive_eta,
                        color: Colors.red,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 18.0,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      logout(context);
                    },
                    child: const ListTile(
                      title: Text(
                        "خروج",
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                      ),
                      leading: Icon(
                        Icons.drive_eta,
                        color: Colors.red,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 18.0,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}