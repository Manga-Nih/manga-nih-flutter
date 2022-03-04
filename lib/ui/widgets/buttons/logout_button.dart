import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.all(20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
        side: const BorderSide(
          color: Colors.red,
        ),
      ),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(Icons.logout, color: Colors.red),
          const SizedBox(width: 25.0),
          Text(
            'Logout',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 17.0,
                  color: Colors.red,
                  letterSpacing: 1.3,
                ),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
