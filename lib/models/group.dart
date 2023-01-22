import 'dart:convert';

Group groupFromJson(String str) => Group.fromJson(json.decode(str));

class Group {
  Group({
    required this.members,
    required this.groupId,
    required this.groupName,
  });

  int members;
  String groupId;
  String groupName;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        members: int.tryParse(json["userIdArray"][0]) ?? 0,
        groupId: json["groupId"],
        groupName: json["groupName"],
      );
}
