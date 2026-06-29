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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = (widget.completed + widget.canceled).toInt();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Premium dashboard circle with centered stats
        Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(180, 180),
                  painter: ProgressPainter(
                    completed: widget.completed,
                    canceled: widget.canceled,
                    progress: _animation.value,
                  ),
                );
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$total",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  "Total Requests",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 28),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     _buildModernLegend(
        //       color: AppColors.red,
        //       label: "Completed",
        //       number: widget.completed,
        //       icon: Icons.check_circle_outline_rounded,
        //     ),
        //     // const SizedBox(width: 24),
        //     // Spacer(),
        //     _buildModernLegend(
        //       color: AppColors.grey,
        //       label: "Canceled",
        //       number: widget.canceled,
        //       icon: Icons.cancel_outlined,
        //     ),
        //   ],
        // )
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16, // Horizontal space between items
          runSpacing: 12, // Vertical space if they wrap
          children: [
            _buildModernLegend(
              color: AppColors.red,
              label: "Completed",
              number: widget.completed,
              icon: Icons.check_circle_outline_rounded,
            ),
            _buildModernLegend(
              color: AppColors.grey,
              label: "Canceled",
              number: widget.canceled,
              icon: Icons.cancel_outlined,
            ),
          ],
        )

      ],
    );
  }

  Widget _buildModernLegend({
    required Color color,
    required String label,
    required double number,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.12), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            "$label: ${number.toInt()}",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: color == AppColors.grey ? AppColors.black.withOpacity(0.8) : color,
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double completed;
  final double canceled;
  final double progress;

  ProgressPainter({required this.completed, required this.canceled, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 14.0;
    double total = completed + canceled;

    double center = size.width / 2;
    double radius = (size.width / 2) - strokeWidth;
    final rect = Rect.fromCircle(center: Offset(center, center), radius: radius);

    // --- Draw Gray Background Track ---
    final paintTrack = Paint()
      ..color = AppColors.grey.withOpacity(0.15)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(center, center), radius, paintTrack);

    if (total == 0) return;

    double startAngle = -pi / 2;

    // --- Draw Completed Segment ---
    double completedSweep = (completed / total) * 2 * pi * progress;
    if (completedSweep > 0) {
      final paintCompleted = Paint()
        ..color = AppColors.red
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngle, completedSweep, false, paintCompleted);
    }

    // --- Draw Canceled Segment ---
    double canceledSweep = (canceled / total) * 2 * pi * progress;
    if (canceledSweep > 0) {
      final paintCanceled = Paint()
        ..color = AppColors.grey
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      // Add a slight offset/gap to prevent overlap if both segments exist
      double startOffset = completedSweep > 0 ? 0.05 : 0.0;
      canvas.drawArc(
        rect, 
        startAngle + completedSweep + startOffset, 
        max(0.0, canceledSweep - startOffset), 
        false, 
        paintCanceled
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
