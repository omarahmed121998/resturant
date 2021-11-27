class BillData{
  String bil_id;
  String bil_address;
  String bil_after_note;
  String bil_before_note;
  String bil_rate;
  String cus_id;
  String del_id;
  String bil_regdate;

  BillData(
      {
      required this.bil_id,
      required this.bil_before_note,
      required this.bil_address,
      required this.bil_after_note,
      required this.bil_rate,
      required this.bil_regdate,
      required this.cus_id,
      required this.del_id});
}