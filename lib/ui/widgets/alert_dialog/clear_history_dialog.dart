import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      title: const Text('Clear History'),
      content: const Text('Are you sure ?'),
      actions: [
        MaterialButton(
          onPressed: () => Get.back(),
          color: Pallette.buttonColor,
          minWidth: 100.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: const Text(
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
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
