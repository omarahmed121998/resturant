import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commers_app/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../function.dart';
import 'edit.dart';

List<FoodData>? foodList;
String imageFood = pathImages + "food/";

class FoodData {
  String fooid;
  String catid;
  String fooname;
  String foonameen;
  String fooprice;
  String foooffer;
  String fooinfo;
  String fooinfoen;
  String fooregdate;
  String foothumbnail;

  FoodData(
      {required this.fooid,
       required this.catid,
      required this.fooname,
      required this.foonameen,
      required this.fooprice,
      required this.foooffer,
      required this.fooinfo,
      required this.fooinfoen,
      required this.fooregdate,
      required this.foothumbnail});
}

class SingleFood extends StatelessWidget {
  int fooindex;
  FoodData food;
  SingleFood({Key? key, required this.fooindex, required this.food}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var providerFood = Provider.of<LoadingControl>(context);
    return Card(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              foodList!.removeAt(fooindex);
              deleteData("foo_id", food.fooid, "food/delete_food.php");
              providerFood.addLoading();
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
            leading: food.foothumbnail == ""
                ? CachedNetworkImage(
                    imageUrl: imageFood + "def.png",
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  )
                : CachedNetworkImage(
                    imageUrl: imageFood + food.foothumbnail,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
            title: Text(
              food.fooname,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(food.fooregdate)]),
            trailing: SizedBox(
              width: 30.0,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  EditFood(
                                  fooindex: fooindex, myfood: food)));
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