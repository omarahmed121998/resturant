import 'package:e_commers_app/pages/component/progress.dart';
import 'package:e_commers_app/pages/provider/loading.dart';
import 'package:e_commers_app/pages/users/users_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../config.dart';
import '../function.dart';

class EditUsers extends StatefulWidget {
  int useindex;
  UsersData users;

  EditUsers({Key? key, required this.useindex, required this.users})
   : super(key: key);
  @override
  _EditUsersState createState() => _EditUsersState();
}

class _EditUsersState extends State<EditUsers> {
  late Widget Function() param2;
  bool isloading = false;
  bool checkActive = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtusename =  TextEditingController();
  TextEditingController txtusepwd =  TextEditingController();
  TextEditingController txtusemobile =  TextEditingController();
  TextEditingController txtusenote =  TextEditingController();

  updateUser(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    bool myvalid = _formKey.currentState!.validate();
    load.addLoading();
    if (txtusename.text.isNotEmpty &&
        txtusemobile.text.isNotEmpty &&
        txtusepwd.text.isNotEmpty &&
        myvalid) {
      isloading = true;
      load.addLoading();
      Map arr = {
        "use_id": widget.users.useid,
        "use_name": txtusename.text,
        "use_mobile": txtusemobile.text,
        "use_pwd": txtusepwd.text,
        "use_active": checkActive ? "1" : "0",
        "use_note": txtusenote.text
      };
      bool res =
          await saveData(arr, "users/update_user.php", context, param2, "update");
      userList![widget.useindex].usename = txtusename.text;
      userList![widget.useindex].usemobile = txtusename.text;
      userList![widget.useindex].usepwd = txtusename.text;
      userList![widget.useindex].usenote = txtusename.text;
      userList![widget.useindex].useactive = checkActive;

      isloading = res;
      load.addLoading();
    } else {
      Toast.show("Please fill data", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  @override
  void dispose() {
    super.dispose();
    txtusename.dispose();
    txtusepwd.dispose();
    txtusemobile.dispose();
    txtusenote.dispose();
  }

  @override
  void initState() {
    super.initState();
    txtusemobile.text = widget.users.usemobile;
    txtusename.text = widget.users.usename;
    txtusenote.text = widget.users.usenote;
    txtusepwd.text = widget.users.usepwd;
    if (widget.users.useactive == "1") {
      checkActive = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text("اضافة مستخدم جديد"),
          centerTitle: true,
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: <Widget>[
                Consumer<LoadingControl>(builder: (context, load, child) {
                  return Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.0)),
                            child: TextFormField(
                              controller: txtusename,
                              decoration: const InputDecoration(
                                  hintText: "اسم المستخدم",
                                  border: InputBorder.none),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  print("enyter name");
                                  return "الرجاء ادخال الاسم ";
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.0)),
                            child: TextFormField(
                              controller: txtusemobile,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: "الموبايل",
                                  border: InputBorder.none),
                              validator: ( value) {
                                if (value!.isEmpty || value.length < 5) {
                                  return "الرجاء ادخال رقم الموبايل";
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.0)),
                            child: TextFormField(
                              controller: txtusepwd,
                              decoration: const InputDecoration(
                                  hintText: "الباسورد",
                                  border: InputBorder.none),
                              validator: ( value) {
                                if (value!.isEmpty || value.length < 5) {
                                  return "الرجاء ادخال الباسورد ";
                                }
                              },
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(bottom: 10.0),
                              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Checkbox(
                                  value: checkActive,
                                  onChanged: (newValue) {
                                    setState(() {
                                      checkActive = newValue!;
                                    });
                                  })),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.0)),
                            child: TextFormField(
                              controller: txtusenote,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                  hintText: "الملاحظات",
                                  border: InputBorder.none),
                            ),
                          ),
                          isloading
                              ? circularProgress()
                              : MaterialButton(
                                  onPressed: () {
                                    updateUser(context, load);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    child: const Text(
                                      "حفظ",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                    margin: const EdgeInsets.only(
                                        bottom: 10.0, top: 30.0),
                                    padding: const EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(25.0)),
                                  )),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ));
  }
}