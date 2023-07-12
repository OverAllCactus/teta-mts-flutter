import 'package:flutter/material.dart';
import 'package:string_to_hex/string_to_hex.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/message/message.dart';

class ShimmerView extends StatelessWidget {
  const ShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 240,
            height: 16,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5)),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            width: 240,
            height: 16,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5)),
          ),
        ],
      ),
    );
  }
}
