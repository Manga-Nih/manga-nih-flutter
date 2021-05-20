import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_nih/models/models.dart';
import 'package:shimmer/shimmer.dart';

class MangaItem extends StatelessWidget {
  final PopularManga? popularManga;
  final bool isLoading;

  const MangaItem({
    Key? key,
    this.popularManga,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: isLoading
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: 150.0,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey.shade300,
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          Container(
                            width: 150.0,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(0, 1),
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CachedNetworkImage(
                                imageUrl: popularManga!.thumb,
                                placeholder: (context, url) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child:
                                        Container(color: Colors.grey.shade300),
                                  );
                                },
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5.0,
                            left: 5.0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 15.0,
                                    child: Image.asset(
                                      popularManga!.typeImage,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    popularManga!.type,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 10.0),
              isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 150.0,
                        height: 15.0,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 150.0,
                      child: Text(
                        popularManga!.title,
                        style: Theme.of(context).textTheme.bodyText1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
              const SizedBox(height: 5.0),
              isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 150.0,
                        height: 15.0,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Icon(
                          Icons.timer,
                          size: 15.0,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 5.0),
                        SizedBox(
                          width: 100.0,
                          child: Text(
                            popularManga!.uploadOn,
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
