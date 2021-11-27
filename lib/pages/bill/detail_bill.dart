import 'package:flutter/material.dart';
import '../function.dart';

import 'detail_billData.dart';

List<DetailBillData>? billList;
int sum = 0;

class DetailBill extends StatefulWidget {
  final String bilId;
  final String bilRegdate;
  const DetailBill({
    Key? key,
    required this.bilId,
    required this.bilRegdate,
  }) : super(key: key);
  @override
  _BillState createState() => _BillState();
}

class _BillState extends State<DetailBill> {
  late ScrollController myScroll;
  late GlobalKey<RefreshIndicatorState> refreshKey;
  int i = 0;
  bool loadingList = false;

  void getDatabill(int count, String strSearch) async {
    loadingList = true;
    setState(() {});
    List? arr = await getData(count,"bill/readdetail_bill.php",
     strSearch,'bilId=${widget.bilId}&');
    for (int i = 0; i < arr!.length; i++) {
      billList!.add(DetailBillData(
        det_id: arr[i]["det_id"],
        foo_id: arr[i]["foo_id"],
        foo_name: arr[i]["foo_name"],
        foo_image: arr[i]["foo_image"],
        det_note: arr[i]["det_note"],
        det_price: arr[i]["det_price"],
        det_qty: arr[i]["det_qty"],
        bil_id: '',
        det_regdate: '',
      ));
      sum += int.parse(arr[i]["det_price"]) * int.parse(arr[i]["det_qty"]);
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
    sum = 0;
    _appBarTitle =
        const Text("تفاصيل الطلبية", style: TextStyle(color: Colors.black));
    billList = <DetailBillData>[];
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

  late Widget _appBarTitle;

  @override
  Widget build(BuildContext context) {
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
        ),
        body: ListView(
          children: [
            Container(
              height: 130,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("رقم الفاتورة" " " + widget.bilId,
                      style:
                          const TextStyle(fontFamily: "arial", fontSize: 16)),
                  Text("تاريخ الفاتورة" " " + widget.bilRegdate,
                      style:
                          const TextStyle(fontFamily: "arial", fontSize: 16)),
                  Text("اجمالي الفاتورة" " " + sum.toString(),
                      style:
                          const TextStyle(fontFamily: "arial", fontSize: 16)),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 140,
              child: RefreshIndicator(
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
                    return SingleDetailBill(
                      bilIndex: index,
                      DetailBill: billList![index],
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}

class SingleDetailBill extends StatelessWidget {
  int bilIndex;
  DetailBillData DetailBill;
  SingleDetailBill({
    Key? key,
    required this.bilIndex,
    required this.DetailBill,
  }) : super(key: key);

  bool isloadingFav = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                      "الاجمالي :" +
                          (int.parse(DetailBill.det_qty) *
                                  int.parse(DetailBill.det_price))
                              .toString(),
                      style:
                          const TextStyle(fontFamily: "arial", fontSize: 16)),
                  const Text("      "),
                  Text("السعر : " + DetailBill.det_price,
                      style: const TextStyle(
                          fontFamily: "arial",
                          color: Colors.red,
                          fontSize: 16)),
                  const Text(" "),
                  Text("الكمية :" + DetailBill.det_qty,
                      style: const TextStyle(
                          fontFamily: "arial",
                          color: Colors.red,
                          fontSize: 16)),
                  const Text(" "),
                ],
              ),
              Text(
                DetailBill.foo_name,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
