import 'package:conu_hacks_2005/models/request.dart';

import '../models/order.dart';
import '../services/api_service.dart';
import 'package:rxdart/rxdart.dart';

class OrderController {
  OrderController._();
  static OrderController? _instance;
  static OrderController get instance => _instance ??= OrderController._();

  ApiService api = ApiService.instance;
  BehaviorSubject<List<Order>?> ordersSubject = BehaviorSubject.seeded(null);
  BehaviorSubject<List<Request>?> requestsSubject = BehaviorSubject.seeded(null);

  Future<void> fetchOrders() async {
    final orders = (await api.getOrders()) ?? [];
    ordersSubject.add(orders);
  }

  Future<void> fetchRequests() async {
    final requests = (await api.getRequests()) ?? [];
    requestsSubject.add(requests);
  }

  Future<void> markRequestComplete(String orderId) async {
    await api.markRequestComplete(orderId: orderId);
    await fetchRequests();
  }

  Future<void> deleteOrder(String orderId) async {
    await api.deleteOrder(orderId: orderId);
    await fetchOrders();
  }

  Future<void> addOrder({
    required String address,
    required String storeName,
    required String list,
    required String createdAt,
    required String groupId,
  }) async {
    await api.addOrder(address: address, groupId: groupId, storeName: storeName, list: list, createdAt: createdAt);
    await fetchOrders();
  }
}
