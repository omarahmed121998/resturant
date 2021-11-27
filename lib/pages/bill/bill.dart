import 'package:e_commers_app/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commers_app/pages/bill/detail_bill.dart';
import '../config.dart';
import '../function.dart';
import 'billData.dart';
import 'detail_bill.dart';

List<BillData>? billList;

class Bill extends StatefulWidget {
  const Bill({Key? key}) : super(key: key);

  @override
  _BillState createState() => _BillState();
}

class _BillState extends State<Bill> {
  late ScrollController myScroll;
  late GlobalKey<RefreshIndicatorState> refreshKey;
  int i = 0;
  bool loadingList = false;

  void getDatabill(int count, String strSearch) async {
    loadingList = true;
    setState(() {});
    List? arr = await getData(
        count,"bill/readbill.php", strSearch, "");
    for (int i = 0; i < arr!.length; i++) {
      billList!.add(BillData(
        bil_id: arr[i]["bil_id"],
        cus_id: arr[i]["cus_id"],
        bil_address: arr[i]["bil_address"],
        del_id: arr[i]["del_id"],
        bil_regdate: arr[i]["bil_regdate"],
        bil_after_note: '',
        bil_before_note: '',
        bil_rate: '',
      ));
    }
    loadingList = false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    myScroll.dispose();
    billList!.clear();
  }

  @override
  void initState() {
    super.initState();
    _appBarTitle =
        const Text("الطلبيات", style: TextStyle(color: Colors.black));
    billList = <BillData>[];
    myScroll = ScrollController();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    getDatabill(0, "");

    myScroll.addListener(() {
      if (myScroll.position.pixels == myScroll.position.maxScrollExtent) {
        i += 20;
        getDatabill(i, "");
        print("scroll");
      }
    });
  }

  Icon _searchIcon = const Icon(
    Icons.search,
    color: Colors.black,
  );
  late Widget _appBarTitle;

  void _searchPressed(LoadingControl myProv) {
    if (_searchIcon.icon == Icons.search) {
      _searchIcon = const Icon(Icons.close);
      _appBarTitle = TextField(
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search), hintText: "ابحث ..."),
        onChanged: (text) {
          print(text);

          billList!.clear();
          i = 0;
          getDatabill(0, text);
          myProv.addLoading();
        },
      );
    } else {
      _searchIcon = const Icon(Icons.search);
      _appBarTitle = const Text(
        "بحث باسم المأكولات",
        style: TextStyle(color: Colors.black),
      );
    }
    myProv.addLoading();
  }

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<LoadingControl>(context);
    return Scaffold(
        appBar: AppBar(
          title: _appBarTitle,
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
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
        body: RefreshIndicator(
          onRefresh: () async {
            i = 0;
            billList!.clear();
            getDatabill(0, "");
          },
          key: refreshKey,
          child: ListView.builder(
            controller: myScroll,
            itemCount: billList!.length,
            itemBuilder: (context, index) {
              return SingleBill(
                bilIndex: index,
                bill: billList![index],
              );
            },
          ),
        ));
  }
}

class SingleBill extends StatelessWidget {
  int bilIndex;
  BillData bill;
  SingleBill({
    Key? key,
    required this.bilIndex,
    required this.bill,
  }) : super(key: key);

  bool isloadingFav = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailBill(
                      bilId: bill.bil_id,
                      bilRegdate: bill.bil_regdate,
                    )));
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bill.bil_regdate,
                style: const TextStyle(
                    fontFamily: "arial", fontSize: 16, color: Colors.grey),
              ),
              Row(
                children: [
                  Text(
                    bill.bil_id,
                    style: const TextStyle(
                        fontFamily: "arial", color: Colors.red, fontSize: 16),
                  ),
                  const Text("  "),
                  const Text("رقم الفاتورة"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
