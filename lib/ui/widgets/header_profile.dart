import 'package:flutter/material.dart';
import 'package:manga_nih/helpers/helpers.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class HeaderProfile extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const HeaderProfile({
    Key? key,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  const HeaderProfile.defaultValue({required this.onTap}) : this.name = '';

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
              Text(greetingNow(), style: Theme.of(context).textTheme.bodyText2),
              const SizedBox(height: 5.0),
              Text(
                name,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 1.0, color: Colors.grey.shade400),
            ),
            child: Icon(Icons.more_horiz),
          ),
        ],
      ),
    );
  }
}
