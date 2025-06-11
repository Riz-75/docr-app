import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final void Function()? onTap;
  final IconData? icon;
  final String text;
  final double sWidth;

  const HomeCard({
    super.key,
    this.onTap,
    this.icon,
    required this.text,
    required this.sWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 10.0,
        color: const Color(0xBB412795),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xCCE0DAFC),
                Color(0xCCC0D8FA),
              ], // Adjust colors
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: icon == null
                ? [
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF412795),
                        fontSize: sWidth * 0.05,
                      ),
                    ),
                  ]
                : [
                    Icon(
                      icon,
                      color: const Color(0xFF412795),
                      size: sWidth * 0.2,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF412795),
                        fontSize: sWidth * 0.05,
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
