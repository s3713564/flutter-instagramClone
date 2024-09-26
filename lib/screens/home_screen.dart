import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        title: SizedBox(
          width: 100,
          child: Image.asset('assets/images/instagram.png'),
        ),
        //leading: Image.asset('assets/images/camera.jpg'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
                color: Colors.white.withOpacity(0.7), Icons.favorite_border),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Icon(
                color: Colors.white.withOpacity(0.7),
                Icons.chat_bubble_outline),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return PostWidget();
              },
              childCount: 5,
            ),
          ),
        ],
      ),
    );
  }
}
