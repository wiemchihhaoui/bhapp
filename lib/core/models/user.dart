import 'package:moneymanager/core/models/transaction.dart';

class AppUser {
  String? userName;
  String? uid;
  String? email;
  String? role;
  int? ceiling;
  List<TransactionProcess>? transactions;

  AppUser({this.uid, this.userName, this.email, this.transactions, this.role, this.ceiling});
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json["uid"],
      role: json["role"],
      ceiling: json["ceiling"],
      userName: json["userName"],
      email: json["Email"],
    );
  }
// from object to json
  Map<String, dynamic> Tojson() {
    return {
      "uid": uid,
      "userName": userName,
      "Email": email,
      "role": role,
      "ceiling": 0,
    };
  }
}
