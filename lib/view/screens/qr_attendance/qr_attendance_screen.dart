import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';
import 'package:summer_school_app/view/core_widget/flutter_toast/flutter_toast.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_cubit.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_states.dart';

class QrAttendanceScreen extends StatefulWidget {
  const QrAttendanceScreen({super.key});

  @override
  State<QrAttendanceScreen> createState() => _QrAttendanceScreenState();
}

class _QrAttendanceScreenState extends State<QrAttendanceScreen>
    with SingleTickerProviderStateMixin {
  late MobileScannerController _scannerController;
  late AnimationController _animController;
  late Animation<double> _scanLineAnimation;

  bool _isProcessing = false;
  bool _isTorchOn = false;
  CameraFacing _cameraFacing = CameraFacing.back;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _scanLineAnimation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  String _extractStudentId(String rawValue) {
    rawValue = rawValue.trim();
    // 1. If it is a full URL like http://madrasa.runasp.net/absences/add-student-attendance/1
    if (rawValue.contains('/')) {
      final segments = rawValue.split('/').where((s) => s.isNotEmpty).toList();
      if (segments.isNotEmpty) {
        return segments.last;
      }
    }
    return rawValue;
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? rawValue = barcodes.first.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    HapticFeedback.mediumImpact();

    final String studentId = _extractStudentId(rawValue);

    if (mounted) {
      final cubit = AbsenceCubit.get(context);
      final bool success =
          await cubit.addStudentAttendanceByQr(studentId: studentId);

      if (mounted) {
        _showAttendanceResultDialog(studentId: studentId, isSuccess: success);
      }
    }
  }

  void _showAttendanceResultDialog({
    required String studentId,
    required bool isSuccess,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: ColorManager.colorWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: ColorManager.colorGrey4,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),

              // Status Icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: isSuccess
                      ? ColorManager.colorGreenLight
                      : ColorManager.colorRedLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSuccess
                        ? ColorManager.colorGreen
                        : ColorManager.colorRed,
                    width: 2.5,
                  ),
                ),
                child: Icon(
                  isSuccess
                      ? Icons.check_circle_rounded
                      : Icons.error_outline_rounded,
                  color: isSuccess
                      ? ColorManager.colorGreen
                      : ColorManager.colorRed,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                isSuccess
                    ? 'تم تسجيل الحضور بنجاح'
                    : 'تعذر تسجيل الحضور',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isSuccess
                      ? ColorManager.colorDarkBlue
                      : ColorManager.colorRed,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Text(
                isSuccess
                    ? 'تم تأكيد حضور الطالب رقم ($studentId)'
                    : 'حدث خطأ أثناء الاتصال بالخادم للطالب رقم ($studentId)',
                style: const TextStyle(
                  fontSize: 14,
                  color: ColorManager.colorXXGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        side: const BorderSide(
                          color: ColorManager.colorGrey4,
                        ),
                      ),
                      child: const Text(
                        'إغلاق',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.colorXXGrey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: GradiantLinearColor.primaryGradiant,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: ColorManager.glowShadow(
                            ColorManager.colorPrimary),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _isProcessing = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_scanner_rounded,
                                color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'مسح طالب آخر',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showManualEntryDialog() {
    final TextEditingController idController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(Icons.edit_note_rounded,
                  color: ColorManager.colorPrimary, size: 24),
              SizedBox(width: 8),
              Text(
                'إدخال كود الطالب يدوياً',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.colorDarkBlue,
                ),
              ),
            ],
          ),
          content: TextField(
            controller: idController,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'اكتب كود أو رقم الطالب...',
              prefixIcon: const Icon(Icons.badge_rounded,
                  color: ColorManager.colorPrimary),
              filled: true,
              fillColor: ColorManager.colorScaffold,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء',
                  style: TextStyle(color: ColorManager.colorXXGrey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final id = idController.text.trim();
                if (id.isEmpty) {
                  showFlutterToast(
                    message: "يرجى كتابة رقم الطالب",
                    state: ToastState.WARNING,
                  );
                  return;
                }
                Navigator.pop(context);
                setState(() {
                  _isProcessing = true;
                });
                final cubit = AbsenceCubit.get(context);
                final bool success =
                    await cubit.addStudentAttendanceByQr(studentId: id);
                if (mounted) {
                  _showAttendanceResultDialog(studentId: id, isSuccess: success);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.colorPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('تسجيل الحضور',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double scanBoxSize = MediaQuery.of(context).size.width * 0.72;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera Scanner
          MobileScanner(
            controller: _scannerController,
            onDetect: _handleBarcode,
          ),

          // 2. Dark Frosted Mask & Cutout
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _ScannerOverlayPainter(
              cutoutSize: scanBoxSize,
              borderColor: ColorManager.colorPrimary,
            ),
          ),

          // 3. Animated Laser Scan Line
          Center(
            child: SizedBox(
              width: scanBoxSize - 20,
              height: scanBoxSize - 20,
              child: AnimatedBuilder(
                animation: _scanLineAnimation,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment(0, (_scanLineAnimation.value * 2) - 1),
                    child: Container(
                      height: 3,
                      width: scanBoxSize - 30,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorManager.colorPrimary.withOpacity(0.1),
                            ColorManager.colorPrimary,
                            ColorManager.colorPrimary.withOpacity(0.1),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ColorManager.colorPrimary.withOpacity(0.8),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 4. Top Controls Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),

                  // Title Pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.qr_code_scanner_rounded,
                            color: ColorManager.colorPrimary, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'تسجيل غياب بالـ QR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Actions: Torch & Flip Camera
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: _isTorchOn
                              ? ColorManager.colorPrimary
                              : Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            _scannerController.toggleTorch();
                            setState(() {
                              _isTorchOn = !_isTorchOn;
                            });
                          },
                          icon: Icon(
                            _isTorchOn
                                ? Icons.flash_on_rounded
                                : Icons.flash_off_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            _scannerController.switchCamera();
                            setState(() {
                              _cameraFacing =
                                  _cameraFacing == CameraFacing.back
                                      ? CameraFacing.front
                                      : CameraFacing.back;
                            });
                          },
                          icon: const Icon(
                            Icons.cameraswitch_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 5. Bottom Instructions & Manual Entry Button
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info_outline_rounded,
                              color: Colors.white70, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'وجّه الكاميرا نحو كود الطالب للتحضير الفوري',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Manual Entry Button
                    InkWell(
                      onTap: _showManualEntryDialog,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.2,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.keyboard_rounded,
                                color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'إدخال كود الطالب يدوياً',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 6. Loading Overlay
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.55),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(ColorManager.colorPrimary),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'جاري تسجيل الحضور...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final double cutoutSize;
  final Color borderColor;

  _ScannerOverlayPainter({
    required this.cutoutSize,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.65)
      ..style = PaintingStyle.fill;

    final cutoutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: cutoutSize,
      height: cutoutSize,
    );

    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutoutPath = Path()
      ..addRRect(
          RRect.fromRectAndRadius(cutoutRect, const Radius.circular(24)));

    final combinedPath =
        Path.combine(PathOperation.difference, backgroundPath, cutoutPath);

    canvas.drawPath(combinedPath, backgroundPaint);

    // Draw 4 corner accents
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final double cornerLen = 28;
    final double radius = 24;

    // Top-Left
    final pathTL = Path()
      ..moveTo(cutoutRect.left, cutoutRect.top + cornerLen)
      ..lineTo(cutoutRect.left, cutoutRect.top + radius)
      ..quadraticBezierTo(cutoutRect.left, cutoutRect.top,
          cutoutRect.left + radius, cutoutRect.top)
      ..lineTo(cutoutRect.left + cornerLen, cutoutRect.top);
    canvas.drawPath(pathTL, borderPaint);

    // Top-Right
    final pathTR = Path()
      ..moveTo(cutoutRect.right - cornerLen, cutoutRect.top)
      ..lineTo(cutoutRect.right - radius, cutoutRect.top)
      ..quadraticBezierTo(cutoutRect.right, cutoutRect.top,
          cutoutRect.right, cutoutRect.top + radius)
      ..lineTo(cutoutRect.right, cutoutRect.top + cornerLen);
    canvas.drawPath(pathTR, borderPaint);

    // Bottom-Left
    final pathBL = Path()
      ..moveTo(cutoutRect.left, cutoutRect.bottom - cornerLen)
      ..lineTo(cutoutRect.left, cutoutRect.bottom - radius)
      ..quadraticBezierTo(cutoutRect.left, cutoutRect.bottom,
          cutoutRect.left + radius, cutoutRect.bottom)
      ..lineTo(cutoutRect.left + cornerLen, cutoutRect.bottom);
    canvas.drawPath(pathBL, borderPaint);

    // Bottom-Right
    final pathBR = Path()
      ..moveTo(cutoutRect.right - cornerLen, cutoutRect.bottom)
      ..lineTo(cutoutRect.right - radius, cutoutRect.bottom)
      ..quadraticBezierTo(cutoutRect.right, cutoutRect.bottom,
          cutoutRect.right, cutoutRect.bottom - radius)
      ..lineTo(cutoutRect.right, cutoutRect.bottom - cornerLen);
    canvas.drawPath(pathBR, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
