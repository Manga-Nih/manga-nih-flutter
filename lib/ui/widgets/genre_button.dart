import 'package:flutter/material.dart';
import 'package:manga_nih/models/models.dart';
import 'package:shimmer/shimmer.dart';

class GenreButton extends StatelessWidget {
  final Genre? genre;
  final bool isLoading;

  const GenreButton({
    Key? key,
    this.genre,
    this.isLoading = false,
  }) : super(key: key);

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
                colors: [Color(0xFFFA866A), Color(0xFFF76978)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.2, 0.8],
              ),
            ),
            child: MaterialButton(
              onPressed: () {},
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
