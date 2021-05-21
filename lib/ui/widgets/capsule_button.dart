import 'package:flutter/material.dart';

class CapsuleButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSelected;

  const CapsuleButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: isSelected ? Color(0xFFFA866A) : Colors.white,
      elevation: isSelected ? 3.0 : 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: isSelected ? Colors.white : Colors.black),
      ),
      onPressed: onPressed,
    );
  }
}
