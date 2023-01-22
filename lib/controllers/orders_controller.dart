import '../models/order.dart';
import '../services/api_service.dart';
import 'package:rxdart/rxdart.dart';

class OrderController {
  OrderController._();
  static OrderController? _instance;
  static OrderController get instance => _instance ??= OrderController._();

  ApiService api = ApiService.instance;
  BehaviorSubject<List<Order>?> ordersSubject = BehaviorSubject.seeded(null);

  Future<void> fetchOrders() async {
    final orders = (await api.getOrders()) ?? [];
    ordersSubject.add(orders);
  }

  Future<void> addOrder({
    required String address,
    required String storeName,
    required String list,
    required String createdAt,
  }) async {
    await api.addOrder(address: address, storeName: storeName, list: list, createdAt: createdAt);
    await fetchOrders();
  }
}
