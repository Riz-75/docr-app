import 'package:flutter/material.dart';

class BBButton extends StatelessWidget {
  final void Function()? onTap;
  final IconData icon;
  final String text;

  const BBButton({
    super.key,
    this.onTap,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF412795),
          ),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF412795)),
          )
        ],
      ),
    );
  }
}
