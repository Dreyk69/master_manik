import 'package:flutter/material.dart';

import '../ribbonScreen/ribbon_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            title: Text('Ananasik Nails'),
            backgroundColor: Color.fromARGB(255, 254, 199, 236),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: SearchButton(),
            ),
          ),
        ],
      ),
    );
  }
}
