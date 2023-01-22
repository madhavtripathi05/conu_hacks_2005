import 'package:conu_hacks_2005/models/request.dart';
import 'package:flutter/material.dart';

import '../controllers/orders_controller.dart';
import '../request_card.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final orderController = OrderController.instance;
  Future<void> init() async {
    await orderController.fetchRequests();
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
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(backgroundImage: AssetImage("assets/images/logo.jpeg")),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Requests',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<Request>?>(
            stream: orderController.requestsSubject,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              final requests = snapshot.data ?? [];
              if (requests.isEmpty) {
                return const Center(
                  child: Text('No requests found'),
                );
              }
              return RefreshIndicator(
                onRefresh: orderController.fetchRequests,
                child: ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, i) {
                      final request = requests[i];

                      return RequestCard(
                          imageUrl:
                              "https://ui-avatars.com/api/?format=png&name=${request.item.storeName}&rounded=true",
                          onTap: () {
                            if (request.item.isComplete) {
                              return;
                            }
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(builder: (context, ss) {
                                    return AlertDialog(
                                      title: const Text("Acknowledge request"),
                                      content: Text(
                                          'Do you confirm purchasing the below listed items on behalf of ${request.userName}:\n${request.item.list} '),
                                      actions: [
                                        MaterialButton(
                                          onPressed: Navigator.of(context).pop,
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        MaterialButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();

                                            await orderController.markRequestComplete(request.item.orderId);
                                          },
                                          child: const Text(
                                            "Confirm",
                                            style: TextStyle(color: Colors.green),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                                });
                          },
                          items: request.item.list,
                          title: request.item.storeName,
                          status: request.item.isComplete ? RequestStatus.complete : RequestStatus.pending);
                    }),
              );
            }),
      ),
    );
  }
}
