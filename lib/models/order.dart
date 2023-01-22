// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    required this.isComplete,
    required this.id,
    required this.orderId,
    required this.userId,
    required this.storeName,
    required this.address,
    required this.list,
    required this.createdAt,
    required this.v,
  });

  bool isComplete;
  String id;
  String orderId;
  String userId;
  String storeName;
  String address;
  String list;
  DateTime createdAt;
  int v;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        isComplete: json["isComplete"],
        id: json["_id"],
        orderId: json["orderId"],
        userId: json["userId"],
        storeName: json["storeName"],
        address: json["address"],
        list: json["list"],
        createdAt: DateTime.parse(json["createdAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "isComplete": isComplete,
        "_id": id,
        "orderId": orderId,
        "userId": userId,
        "storeName": storeName,
        "address": address,
        "list": list,
        "createdAt": createdAt.toIso8601String(),
        "__v": v,
      };
}
