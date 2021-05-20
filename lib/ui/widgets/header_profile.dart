import 'package:flutter/material.dart';

class HeaderProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
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
              ]),
          child: CircleAvatar(
            foregroundImage: AssetImage('images/manga.jpeg'),
            minRadius: 20.0,
          ),
        ),
        const SizedBox(width: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good afternoon',
                style: Theme.of(context).textTheme.bodyText2),
            const SizedBox(height: 5.0),
            Text(
              'Zukron Alviandy R',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        const Spacer(),
        MaterialButton(
          child: Icon(Icons.more_horiz),
          padding: const EdgeInsets.all(10.0),
          shape: CircleBorder(
            side: BorderSide(width: 1.0, color: Colors.grey.shade400),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
