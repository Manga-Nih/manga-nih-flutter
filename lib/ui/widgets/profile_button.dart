import 'package:flutter/material.dart';
import 'package:manga_nih/ui/configs/pallette.dart';

class ProfileButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const ProfileButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.all(20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      color: Pallette.buttonColor,
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 25.0),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 17.0,
                  color: Colors.white,
                  letterSpacing: 1.3,
                ),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
