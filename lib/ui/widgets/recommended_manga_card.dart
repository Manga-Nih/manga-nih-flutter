import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:komiku_sdk/models.dart';
import 'package:shimmer/shimmer.dart';

class RecommendedMangaCard extends StatelessWidget {
  final Manga? recommendedManga;
  final void Function(Manga)? onTap;
  final bool isLoading;

  const RecommendedMangaCard({
    Key? key,
    required this.onTap,
    required this.recommendedManga,
  })  : isLoading = false,
        super(key: key);

  const RecommendedMangaCard.loading({Key? key})
      : recommendedManga = null,
        onTap = null,
        isLoading = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey.shade300,
              ),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                      spreadRadius: 1.0,
                      offset: Offset(1, 2),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    imageUrl: recommendedManga!.thumb,
                    placeholder: (context, url) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(color: Colors.grey.shade300),
                      );
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.grey.shade700],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10.0,
                left: 10.0,
                child: SizedBox(
                  width: 250.0,
                  child: Text(
                    recommendedManga!.title,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () => onTap!(recommendedManga!),
                  ),
                ),
              ),
            ],
          );
  }
}
