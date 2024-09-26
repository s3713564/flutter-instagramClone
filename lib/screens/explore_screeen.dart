import 'package:flutter/material.dart';

class ExploreScreeen extends StatefulWidget {
  const ExploreScreeen({super.key});

  @override
  State<ExploreScreeen> createState() {
    return _ExploreScreenState();
  }
}

class _ExploreScreenState extends State<ExploreScreeen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Explore Screen'),
      ),
    );
  }
}