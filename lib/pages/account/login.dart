import 'package:e_commers_app/pages/component/progress.dart';
import 'package:e_commers_app/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../config.dart';
import 'login_data.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isloading = false;
  TextEditingController txtmobile =  TextEditingController();
  TextEditingController txtpwd =  TextEditingController();
  void login(context, load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    if (txtmobile.text.isNotEmpty && txtpwd.text.isNotEmpty) {
      isloading = true;
      load.add_loading();
      bool res = await loginUsers(txtmobile.text, txtpwd.text, context);
      isloading = res;
      load.add_loading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Form(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 35.0),
                        child: const Text(
                          "سجل الدخول الى حسابك من هنا ",
                          style: TextStyle(fontSize: 25.0, color: Colors.red),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0)),
                        child: TextFormField(
                          controller: txtmobile,
                          decoration: const InputDecoration(
                              hintText: "الموبايل", border: InputBorder.none),
                          validator: ( value) {
                            if (value!.isEmpty) {
                              return "الرجاء ادخال الموبايل";
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
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: txtpwd,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    hintText: "كلمة المرور",
                                    border: InputBorder.none),
                                validator: ( value) {
                                  if (value!.isEmpty || value.length < 6) {
                                    return "الرجاء ادخال كلمة المرور";
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Consumer<LoadingControl>(builder: (context, load, child) {
                        return isloading
                            ? circularProgress()
                            : MaterialButton(
                                onPressed: () {
                                  login(context, load);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  child: const Text(
                                    "دخول",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  ),
                                  margin:
                                      const EdgeInsets.only(bottom: 10.0, top: 30.0),
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                ));
                      })
                    ],
                  ),
                )),
              ],
            ),
          ),
        ));
  }
}