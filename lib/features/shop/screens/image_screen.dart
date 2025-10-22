import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CachedNetworkImage(
        imageUrl: "https://i.redd.it/4jjdwz3mz4od1.png",
        progressIndicatorBuilder: (context, url, progress) =>
            const CircularProgressIndicator(),
        errorWidget: (context, url, progress) =>
            const Center(child: Icon(Icons.error, color: Colors.red)),
      ),
    );
  }
}
