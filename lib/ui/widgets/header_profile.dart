import 'package:flutter/material.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class HeaderProfile extends StatelessWidget {
  final VoidCallback onTap;

  const HeaderProfile({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Avatar(),
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
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
