import 'package:flutter/material.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/ui/configs/pallette.dart';
import 'package:manga_nih/ui/screens/screens.dart';

class LogoutDialog extends StatelessWidget {
  final Function onLogout;

  const LogoutDialog({
    Key? key,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text(
        'Log out',
        style:
            Theme.of(context).textTheme.headline6!.copyWith(color: Colors.red),
      ),
      content: Text('Are you sure want to log out ?'),
      actions: [
        MaterialButton(
          onPressed: () => Navigator.pop(context),
          color: Pallette.buttonColor,
          minWidth: 100.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Text(
            'I will stay',
            style: TextStyle(color: Colors.white),
          ),
        ),
        MaterialButton(
          onPressed: () async {
            SnackbarModel.custom(false, 'Bye bye...');

            await onLogout();

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SplashScreen()),
                (route) => false);
          },
          minWidth: 70.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Text(
            'Yes...',
            style:
                Theme.of(context).textTheme.button!.copyWith(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
