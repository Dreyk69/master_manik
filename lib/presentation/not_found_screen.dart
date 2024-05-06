import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});
  static const routeName = '/not_found_screen';

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Text('Ты зачем через стены ходишь? Опять все сломал....'),
          Text(
            '(ошибка навигации)',
            selectionColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
