// To parse this JSON data, do
//
//     final request = requestFromJson(jsonString);

import 'dart:convert';

Request requestFromJson(String str) => Request.fromJson(json.decode(str));

String requestToJson(Request data) => json.encode(data.toJson());

class Request {
  Request({
    required this.item,
    required this.userName,
  });

  Item item;
  String userName;

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        item: Item.fromJson(json["item"]),
        userName: json["userName"],
      );

  Map<String, dynamic> toJson() => {
        "item": item.toJson(),
        "userName": userName,
      };
}

class Item {
  Item({
    required this.isComplete,
    required this.orderId,
    required this.userId,
    required this.groupId,
    required this.storeName,
    required this.address,
    required this.list,
    required this.createdAt,
  });

  bool isComplete;
  String orderId;
  String userId;
  String groupId;
  String storeName;
  String address;
  String list;
  DateTime createdAt;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        isComplete: json["isComplete"],
        orderId: json["orderId"],
        userId: json["userId"],
        groupId: json["groupId"],
        storeName: json["storeName"],
        address: json["address"],
        list: json["list"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "isComplete": isComplete,
        "orderId": orderId,
        "userId": userId,
        "groupId": groupId,
        "storeName": storeName,
        "address": address,
        "list": list,
        "createdAt": createdAt.toIso8601String(),
      };
}
