class Request {
  String userId;
  String groupId;
  String id;

  Request({
    required this.userId,
    required this.groupId,
    required this.id,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      userId: json['userId'] as String,
      id: json['id'] as String,
      groupId: json['groupId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'groupId': groupId,
    };
  }
}
