import 'dart:convert';

import 'package:conu_hacks_2005/models/order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../models/group.dart';

class ApiService {
  ApiService._();
  static ApiService? _instance;
  static ApiService get instance => _instance ??= ApiService._();
  final _baseUrl = "https://wild-boats-hope-132-205-228-49.loca.lt";

  final uid = FirebaseAuth.instance.currentUser?.uid;

  Future<Map<String, dynamic>> sendUserDetails(User? user) async {
    try {
      final response = await http.post(Uri.parse("$_baseUrl/user/user-details"), body: {
        "userId": user?.uid,
        "userName": user?.displayName,
        "userEmail": user?.email,
        "userImage": user?.photoURL,
      });
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Something went wrong'};
    }
  }

  Future<Map<String, dynamic>> addOrder(
      {required String address, required String storeName, required String list, required String createdAt}) async {
    try {
      final response = await http.post(Uri.parse("$_baseUrl/order/add-order"),
          headers: {"Authorization": "Bearer $uid"},
          body: {"storeName": storeName, "address": address, "list": list, "createdAt": createdAt});
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Something went wrong'};
    }
  }

  Future<List<Order>?> getOrders() async {
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

  Future<Map<String, dynamic>> getFilteredOrder(String keyword) async {
    try {
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
    try {
      final response = await http.post(Uri.parse("$_baseUrl/group/join-groups"), headers: {
        "Authorization": "Bearer $uid"
      }, body: {
        "groupId": groupId,
      });
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Something went wrong'};
    }
  }
}
