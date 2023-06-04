class TransactionProcess {
  final String type;
  final String day;
  final DateTime? date;
  final String month;
  final String memo;
  final String? id;
  double amount;
  final int categoryindex;
  TransactionProcess(
      {required this.type,
      required this.day,
      this.date,
      required this.month,
      required this.memo,
      this.id,
      required this.amount,
      required this.categoryindex});
  factory TransactionProcess.fromJson(Map<String, dynamic> json) {
    return TransactionProcess(
      type: json['type'],
      day: json['day'],
      month: json['month'],
      date: json['date'].toDate(),
      memo: json['memo'],
      id: json['id'],
      amount: json['amount'],
      categoryindex: json['categoryindex'],
    );
  }
  Map<String, dynamic> Tojson() {
    return {
      "type": type,
      "day": day,
      "month": month,
      "memo": memo,
      "amount": amount,
      "date":date,
      "categoryindex": categoryindex,
    };
  }
}
