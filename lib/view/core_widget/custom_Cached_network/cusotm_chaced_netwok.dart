import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';

class CustomCachedImage extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String? localImage; // Local image as a file path
  final String defaultAsset;
  final bool isReact;

  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.size = 50.0,
    this.localImage,
    this.defaultAsset = "assets/images/default_image.jpg",  this.isReact=true,
  });

  @override
  Widget build(BuildContext context) {
   if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        imageBuilder: (context, imageProvider) => _buildImage(Image(image: imageProvider)),
        placeholder: (context, url) => _buildLoading(),
        errorWidget: (context, url, error) => _buildImage(Image.asset(defaultAsset)),
      );
    } else {
      return _buildImage(Image.asset(defaultAsset));
    }
  }

  Widget _buildImage(Image image) {
    return  isReact? ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image(
        image: image.image,
        width: size,
        height: size,
        fit: BoxFit.cover,
      )
    ):Image(
      image: image.image,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }

  Widget _buildLoading() {
    return SizedBox(
      width: size,
      height: size,
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2,color: ColorManager.colorPrimary,),
      ),
    );
  }
}
