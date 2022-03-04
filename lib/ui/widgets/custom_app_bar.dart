import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String label;

  const CustomAppBar({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Colors.grey.shade600),
      ),
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.grey.shade600),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
}
