import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(1, 2),
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundImage: AssetImage('images/profile.png'),
        radius: 20.0,
      ),
    );
  }
}
