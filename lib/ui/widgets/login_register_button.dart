import 'package:flutter/material.dart';
import 'package:manga_nih/ui/configs/pallette.dart';

class LoginRegisterButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onTap;
  final bool isLoading;

  const LoginRegisterButton({
    Key? key,
    required this.label,
    required this.onTap,
  })  : this.isLoading = false,
        super(key: key);

  const LoginRegisterButton.loading()
      : this.label = null,
        this.onTap = null,
        this.isLoading = true;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap!,
              borderRadius: BorderRadius.circular(50.0),
              child: Ink(
                width: 150.0,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Pallette.buttonColor90,
                ),
                child: Text(
                  label!,
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
  }
}
