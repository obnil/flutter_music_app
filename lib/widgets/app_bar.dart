import 'package:flutter/material.dart';

class AppBarCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 25.0,
            color: Colors.black54,
            onPressed: () => {
              Navigator.pop(context),
            },
          ),
          IconButton(
                icon: Icon(Icons.share),
                iconSize: 25.0,
                color: Colors.black54,
                onPressed: () => {},
              ),
        ],
      ),
    );
  }
}
