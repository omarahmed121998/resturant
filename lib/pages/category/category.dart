import 'dart:ui';
import 'package:e_commers_app/pages/component/progress.dart';
import 'package:e_commers_app/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../function.dart';
import 'add.dart';
import 'category_data.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late ScrollController myScroll;
  late GlobalKey<RefreshIndicatorState> refreshKey;
  int i = 0;
  bool loadingList = false;
  void getDataCategory(int count, String strSearch) async {
    loadingList = true;
    setState(() {});
    List? arr = await getData(count, , strSearch, "");
    for (int i = 0; i < arr!.length; i++) {
      categoryList!.add( CategoryData(
        catid: arr[i]["cat_id"],
        catname: arr[i]["cat_name"],
        catnameen: arr[i]["cat_name_en"],
        catregdate: arr[i]["cat_regdate"],
        catthumbnail: arr[i]["cat_thumbnail"],
      ));
    }
    loadingList = false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    myScroll.dispose();
    categoryList!.clear();
  }

  @override
  void initState() {
    super.initState();
    categoryList =  <CategoryData>[];
    myScroll =  ScrollController();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    getDataCategory(0, "");

    myScroll.addListener(() {
      if (myScroll.position.pixels == myScroll.position.maxScrollExtent) {
        i += 10;
        getDataCategory(i, "");
        print("scroll");
      }
    });
  }

  Icon _searchIcon =  const Icon(Icons.search);
  Widget _appBarTitle =  const Text("ادارة التصنيفات");

  void _searchPressed(LoadingControl myProv) {
    if (_searchIcon.icon == Icons.search) {
      _searchIcon =  const Icon(Icons.close);
      _appBarTitle =  TextField(
        style: const TextStyle(color: Colors.white),
        decoration:  const InputDecoration(
            prefixIcon: Icon(Icons.search), hintText: "ابحث ..."),
        onChanged: (text) {
          print(text);

          categoryList!.clear();
          i = 0;
          getDataCategory(0, text);
          myProv.addLoading();
        },
      );
    } else {
      _searchIcon =  const Icon(Icons.search);
      _appBarTitle =  const Text("بحث باسم التصنيف");
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
          categoryList!.clear();
          getDataCategory(0, "");
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
                  itemCount: categoryList!.length,
                  itemBuilder: (context, index) {
                    final item = categoryList![index];
                    return Dismissible(
                      key: Key(item.catid),
                      direction: DismissDirection.startToEnd,
                      child: SingleCategory(
                        catindex: index,
                        category: categoryList![index],
                      ),
                      onDismissed: (direction) {
                        categoryList!.remove(item);
                        deleteData("cat_id", item.catid,
                            "category/delete_category.php");
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
                      MaterialPageRoute(builder: (context) => const AddCategory()));
                },
                child: const Text(
                  "اضافة تصنيف جديد",
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