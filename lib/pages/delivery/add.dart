import 'dart:io';

import 'package:e_commers_app/pages/component/progress.dart';
import 'package:e_commers_app/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import '../config.dart';
import '../function.dart';
import 'package:path/path.dart';

import 'delivery.dart';

class AddDelivery extends StatefulWidget {
  const AddDelivery({Key? key}) : super(key: key);

  @override
  _AddDeliveryState createState() => _AddDeliveryState();
}

class _AddDeliveryState extends State<AddDelivery> {
  bool isloading = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController txtdel_name =  TextEditingController();
  TextEditingController txtdel_pwd =  TextEditingController();
  TextEditingController txtdel_mobile =  TextEditingController();

  TextEditingController txtdel_note =  TextEditingController();

  saveData(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    bool myvalid = _formKey.currentState!.validate();
    load.addLoading();
    if (txtdel_name.text.isNotEmpty && txtdel_pwd.text.isNotEmpty && myvalid) {
      isloading = true;
      load.addLoading();
      Map arr = {
        "del_name": txtdel_name.text,
        "del_pwd": txtdel_pwd.text,
        "del_mobile": txtdel_mobile.text,
        "del_note": txtdel_note.text,
      };

      bool res = await uploadFileWithData(_image, arr,
          "delivery/insert_delivery.php", context, () => Delivery(), "insert");
      /*await createData(
          arr, "delivery/insert_delivery.php", context, () => Delivery());*/

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
    txtdel_name.dispose();
    txtdel_pwd.dispose();
  }

  late File _image;
  final picker = ImagePicker();
  Future getImageGallery() async {
    // ignore: deprecated_member_use
    var image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageCamera() async {
    // ignore: deprecated_member_use
    var image = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void showSheetGallery(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: [
           ListTile(
            leading:  const Icon(Icons.image),
            title:  const Text("معرض الصور"),
            onTap: () {
              getImageGallery();
            },
          ),
           ListTile(
            leading:  const Icon(Icons.camera),
            title:  const Text("كاميرا"),
            onTap: () {
              getImageCamera();
            },
          ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text("اضافة دليفري جديدة"),
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
                              controller: txtdel_name,
                              decoration: const InputDecoration(
                                  hintText: "الاسم ", border: InputBorder.none),
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
                              controller: txtdel_pwd,
                              decoration: const InputDecoration(
                                  hintText: "الباسورد",
                                  border: InputBorder.none),
                              validator: ( value) {
                                if (value!.isEmpty) {
                                  return "الرجاء ادخال الباسورد ";
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
                              controller: txtdel_mobile,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: "الموبايل",
                                  border: InputBorder.none),
                              validator: ( value) {
                                if (value!.isEmpty) {
                                  return "الرجاء ادخال الموبايل ";
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
                              controller: txtdel_note,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                  hintText: "التفاصيل ",
                                  border: InputBorder.none),
                              validator: ( value) {
                                if (value!.isEmpty) {
                                  return "الرجاء ادخال التفاصيل  ";
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: IconButton(
                                icon: Icon(
                                  Icons.image,
                                  size: 60.0,
                                  color: Colors.orange[400],
                                ),
                                onPressed: () {
                                  showSheetGallery(context);
                                }),
                          ),
                          Container(
                            padding: const EdgeInsets.all(15.0),
                            // ignore: unnecessary_null_comparison
                            child: _image == null
                                ?  const Text("الصورة غير محددة")
                                :  Image.file(
                                    _image,
                                    width: 150.0,
                                    height: 150.0,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          isloading
                              ? circularProgress()
                              : MaterialButton(
                                  onPressed: () {
                                    saveData(context, load);
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