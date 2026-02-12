import 'dart:math';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TwoValueCircle extends StatefulWidget {
  final double completed;
  final double canceled;

  const TwoValueCircle({super.key, required this.completed, required this.canceled});

  @override
  State<TwoValueCircle> createState() => _TwoValueCircleState();
}

class _TwoValueCircleState extends State<TwoValueCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // 1. Initialize the controller (duration of the animation)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 2. Define the curve (EaseOut makes it start fast and slow down)
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    // 3. Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Keeps the column tight around the content
      children: [
        Text("Total Requests:"),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              size: const Size(200, 200),
              painter: ProgressPainter(
                completed: widget.completed,
                canceled: widget.canceled,
                progress: _animation.value,
              ),
            );
          },
        ),
        const SizedBox(height: 30), // Space between the circle and labels
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Completed Label
            _buildLegend(color: AppColors.red, label: "Completed",number: widget.completed),

            const SizedBox(width: 40),

            // Canceled Label
            _buildLegend(color: AppColors.grey, label: "Canceled",number: widget.canceled),
          ],
        )
      ],
    );
  }
}
Widget _buildLegend({required Color color, required String label,required double number}) {
  return Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 8), // Gap between circle and text
      Text(
        "$label(${number.toInt()})",
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    ],
  );
}
class ProgressPainter extends CustomPainter {
  final double completed;
  final double canceled;
  final double progress;

  ProgressPainter({required this.completed, required this.canceled, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 25.0;
    double total = completed + canceled;

    // If total is 0, avoid division by zero
    if (total == 0) return;

    double center = size.width / 2;
    double radius = (size.width / 2) - strokeWidth;

    double startAngle = -pi / 2;
    final rect = Rect.fromCircle(center: Offset(center, center), radius: radius);

    // --- Draw Completed Segment ---
    double completedSweep = (completed / total) * 2 * pi * progress;
    final paintCompleted = Paint()
      ..color = AppColors.red
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt; // Changed from .round to .butt

    canvas.drawArc(rect, startAngle, completedSweep, false, paintCompleted);

    // --- Draw Canceled Segment ---
    double canceledSweep = (canceled / total) * 2 * pi * progress;
    final paintCanceled = Paint()
      ..color = AppColors.grey
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt; // Changed from .round to .butt

    canvas.drawArc(rect, startAngle + completedSweep, canceledSweep, false, paintCanceled);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}