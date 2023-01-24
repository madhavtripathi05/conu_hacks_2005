import 'package:flutter/material.dart';

enum RequestStatus { pending, complete }

class RequestCard extends StatelessWidget {
  const RequestCard(
      {super.key,
      required this.imageUrl,
      required this.items,
      required this.title,
      required this.status,
      required this.onTap});
  final String imageUrl;
  final String title;
  final String items;
  final RequestStatus status;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: ClipRRect(borderRadius: BorderRadius.circular(4), child: Image.network(imageUrl)),
          title: Text(title),
          subtitle: Text(
            items,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(shape: BoxShape.circle, color: getColorFromStatus(status)),
                margin: const EdgeInsets.only(right: 4),
              ),
              Text(status.name)
            ],
          ),
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
