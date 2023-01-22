import 'dart:convert';

import 'package:conu_hacks_2005/models/order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../models/group.dart';
import '../models/request.dart';

class ApiService {
  ApiService._();
  static ApiService? _instance;
  static ApiService get instance => _instance ??= ApiService._();
  final _baseUrl = "https://red-results-ask-70-80-20-156.loca.lt";

  Future<Map<String, dynamic>> sendUserDetails() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser?.uid);
    try {
      final response = await http.post(Uri.parse("$_baseUrl/user/user-details"), body: {
        "userId": currentUser?.uid,
        "userName": currentUser?.displayName,
        "userEmail": currentUser?.email,
        "userImage": currentUser?.photoURL,
      });
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Something went wrong'};
    }
  }

  Future<Map<String, dynamic>> addOrder(
      {required String address,
      required String groupId,
      required String storeName,
      required String list,
      required String createdAt}) async {
    try {
      var uid = FirebaseAuth.instance.currentUser?.uid;
      final response = await http.post(Uri.parse("$_baseUrl/order/add-order"),
          headers: {"Authorization": "Bearer $uid"},
          body: {"storeName": storeName, "address": address, "groupId": groupId, "list": list, "createdAt": createdAt});
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Something went wrong'};
    }
  }

  Future<Map<String, dynamic>> deleteOrder({required String orderId}) async {
    try {
      print(orderId);
      var uid = FirebaseAuth.instance.currentUser?.uid;
      final response = await http.delete(Uri.parse("$_baseUrl/order/delete-order"),
          headers: {"Authorization": "Bearer $uid"}, body: {"orderId": orderId});
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Something went wrong'};
    }
  }

  Future<Map<String, dynamic>> markRequestComplete({required String orderId}) async {
    try {
      var uid = FirebaseAuth.instance.currentUser?.uid;
      final response = await http.post(Uri.parse("$_baseUrl/order/order-complete"),
          headers: {"Authorization": "Bearer $uid"}, body: {"orderId": orderId});
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Something went wrong'};
    }
  }

  Future<List<Order>?> getOrders() async {
    var uid = FirebaseAuth.instance.currentUser?.uid;

    print(uid);
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/order/get-orders"),
        headers: {"Authorization": "Bearer $uid"},
      );

      final List list = jsonDecode(response.body)['orderDetails'];

      return list.map((e) => Order.fromJson(e)).toList();
    } catch (e) {
      return null;
    }
  }

  Future<List<Request>?> getRequests() async {
    var uid = FirebaseAuth.instance.currentUser?.uid;

    print(uid);
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/order/get-friends-order"),
        headers: {"Authorization": "Bearer $uid"},
      );
      print("got response");
      print(response.body);

      final List list = jsonDecode(response.body)['result'];

      return list.map((e) => Request.fromJson(e)).toList();
    } catch (e) {
      print("error $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> getFilteredOrder(String keyword) async {
    try {
      var uid = FirebaseAuth.instance.currentUser?.uid;

      final response = await http.get(
        Uri.parse("$_baseUrl/order/get-order-by-storename/$keyword"),
        headers: {"Authorization": "Bearer $uid"},
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Something went wrong'};
    }
  }

  Future<List<Group>?> getUserGroups() async {
    try {
      var uid = FirebaseAuth.instance.currentUser?.uid;

      final response =
          await http.get(Uri.parse("$_baseUrl/group/get-groups"), headers: {"Authorization": "Bearer $uid"});
      print(response.body);
      final List list = jsonDecode(response.body)['data'];

      return list.map((e) => Group.fromJson(e)).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> addGroup(String groupName) async {
    try {
      var uid = FirebaseAuth.instance.currentUser?.uid;

      final response = await http.post(Uri.parse("$_baseUrl/group/add-groups"), headers: {
        "Authorization": "Bearer $uid"
      }, body: {
        "groupName": groupName,
      });
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Something went wrong'};
    }
  }

  Future<Map<String, dynamic>> joinGroup(groupId) async {
    print(groupId);
    var uid = FirebaseAuth.instance.currentUser?.uid;

    try {
      final response = await http.post(Uri.parse("$_baseUrl/group/join-groups"), headers: {
        "Authorization": "Bearer $uid"
      }, body: {
        "groupId": groupId,
      });
      print(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Something went wrong'};
    }
  }
}
