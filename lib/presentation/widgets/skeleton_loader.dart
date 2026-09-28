import 'package:flutter/material.dart';

class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({super.key});

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.white10 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.white24 : Colors.grey.shade100;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final color = Color.lerp(baseColor, highlightColor, _controller.value);
        return Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(24),
          ),
        );
      },
    );
  }
}
