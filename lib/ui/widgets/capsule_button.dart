import 'package:flutter/material.dart';

class CapsuleButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CapsuleButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Color(0xFFFA866A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Colors.white),
      ),
      onPressed: onPressed,
    );
  }
}
