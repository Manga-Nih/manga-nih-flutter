import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:komiku_sdk/models.dart';
import 'package:manga_nih/core/core.dart';
import 'package:manga_nih/models/models.dart';
import 'package:shimmer/shimmer.dart';

class MangaCard<T> extends StatelessWidget {
  final T? manga;
  final void Function(T)? onTap;
  final bool isLoading;

  const MangaCard({
    Key? key,
    required this.manga,
    required this.onTap,
  })  : isLoading = false,
        super(key: key);

  const MangaCard.loading({Key? key})
      : manga = null,
        onTap = null,
        isLoading = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    String? thumb, type, typeImage, title;
    String? chapter;
    String? uploadOn;

    if (manga is Manga) {
      thumb = (manga as Manga).thumb;
      type = (manga as Manga).typeName;
      typeImage = typeMangaImage(type);
      title = (manga as Manga).title;
      uploadOn = (manga as Manga).release;
      chapter = (manga as Manga).lastChapter;
    }

    if (manga is FavoriteManga) {
      thumb = (manga as FavoriteManga).thumb;
      type = (manga as FavoriteManga).type;
      typeImage = (manga as FavoriteManga).typeImage;
      title = (manga as FavoriteManga).title;
    }

    if (manga is HistoryManga) {
      thumb = (manga as HistoryManga).thumb;
      type = (manga as HistoryManga).type;
      typeImage = (manga as HistoryManga).typeImage;
      title = (manga as HistoryManga).title;
      chapter = (manga as HistoryManga).lastChapter.title;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Column(
              children: [
                isLoading
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 200.0,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          Container(
                            height: 200.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5.0,
                                  offset: Offset(1, 1),
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: CachedNetworkImage(
                                imageUrl: thumb!,
                                placeholder: (context, url) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
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
                                      typeImage!,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    type!,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          chapter == null
                              ? const SizedBox.shrink()
                              : Positioned(
                                  top: 10.0,
                                  left: 10.0,
                                  right: 10.0,
                                  child: Wrap(
                                    alignment: WrapAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                        child: Text(
                                          chapter,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                const SizedBox(height: 5.0),
                isLoading
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 25.0,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: screenSize.width * 0.5,
                            child: Text(
                              title!,
                              style: Theme.of(context).textTheme.bodyText1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          uploadOn == null
                              ? const SizedBox.shrink()
                              : Row(
                                  children: [
                                    const Icon(Icons.timer_sharp, size: 20.0),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      uploadOn,
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                        ],
                      ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                onTap: () => onTap!(manga!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
