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
            icon: Theme.of(context).brightness == Brightness.dark
                ? Icon(
                    Icons.arrow_back_ios,
                    size: 25.0,
                  )
                : Icon(
                    Icons.arrow_back_ios,
                    size: 25.0,
                    color: Color(0xFF787878),
                  ),
            iconSize: 25.0,
            onPressed: () => {
              Navigator.pop(context),
            },
          ),
          IconButton(
            icon: Theme.of(context).brightness == Brightness.dark
                ? Icon(
                    //Icons.skip_previous,
                    Icons.share,
                    size: 25.0,
                  )
                : Icon(
                    //Icons.skip_previous,
                    Icons.share,
                    size: 25.0,
                    color: Color(0xFF787878),
                  ),
            iconSize: 25.0,
            onPressed: () => {},
          ),
        ],
      ),
    );
  }
}
