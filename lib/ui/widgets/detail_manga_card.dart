import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/core/core.dart';
import 'package:shimmer/shimmer.dart';

class DetailMangaCard extends StatelessWidget {
  final MangaDetail? mangaDetail;
  final bool isLoading;

  const DetailMangaCard({Key? key, required this.mangaDetail})
      : isLoading = false,
        super(key: key);

  const DetailMangaCard.loading({Key? key})
      : mangaDetail = null,
        isLoading = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Stack(
        children: [
          isLoading
              ? Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: screenSize.width * 0.4,
                    height: screenSize.width * 0.55,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                )
              : Stack(
                  children: [
                    Container(
                      width: screenSize.width * 0.4,
                      height: screenSize.width * 0.55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            offset: Offset(1, 1),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          imageUrl: mangaDetail!.thumb,
                          placeholder: (context, url) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            );
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10.0,
                      left: 10.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20.0,
                              child: Image.asset(
                                typeMangaImage(mangaDetail!.typeName),
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              mangaDetail!.typeName,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
