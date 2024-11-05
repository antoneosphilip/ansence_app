import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CustomAnimation extends EasyLoadingAnimation {
  @override
  Widget build(BuildContext context, AnimationController controller) {
    // Define the ColorTween for the teal color transition
    ColorTween colorTween = ColorTween(
      begin: Colors.teal[100]!,  // Light Teal color
      end: Colors.teal[700]!,    // Dark Teal color
    );

    // Returning the animation widget with ScaleTransition and AnimatedBuilder
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut, // Adds smooth scale animation
      ),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: colorTween.evaluate(controller), // Dynamically changing the color
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildWidget(Widget child, AnimationController controller, AlignmentGeometry alignment) {
    return Align(
      alignment: alignment ?? Alignment.center,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut, // Smooth fade-in and fade-out effect
        ),
        child: child,
      ),
    );
  }
}
