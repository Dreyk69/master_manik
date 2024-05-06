import 'package:flutter/material.dart';

class MyTextVerefication extends StatelessWidget {
  final String text;
  final bool verefication;

  const MyTextVerefication({
    super.key,
    required this.text,
    required this.verefication,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: verefication ? Colors.green : Colors.black,
      ),
    );
  }
}
