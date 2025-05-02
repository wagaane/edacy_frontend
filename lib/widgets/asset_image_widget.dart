import 'package:flutter/material.dart';
class AssetImageWidget extends StatefulWidget {
  final double width;
  final double height;
  final String image;
  const AssetImageWidget({super.key, required this.width, required this.height, required this.image});

  @override
  State<AssetImageWidget> createState() => _AssetImageWidgetState();
}

class _AssetImageWidgetState extends State<AssetImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/${widget.image}", width: widget.width, height: widget.height);
  }
}
