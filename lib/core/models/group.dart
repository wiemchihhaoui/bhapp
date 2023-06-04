class Group {
  String name;
  String id;
  String idAdmin;
  List members;
  DateTime createdAt;

  Group({required this.name, required this.idAdmin, required this.members, required this.createdAt, required this.id});
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      name: json['name'] as String,
      id: json['id'] as String,
      idAdmin: json['idAdmin'] as String,
      members: json['members'] as List<dynamic>,
      createdAt: json['createdAt'].toDate(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'idAdmin': idAdmin,
      'members': members,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
