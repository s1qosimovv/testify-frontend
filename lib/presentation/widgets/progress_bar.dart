import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const ProgressBar({
    Key? key,
    required this.current,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 0 to 1
    double progress = total > 0 ? (current + 1) / total : 0;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Savol ${current + 1} / $total",
              style: TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
            ),
            Text(
              "${(progress * 100).toInt()}%",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white10,
            color: Colors.purpleAccent,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
