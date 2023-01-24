import 'package:conu_hacks_2005/controllers/orders_controller.dart';
import 'package:conu_hacks_2005/order_card.dart';
import 'package:flutter/material.dart';

import '../models/order.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final orderController = OrderController.instance;
  Future<void> init() async {
    await orderController.fetchOrders();
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(backgroundImage: AssetImage("assets/images/logo.jpeg")),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'My Cart',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<Order>?>(
            stream: orderController.ordersSubject,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              final orders = snapshot.data ?? [];
              if (orders.isEmpty) {
                return const Center(
                  child: Text('No orders found'),
                );
              }
              return RefreshIndicator(
                onRefresh: orderController.fetchOrders,
                child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, i) {
                      final order = orders[i];

                      return OrderCard(
                          imageUrl: "https://ui-avatars.com/api/?format=png&name=${order.storeName}&rounded=true",
                          items: order.list,
                          onDelete: () async{
                           await orderController.deleteOrder(order.orderId);
                          },
                          boughtBy: order.boughtBy,
                          title: order.storeName,
                          status: order.isComplete ? RequestStatus.complete : RequestStatus.pending);
                    }),
              );
            }),
      ),
    );
  }
}
