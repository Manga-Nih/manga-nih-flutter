import 'package:flutter/material.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/ui/configs/pallette.dart';
import 'package:shimmer/shimmer.dart';

class GenreButton extends StatelessWidget {
  final Genre? genre;
  final Function(Genre)? onPressed;
  final bool isLoading;

  const GenreButton({
    Key? key,
    required this.genre,
    required this.onPressed,
  })  : this.isLoading = false,
        super(key: key);

  const GenreButton.loading()
      : this.genre = null,
        this.onPressed = null,
        this.isLoading = true;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(color: Colors.grey.shade300),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              gradient: LinearGradient(
                colors: [
                  Pallette.gradientStartColor,
                  Pallette.gradientEndColor
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.2, 0.8],
              ),
            ),
            child: MaterialButton(
              onPressed: () => onPressed!(genre!),
              child: Text(
                genre!.name,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
  }
}
