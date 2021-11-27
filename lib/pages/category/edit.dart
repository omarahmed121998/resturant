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
import 'category_data.dart';

class EditCategory extends StatefulWidget {
  int catindex;
  CategoryData mycategory;

  EditCategory({Key? key, required this.catindex, required this.mycategory})
  : super(key: key);
  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  bool isloading = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController txtcatname =  TextEditingController();
  TextEditingController txtcatnameen =  TextEditingController();
  late Widget Function() movePage;

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

  updateCategory(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    bool myvalid = _formKey.currentState!.validate();
    load.addLoading();
    if (txtcatname.text.isNotEmpty &&
        txtcatnameen.text.isNotEmpty &&
        myvalid) {
      isloading = true;
      load.addLoading();
      Map arr = {
        "cat_id": widget.mycategory.catid,
        "cat_name": txtcatname.text,
        "cat_name_en": txtcatnameen.text,
      };
      bool res = await uploadFileWithData(
          _image, arr, "category/update_category.php", context, movePage, "update");
      categoryList![widget.catindex].catname = txtcatname.text;

      categoryList![widget.catindex].catnameen = txtcatname.text;

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
    txtcatname.dispose();
    txtcatnameen.dispose();
  }

  String imageEdit = "";
  @override
  void initState() {
    super.initState();

    txtcatname.text = widget.mycategory.catname;

    txtcatnameen.text = widget.mycategory.catnameen;
    imageEdit = widget.mycategory.catthumbnail == ""
        ? ""
        : pathImages + "category/" + widget.mycategory.catthumbnail;
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
          title: const Text("اضافة تصنيف جديد"),
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
                              controller: txtcatname,
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
                              controller: txtcatnameen,
                              decoration: const InputDecoration(
                                  hintText: "الاسم بالانكليزي",
                                  border: InputBorder.none),
                              validator: ( value) {
                                if (value!.isEmpty || value.length < 5) {
                                  return "الرجاء ادخال الاسم ";
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
                                    updateCategory(context, load);
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