import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Requests',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return RequestCard(
                  imageUrl: "https://ui-avatars.com/api/?format=png&name=a&rounded=true",
                  items: "Egg",
                  title: "Walmart",
                  status: index == 5 ? RequestStatus.complete : RequestStatus.pending);
            }),
      ),
    );
  }
}
