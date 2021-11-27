import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commers_app/pages/component/progress.dart';
import 'package:e_commers_app/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../config.dart';
import '../function.dart';
import 'food_data.dart';

class EditFood extends StatefulWidget {
  int fooindex;
  FoodData myfood;

  EditFood({Key? key, required this.fooindex, required this.myfood}) 
  : super(key: key);
  @override
  _EditFoodState createState() => _EditFoodState();
}

class _EditFoodState extends State<EditFood> {
  bool isloading = false;
  late Widget Function() movePage;

  final _formKey = GlobalKey<FormState>();
  TextEditingController txtfooname =  TextEditingController();
  TextEditingController txtfoonameen =  TextEditingController();
  TextEditingController txtfooprice =  TextEditingController();
  TextEditingController txtfoooffer =  TextEditingController();
  TextEditingController txtfooinfo =  TextEditingController();
  TextEditingController txtfooinfoen =  TextEditingController();

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

  updateFood(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    bool myvalid = _formKey.currentState!.validate();
    load.addLoading();
    if (txtfooname.text.isNotEmpty &&
        txtfoonameen.text.isNotEmpty &&
        myvalid) {
      isloading = true;
      load.addLoading();
      Map arr = {
        "foo_id": widget.myfood.fooid,
        "foo_name": txtfooname.text,
        "foo_name_en": txtfoonameen.text,
        "foo_price": txtfooprice.text,
        "foo_offer": txtfoooffer.text,
        "foo_info": txtfooinfo.text,
        "foo_info_en": txtfooinfoen.text,
      };
      bool res = await uploadFileWithData(
          _image, arr, "food/update_food.php", context, movePage, "update");
      foodList![widget.fooindex].fooname = txtfooname.text;

      foodList![widget.fooindex].foonameen = txtfooname.text;

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
    txtfooname.dispose();
    txtfoonameen.dispose();
  }

  String imageEdit = "";
  @override
  void initState() {
    super.initState();

    txtfooname.text = widget.myfood.fooname;
    txtfoonameen.text = widget.myfood.foonameen;
    txtfooprice.text = widget.myfood.fooprice;
    txtfoooffer.text = widget.myfood.foooffer;
    txtfooinfo.text = widget.myfood.fooinfo;
    txtfooinfoen.text = widget.myfood.fooinfoen;

    imageEdit =
        widget.myfood.foothumbnail == ""
            ? ""
            : pathImages + "food/" + widget.myfood.foothumbnail;
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
          title: const Text("تعديل المأكولات"),
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
                              controller: txtfooname,
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
                              controller: txtfoonameen,
                              decoration: const InputDecoration(
                                  hintText: "الاسم بالانكليزي",
                                  border: InputBorder.none),
                              validator: ( value) {
                                if (value!.isEmpty) {
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
                              controller: txtfooprice,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: "السعر", border: InputBorder.none),
                              validator: ( value) {
                                if (value!.isEmpty) {
                                  return "الرجاء ادخال السعر ";
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
                              controller: txtfoooffer,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: "الخصم", border: InputBorder.none),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.0)),
                            child: TextFormField(
                              controller: txtfooinfo,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                  hintText: "التفاصيل",
                                  border: InputBorder.none),
                              validator: ( value) {
                                if (value!.isEmpty) {
                                  return "الرجاء ادخال التفاصيل ";
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
                              controller: txtfooinfoen,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                  hintText: "التفاصيل انكليزي",
                                  border: InputBorder.none),
                              validator: ( value) {
                                if (value!.isEmpty) {
                                  return "الرجاء ادخال التفاصيل انكليزي ";
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
                                ? (imageEdit == ""
                                    ?  const Text("الصورة غير محددة")
                                    : CachedNetworkImage(
                                        imageUrl: imageEdit,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ))
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
                                    updateFood(context, load);
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