import 'package:flutter/cupertino.dart';

class DefaultImage extends StatelessWidget {
  const DefaultImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Image(image: AssetImage('assets/images/default_image.jpg'));
  }
}
