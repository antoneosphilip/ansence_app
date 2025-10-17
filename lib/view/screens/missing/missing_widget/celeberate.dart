import 'package:flutter/material.dart';
import 'dart:math';

// استخدمه كده:
void showCelebrationDialog(BuildContext context, String userName) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => CelebrationDialog(userName: userName),
  );
}

class CelebrationDialog extends StatefulWidget {
  final String userName;

  const CelebrationDialog({Key? key, required this.userName}) : super(key: key);

  @override
  State<CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<CelebrationDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnimation;
  List<ConfettiParticle> confettiList = [];

  @override
  void initState() {
    super.initState();

    // Scale Animation للنص
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Confetti Animation
    _confettiController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Generate confetti particles
    confettiList = List.generate(
      50,
          (index) => ConfettiParticle(
        x: Random().nextDouble(),
        y: -0.1,
        color: _randomColor(),
        size: Random().nextDouble() * 8 + 4,
        velocity: Random().nextDouble() * 2 + 1,
        drift: Random().nextDouble() * 2 - 1,
      ),
    );

    _scaleController.forward();
    _confettiController.forward();

    // Auto close بعد 3 ثواني
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  Color _randomColor() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
    ];
    return colors[Random().nextInt(colors.length)];
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black45,
      child: Stack(
        children: [
          // Confetti Layer
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, child) {
              return CustomPaint(
                painter: ConfettiPainter(
                  confettiList: confettiList,
                  progress: _confettiController.value,
                ),
                size: Size.infinite,
              );
            },
          ),

          // Content
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6B46C1), Color(0xFFEC4899)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Star Icon
                    TweenAnimationBuilder(
                      duration: const Duration(seconds: 2),
                      tween: Tween<double>(begin: 0, end: 2 * pi),
                      builder: (context, double value, child) {
                        return Transform.rotate(
                          angle: value,
                          child: const Text(
                            '⭐',
                            style: TextStyle(fontSize: 60),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Success Icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Message
                    const Text(
                      'شكراً لافتقادك يا',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Emoji
                    const Text(
                      '🎉 🎊 🎈',
                      style: TextStyle(fontSize: 32),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Confetti Particle Model
class ConfettiParticle {
  double x;
  double y;
  final Color color;
  final double size;
  final double velocity;
  final double drift;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.velocity,
    required this.drift,
  });
}

// Confetti Painter
class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> confettiList;
  final double progress;

  ConfettiPainter({required this.confettiList, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in confettiList) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      final dy = particle.y + (progress * particle.velocity);
      final dx = particle.x + (sin(progress * 2 * pi) * particle.drift * 0.1);

      canvas.drawCircle(
        Offset(dx * size.width, dy * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// مثال الاستخدام في الكود بتاعك:
/*
if (state is CompleteAllStudentMissingSuccessState) {
  showCelebrationDialog(
    context,
    CacheHelper.getDataString(key: 'name') ?? 'الطالب',
  );
}
*/