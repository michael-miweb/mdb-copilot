import 'package:flutter/material.dart';

enum StatusBannerType { success, error, warning, info }

class StatusBanner extends StatelessWidget {
  const StatusBanner({
    required this.type,
    required this.message,
    super.key,
  });

  final StatusBannerType type;
  final String message;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final (icon, baseColor) = switch (type) {
      StatusBannerType.success => (Icons.check_circle, Colors.green),
      StatusBannerType.error => (Icons.error_outline, Colors.red),
      StatusBannerType.warning =>
        (Icons.warning_amber_rounded, Colors.orange),
      StatusBannerType.info => (Icons.info_outline, Colors.blue),
    };

    const radius = BorderRadius.all(Radius.circular(8));

    return CustomPaint(
      painter: _GradientBorderPainter(
        gradient: LinearGradient(
          colors: [
            primary.withValues(alpha: .5),
            baseColor.withValues(alpha: .5),
          ],
        ),
        borderRadius: radius,
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              baseColor.withValues(alpha: .35),
              primary.withValues(alpha: .25),
            ],
          ),
          borderRadius: radius,
        ),
        child: Row(
          children: [
            Icon(icon, color: baseColor.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: baseColor.shade700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  _GradientBorderPainter({
    required this.gradient,
    required this.borderRadius,
  });

  final LinearGradient gradient;
  final BorderRadius borderRadius;
  static const _strokeWidth = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect).deflate(_strokeWidth / 2);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_GradientBorderPainter oldDelegate) => false;
}
