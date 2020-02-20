import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/ui/page/search_screen.dart';

class RotateRecord extends AnimatedWidget {
  final inputController;
  RotateRecord({Key key, this.inputController, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SearchScreen(
              input: inputController.text,
            ),
          ),
        ),
      },
      child: new Container(
        height: 40.0,
        width: 40.0,
        child: new RotationTransition(
            turns: animation,
            child: new Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                      "https://images-na.ssl-images-amazon.com/images/I/51inO4DBH0L._SS500.jpg"),
                ),
              ),
            )),
      ),
    );
  }
}
