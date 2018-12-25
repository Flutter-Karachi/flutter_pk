import 'package:flutter/material.dart';

class CapsuleText extends StatelessWidget {
  final Color color;
  final String title;
  final Color textColor;

  CapsuleText({this.color, this.title, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      shape: StadiumBorder(),
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 2.0,
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.caption.copyWith(
            color: textColor,
            fontSize: 14.0
          ),
        ),
      ),
    );
  }
}