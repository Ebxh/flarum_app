import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';

class ImagesVIew extends StatelessWidget {
  final List<String> images;
  final int index;

  ImagesVIew(this.images, this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PageView.builder(
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureZoomBox(
                maxScale: 5.0,
                doubleTapScale: 2.0,
                duration: Duration(milliseconds: 200),
                onPressed: () => Navigator.pop(context),
                child: Material(
                  color: Colors.transparent,
                  child: Hero(
                      tag: images[index],
                      child: CachedNetworkImage(
                        imageUrl: images[index],
                        placeholder: (BuildContext context, String url) {
                          return Icon(
                            Icons.image,
                            size: 64,
                            color: Colors.grey,
                          );
                        },
                        errorWidget:
                            (BuildContext context, String url, dynamic error) {
                          return Icon(
                            Icons.warning,
                            size: 64,
                            color: Colors.grey,
                          );
                        },
                      )),
                ));
          }),
    );
  }
}
