import 'package:flutter/material.dart';

enum RequestStatus { pending, complete }

class OrderCard extends StatefulWidget {
  const OrderCard(
      {super.key,
      required this.imageUrl,
      required this.items,
      required this.title,
      required this.status,
      required this.boughtBy,
      required this.onDelete});
  final String imageUrl;
  final String title;
  final String items;
  final String? boughtBy;
  final RequestStatus status;
  final Function() onDelete;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool showLoader = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        // leading: ClipRRect(borderRadius: BorderRadius.circular(4), child: Image.network(imageUrl)),
        leading: showLoader
            ? const SizedBox(
                height: 50,
                width: 50,
                child: Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator())))
            : IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () async {
                  showLoader = true;
                  setState(() {});
                  await widget.onDelete();
                  showLoader = false;
                  setState(() {});
                }),
        title: Text(widget.title),
        subtitle: Text(
          widget.items,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: getColorFromStatus(widget.status)),
                  margin: const EdgeInsets.only(right: 4),
                ),
                Text(widget.status == RequestStatus.complete ? "Completed by" : "Pending")
              ],
            ),
            Text(widget.boughtBy ?? '')
          ],
        ),
      ),
    );
  }
}

Color getColorFromStatus(RequestStatus status) {
  switch (status) {
    case RequestStatus.pending:
      return Colors.yellow.shade800;

    case RequestStatus.complete:
      return Colors.green;
  }
}
