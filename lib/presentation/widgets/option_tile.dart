import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final String label; // A, B, C, D
  final String text; // Option text
  final bool isSelected;
  final VoidCallback onTap;

  const OptionTile({
    Key? key,
    required this.label,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo.withOpacity(0.2) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.indigoAccent : Colors.white10,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Circle Checkbox
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.indigoAccent : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.indigoAccent : Colors.white30,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 16),
            
            // Option Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$label.",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
