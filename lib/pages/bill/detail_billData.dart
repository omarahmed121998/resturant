class DetailBillData {
  String det_id;
  String foo_id;
  String bil_id;
  String det_qty;
  String det_price;
  String det_note;
  String det_regdate;
  String foo_name;
  String foo_image;

  DetailBillData(
      {required this.det_id,
      required this.foo_id,
      required this.bil_id,
      required this.det_qty,
      required this.det_price,
      required this.det_regdate,
      required this.det_note,
      required this.foo_image,
      required this.foo_name});
}