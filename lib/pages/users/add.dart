import 'package:e_commers_app/pages/component/progress.dart';
import 'package:e_commers_app/pages/provider/loading.dart';
import 'package:e_commers_app/pages/users/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../config.dart';
import '../function.dart';


class AddUsers extends StatefulWidget {
  const AddUsers({Key? key}) : super(key: key);

  @override
  _AddUsersState createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {

  late Users Function() param2;
  bool isloading = false;
  bool checkActive = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtusename =  TextEditingController();
  TextEditingController txtusepwd =  TextEditingController();
  TextEditingController txtusemobile =  TextEditingController();
  TextEditingController txtusenote =  TextEditingController();

  saveData(context, LoadingControl load, Users Function() param2, String s) async {
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
        "use_name": txtusename.text,
        "use_mobile": txtusemobile.text,
        "use_pwd": txtusepwd.text,
        "use_active": checkActive ? "1" : "0",
        "use_note": txtusenote.text
      };
      bool res = await saveData(
          arr, context, () => Users(), "insert");

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
                                    saveData(context, load,param2,"");
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