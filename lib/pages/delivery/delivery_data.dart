import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commers_app/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../function.dart';
import 'edit.dart';

List<DeliveryData>? deliveryList;
String imageDelivery = pathImages + "delivery/";

class DeliveryData {
  String delid;

  String delname;
  String delpwd;
  String delmobile;

  String delnote;
  String delregdate;
  String delthumbnail;

  DeliveryData(
      {required this.delid,
      required this.delname,
      required this.delpwd,
      required this.delmobile,
      required this.delnote,
      required this.delregdate,
      required this.delthumbnail});
}

class SingleDelivery extends StatelessWidget {
  int delindex;
  DeliveryData delivery;
  SingleDelivery({Key? key, required this.delindex, required this.delivery}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var providerDelivery = Provider.of<LoadingControl>(context);
    return Card(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              deliveryList!.removeAt(delindex);
              deleteData(
                  "del_id", delivery.delid, "delivery/delete_delivery.php");
              providerDelivery.addLoading();
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
            leading: delivery.delthumbnail == ""
                ? CachedNetworkImage(
                    imageUrl: imageDelivery + "def.png",
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  )
                : CachedNetworkImage(
                    imageUrl: imageDelivery + delivery.delthumbnail,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
            title: Text(
              delivery.delname,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(delivery.delregdate)]),
            trailing: SizedBox(
              width: 30.0,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  EditDelivery(
                                  del_index: delindex,
                                  mydelivery: delivery)));
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