import 'dart:ui';
import 'package:e_commers_app/pages/component/progress.dart';
import 'package:e_commers_app/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../function.dart';
import 'add.dart';
import 'delivery_data.dart';

class Delivery extends StatefulWidget {
  const Delivery({Key? key}) : super(key: key);

  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  late ScrollController myScroll;
  late GlobalKey<RefreshIndicatorState> refreshKey;
  int i = 0;
  bool loadingList = false;
  void getDataDelivery(int count, String strSearch) async {
    loadingList = true;
    setState(() {});
    List? arr = await getData(count,'delivery/readdelivery.php', strSearch, "");
    for (int i = 0; i < arr!.length; i++) {
      deliveryList!.add( DeliveryData(
        delid: arr[i]["del_id"],
        delname: arr[i]["del_name"],
        delpwd: arr[i]["del_pwd"],
        delmobile: arr[i]["del_mobile"],
        delnote: arr[i]["del_note"],
        delregdate: arr[i]["del_regdate"],
        delthumbnail: arr[i]["del_thumbnail"],
      ));
    }
    loadingList = false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    myScroll.dispose();
    deliveryList!.clear();
  }

  @override
  void initState() {
    super.initState();
    _appBarTitle =  const Text("استعراض الدليفري");
    deliveryList =  <DeliveryData>[];
    myScroll =  ScrollController();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    getDataDelivery(0, "");

    myScroll.addListener(() {
      if (myScroll.position.pixels == myScroll.position.maxScrollExtent) {
        i += 10;
        getDataDelivery(i, "");
        print("scroll");
      }
    });
  }

  Icon _searchIcon =  const Icon(Icons.search);
  late Widget _appBarTitle;

  void _searchPressed(LoadingControl myProv) {
    if (_searchIcon.icon == Icons.search) {
      _searchIcon =  const Icon(Icons.close);
      _appBarTitle =  TextField(
        style: const TextStyle(color: Colors.white),
        decoration:  const InputDecoration(
            prefixIcon: Icon(Icons.search), hintText: "ابحث ..."),
        onChanged: (text) {
          print(text);

          deliveryList!.clear();
          i = 0;
          getDataDelivery(0, text);
          myProv.addLoading();
        },
      );
    } else {
      _searchIcon =  const Icon(Icons.search);
      _appBarTitle =  const Text("بحث باسم الدليفري");
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
          deliveryList!.clear();
          getDataDelivery(0, "");
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
                  itemCount: deliveryList!.length,
                  itemBuilder: (context, index) {
                    final item = deliveryList![index];
                    return Dismissible(
                      key: Key(item.delid),
                      direction: DismissDirection.startToEnd,
                      child: SingleDelivery(
                        delindex: index,
                        delivery: deliveryList![index],
                      ),
                      onDismissed: (direction) {
                        deliveryList!.remove(item);
                        deleteData("del_id", item.delid,
                            "delivery/delete_delivery.php");
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
                      MaterialPageRoute(builder: (context) => const AddDelivery()));
                },
                child: const Text(
                  "اضافة دليفري جديد",
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