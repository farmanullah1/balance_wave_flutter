import 'package:flutter/material.dart';

class CarrierLogo extends StatelessWidget {
  final String carrier;
  final double size;

  const CarrierLogo({super.key, required this.carrier, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: CarrierLogoPainter(carrier),
      ),
    );
  }
}

class CarrierLogoPainter extends CustomPainter {
  final String carrier;
  CarrierLogoPainter(this.carrier);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..style = PaintingStyle.fill;
    final r = size.width * 0.22;

    switch (carrier) {
      case 'Jazz':
        paint.shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF0000), Color(0xB3000000)],
        ).createShader(rect);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(r)), paint);
        
        final starPaint = Paint()..color = const Color(0xFFFFC107);
        final path = Path();
        path.moveTo(size.width * 0.5, size.height * 0.2);
        path.lineTo(size.width * 0.58, size.height * 0.4);
        path.lineTo(size.width * 0.78, size.height * 0.4);
        path.lineTo(size.width * 0.62, size.height * 0.52);
        path.lineTo(size.width * 0.68, size.height * 0.72);
        path.lineTo(size.width * 0.5, size.height * 0.6);
        path.lineTo(size.width * 0.32, size.height * 0.72);
        path.lineTo(size.width * 0.38, size.height * 0.52);
        path.lineTo(size.width * 0.22, size.height * 0.4);
        path.lineTo(size.width * 0.42, size.height * 0.4);
        path.close();
        canvas.drawPath(path, starPaint);
        break;

      case 'Zong':
        paint.shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE6007E), Color(0xFF8C004D)],
        ).createShader(rect);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(r)), paint);
        
        final leafPaint = Paint()..color = const Color(0xFF8DC63F).withValues(alpha: 0.9);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(size.width * 0.5, size.height * 0.5),
            width: size.width * 0.7,
            height: size.height * 0.5,
          ),
          leafPaint,
        );
        break;

      case 'Ufone':
        paint.shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF7900), Color(0xFFCC6100)],
        ).createShader(rect);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(r)), paint);
        
        final uPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.14
          ..strokeCap = StrokeCap.round;
        
        final uPath = Path()
          ..moveTo(size.width * 0.3, size.height * 0.3)
          ..lineTo(size.width * 0.3, size.height * 0.55)
          ..arcToPoint(
            Offset(size.width * 0.7, size.height * 0.55),
            radius: Radius.circular(size.width * 0.2),
            clockwise: false,
          )
          ..lineTo(size.width * 0.7, size.height * 0.3);
        canvas.drawPath(uPath, uPaint);
        break;

      case 'Telenor':
        paint.shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00A5CF), Color(0xFF007291)],
        ).createShader(rect);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(r)), paint);
        
        final whitePaint = Paint()..color = Colors.white;
        canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.35), size.width * 0.12, whitePaint);
        canvas.drawCircle(Offset(size.width * 0.32, size.height * 0.65), size.width * 0.12, whitePaint);
        canvas.drawCircle(Offset(size.width * 0.68, size.height * 0.65), size.width * 0.12, whitePaint);
        break;

      case 'Onic':
        paint.color = const Color(0xFF1A1A1A);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(r)), paint);
        
        final circlePaint = Paint()
          ..color = const Color(0xFFE6007E)
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.12;
        canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), size.width * 0.3, circlePaint);
        break;

      case 'SCOm':
        paint.color = const Color(0xFF0D47A1);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(r)), paint);
        
        final orangePaint = Paint()
          ..color = const Color(0xFFFF9800)
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.14
          ..strokeCap = StrokeCap.round;
        
        final wavePath = Path()
          ..moveTo(size.width * 0.2, size.height * 0.5)
          ..quadraticBezierTo(size.width * 0.35, size.height * 0.25, size.width * 0.5, size.height * 0.5)
          ..quadraticBezierTo(size.width * 0.65, size.height * 0.75, size.width * 0.8, size.height * 0.5);
        canvas.drawPath(wavePath, orangePaint);
        break;

      default:
        paint.color = const Color(0xFF455A64);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(r)), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
