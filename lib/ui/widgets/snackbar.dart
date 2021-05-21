import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String label, {bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: isError ? Colors.red : Colors.black,
      content: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}
