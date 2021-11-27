import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commers_app/pages/food/food.dart';
import 'package:e_commers_app/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../function.dart';
import 'edit.dart';

List<CategoryData>? categoryList;
String imageCategory = pathImages + "category/";

class CategoryData {
  String catid;
  String catname;
  String catnameen;
  String catregdate;
  String catthumbnail;

  CategoryData(
      {required this.catid,
      required this.catname,
      required this.catnameen,
      required this.catregdate,
      required this.catthumbnail});
}

class SingleCategory extends StatelessWidget {
  int catindex;
  CategoryData category;
  SingleCategory({Key? key, required this.catindex, required this.category}) 
  : super(key: key);
  @override
  Widget build(BuildContext context) {
    var providerCategory = Provider.of<LoadingControl>(context);
    return Card(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              categoryList!.removeAt(catindex);
              deleteData(
                  "cat_id", category.catid, "category/delete_category.php");
              providerCategory.addLoading();
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
            leading: category.catthumbnail == ""
                ? CachedNetworkImage(
                    imageUrl: imageCategory + "def.png",
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  )
                : CachedNetworkImage(
                    imageUrl: imageCategory + category.catthumbnail,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
            title: Text(
              category.catname,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.catregdate),
                  ElevatedButton(
                    child: const Text("اضافة المأكولات"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  Food(
                                  catid: category.catid,
                                  catname: category.catname)));
                    },
                  )
                ]),
            trailing: SizedBox(
              width: 30.0,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  EditCategory(
                                  catindex: catindex,
                                  mycategory: category)));
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