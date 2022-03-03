import 'package:flutter/material.dart';
import 'package:manga_nih/ui/configs/pallette.dart';

class ClearHistoryDialog extends StatelessWidget {
  final VoidCallback onAccept;

  const ClearHistoryDialog({
    Key? key,
    required this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Clear History'),
      content: Text('Are you sure ?'),
      actions: [
        MaterialButton(
          onPressed: () => Navigator.pop(context),
          color: Pallette.buttonColor,
          minWidth: 100.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Text(
            'No',
            style: TextStyle(color: Colors.white),
          ),
        ),
        MaterialButton(
          onPressed: onAccept,
          minWidth: 70.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Text('Yes'),
        ),
      ],
    );
  }
}
