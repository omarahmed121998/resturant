import 'dart:ui';
import 'package:e_commers_app/pages/component/progress.dart';
import 'package:e_commers_app/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../function.dart';
import 'add.dart';
import 'food_data.dart';

class Food extends StatefulWidget {
  final String catid;
  final String catname;
  const Food({Key? key, required this.catid, required this.catname}) 
  : super(key: key);
  @override
  _FoodState createState() => _FoodState();
}

class _FoodState extends State<Food> {
  late ScrollController myScroll;
  late GlobalKey<RefreshIndicatorState> refreshKey;
  int i = 0;
  bool loadingList = false;
  void getDataFood(int count, String strSearch) async {
    loadingList = true;
    setState(() {});
    List? arr = await getData(
        count, , strSearch, "cat_id=${widget.catid}&",);
    for (int i = 0; i < arr!.length; i++) {
      foodList!.add( FoodData(
        fooid: arr[i]["foo_id"],
        catid: arr[i]["cat_id"],
        fooname: arr[i]["foo_name"],
        foonameen: arr[i]["foo_name_en"],
        fooprice: arr[i]["foo_price"],
        foooffer: arr[i]["foo_offer"],
        fooinfo: arr[i]["foo_info"],
        fooinfoen: arr[i]["foo_info_en"],
        fooregdate: arr[i]["foo_regdate"],
        foothumbnail: arr[i]["foo_thumbnail"],
      ));
    }
    loadingList = false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    myScroll.dispose();
    foodList!.clear();
  }

  @override
  void initState() {
    super.initState();
    _appBarTitle =  Text(widget.catname);
    foodList =  <FoodData>[];
    myScroll =  ScrollController();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    getDataFood(0, "");

    myScroll.addListener(() {
      if (myScroll.position.pixels == myScroll.position.maxScrollExtent) {
        i += 10;
        getDataFood(i, "");
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

          foodList!.clear();
          i = 0;
          getDataFood(0, text);
          myProv.addLoading();
        },
      );
    } else {
      _searchIcon =  const Icon(Icons.search);
      _appBarTitle =  const Text("بحث باسم المأكولات");
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
          foodList!.clear();
          getDataFood(0, "");
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
                  itemCount: foodList!.length,
                  itemBuilder: (context, index) {
                    final item = foodList![index];
                    return Dismissible(
                      key: Key(item.fooid),
                      direction: DismissDirection.startToEnd,
                      child: SingleFood(
                        fooindex: index,
                        food: foodList![index],
                      ),
                      onDismissed: (direction) {
                        foodList!.remove(item);
                        deleteData(
                            "foo_id", item.fooid, "food/delete_food.php");
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddFood(
                              catid: widget.catid,
                              catname: widget.catname)));
                },
                child: const Text(
                  "اضافة مأكولات جديدة",
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