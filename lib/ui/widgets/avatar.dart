import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Avatar extends StatelessWidget {
  final double radius;
  final bool isNetwork;
  dynamic image;

  Avatar({
    Key? key,
    this.radius = 20.0,
    this.image,
  })  : isNetwork = false,
        super(key: key);

  Avatar.network({
    Key? key,
    this.radius = 20.0,
    this.image,
  })  : isNetwork = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    image ??= 'images/profile.png';

    if (!(image is String || image is File)) {
      throw UnimplementedError();
    }

    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(1, 2),
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: isNetwork
            ? CachedNetworkImageProvider(image)
            : (image is String ? AssetImage(image) : FileImage(image))
                as ImageProvider,
        radius: radius,
      ),
    );
  }
}
