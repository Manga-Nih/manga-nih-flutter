import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:manga_nih/ui/configs/pallette.dart';

class PrimaryButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onTap;
  final bool isLoading;
  final double maxWidth;

  const PrimaryButton({
    Key? key,
    required this.label,
    required this.onTap,
    this.maxWidth = 150,
  })  : isLoading = false,
        super(key: key);

  const PrimaryButton.loading()
      : label = null,
        onTap = null,
        maxWidth = 150,
        isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 150,
        maxWidth: maxWidth,
        minHeight: 50,
        maxHeight: 50,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          colors: [
            Pallette.gradientStartColor,
            Pallette.gradientEndColor,
          ],
        ),
      ),
      child: MaterialButton(
        onPressed: isLoading ? null : onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.0,
        ),
        child: isLoading
            ? LoadingIndicator(
                indicatorType: Indicator.ballPulse,
                colors: [Colors.white],
              )
            : Text(
                label!,
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
