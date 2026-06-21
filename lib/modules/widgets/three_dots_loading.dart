import 'dart:math' as math;
import 'package:flutter/material.dart';

class ThreeDotsLoading extends StatefulWidget {
  final Color color;
  final double size;

  const ThreeDotsLoading({
    super.key,
    this.color = Colors.red,
    this.size = 6.0,
  });

  @override
  State<ThreeDotsLoading> createState() => _ThreeDotsLoadingState();
}

class _ThreeDotsLoadingState extends State<ThreeDotsLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Calculate a wave phase offset for each dot
            final double phase = (index * math.pi / 3);
            final double waveValue = math.sin((_controller.value * 2 * math.pi) - phase);
            
            // Normalize sine wave (-1 to 1) to a scale factor (1.0 to 1.3)
            final double scale = 1.0 + 0.3 * (waveValue + 1.0) / 2.0;
            // Normalize to opacity (0.3 to 1.0)
            final double opacity = 0.3 + 0.7 * (waveValue + 1.0) / 2.0;

            return Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: scale,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
