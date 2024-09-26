import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          color: Colors.black,
          child: const Center(
            child: ListTile(
              leading: ClipOval(
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(
                'username',
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
              subtitle: Text(
                'location',
                style: TextStyle(fontSize: 11),
              ),
              trailing: Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 375,
          child: Image.asset(
            'assets/images/post.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          color: Colors.black,
          child: const Column(
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 10),
                  Icon(
                    Icons.favorite_outline,
                    size: 30,
                    color: Colors.white,
                  ),
                  SizedBox(width: 3),
                  Text(
                    '0',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 15),
                  Icon(
                    Icons.insert_comment_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                  SizedBox(width: 3),
                  Text(
                    '0',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 15),
                  Icon(
                    Icons.send_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                  SizedBox(width: 3),
                  Text(
                    '0',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.bookmark_outline,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Text(
                      'usernam ' + '',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'caption',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      'datefomat',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
