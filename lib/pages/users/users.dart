import 'dart:ui';
import 'package:e_commers_app/pages/component/progress.dart';
import 'package:e_commers_app/pages/provider/loading.dart';
import 'package:e_commers_app/pages/users/users_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../function.dart';
import 'add.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  late ScrollController myScroll;
  late GlobalKey<RefreshIndicatorState> refreshKey;
  int i = 0;
  bool loadingList = false;
  void getDataUser(int count, String strSearch) async {
    loadingList = true;
    setState(() {});
    List? arr = await getData(count, , strSearch, "");
    for (int i = 0; i < arr!.length; i++) {
      userList!.add( UsersData(
        useid: arr[i]["use_id"],
        usename: arr[i]["use_name"],
        usepwd: arr[i]["use_pwd"],
        usemobile: arr[i]["use_mobile"],
        useactive: arr[i]["use_active"] == "1" ? true : false,
        uselastdate: arr[i]["use_lastdate"],
        usenote: arr[i]["use_note"],
      ));
    }
    loadingList = false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    myScroll.dispose();
    userList!.clear();
  }

  @override
  void initState() {
    super.initState();
    userList =  <UsersData>[];
    myScroll =  ScrollController();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    getDataUser(0, "");

    myScroll.addListener(() {
      if (myScroll.position.pixels == myScroll.position.maxScrollExtent) {
        i += 10;
        getDataUser(i, "");
        print("scroll");
      }
    });
  }

  Icon _searchIcon =  const Icon(Icons.search);
  Widget _appBarTitle =  const Text("ادارة اليوزر");

  void _searchPressed(LoadingControl myProv) {
    if (_searchIcon.icon == Icons.search) {
      _searchIcon =  const Icon(Icons.close);
      _appBarTitle =  TextField(
        style: const TextStyle(color: Colors.white),
        decoration:  const InputDecoration(
            prefixIcon: Icon(Icons.search), hintText: "ابحث ..."),
        onChanged: (text) {
          print(text);

          userList!.clear();
          i = 0;
          getDataUser(0, text);
          myProv.addLoading();
        },
      );
    } else {
      _searchIcon =  const Icon(Icons.search);
      _appBarTitle =  const Text("بحث باسم المستخدم");
    }
    myProv.addLoading();
  }

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<LoadingControl>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: _appBarTitle,
        centerTitle: true,
        actions: [
          Container(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                _searchPressed(myProvider);
              },
              child: _searchIcon,
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: () async {
          i = 0;
          userList!.clear();
          getDataUser(0, "");
        },
        key: refreshKey,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 0),
                child: ListView.builder(
                  controller: myScroll,
                  itemCount: userList!.length,
                  itemBuilder: (context, index) {
                    final item = userList![index];
                    return Dismissible(
                      key: Key(item.useid),
                      direction: DismissDirection.startToEnd,
                      child: SingleUser(
                        useindex: index,
                        users: userList![index],
                      ),
                      onDismissed: (direction) {
                        userList!.remove(item);
                        deleteData(
                            "use_id", item.useid, "users/delete_user.php");
                        myProvider.addLoading();
                      },
                    );
                  },
                ),
              ),
              Positioned(
                  child: loadingList ? circularProgress() : const Text(""),
                  bottom: 0,
                  left: MediaQuery.of(context).size.width / 2)
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 50.0,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddUsers()));
                },
                child: const Text(
                  "اضافة مستخدم جديد",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              height: 40.0,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(40)),
            ),
          ],
        ),
      ),
    );
  }
}