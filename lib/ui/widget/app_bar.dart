import 'package:flutter/material.dart';

class AppBarCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 25.0,
              color: Colors.grey,
            ),
            onPressed: () => {
              Navigator.pop(context),
            },
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              size: 25.0,
              color: Colors.grey,
            ),
            onPressed: () => {},
          ),
        ],
      ),
    );
  }
}
