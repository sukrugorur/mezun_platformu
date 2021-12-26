import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  String imgPath;
  String token;
  String userId;
  DisplayImage(this.token, this.userId, this.imgPath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF78A2CC),
      ),
      body: Hero(
        tag: imgPath,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(imgPath), fit: BoxFit.contain),
            color: Color(0xFF78A2CC).withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}
