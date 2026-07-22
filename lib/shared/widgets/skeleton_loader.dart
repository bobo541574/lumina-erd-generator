import 'package:flutter/material.dart';

class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(
              alpha: _animation.value,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}

class TableCardSkeleton extends StatelessWidget {
  const TableCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SkeletonLoader(width: 180, height: 20),
                Spacer(),
                SkeletonLoader(width: 60, height: 20, borderRadius: 10),
              ],
            ),
            SizedBox(height: 12),
            SkeletonLoader(width: double.infinity, height: 14),
            SizedBox(height: 8),
            SkeletonLoader(width: 200, height: 14),
            SizedBox(height: 8),
            SkeletonLoader(width: 160, height: 14),
          ],
        ),
      ),
    );
  }
}

class ErdCanvasSkeleton extends StatelessWidget {
  const ErdCanvasSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (var i = 0; i < 6; i++)
          Positioned(
            left: (i % 3) * 260.0 + 20,
            top: (i ~/ 3) * 200.0 + 20,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoader(
                      width: 120 + (i * 10).toDouble(),
                      height: 18,
                    ),
                    const SizedBox(height: 8),
                    const SkeletonLoader(width: 160, height: 12),
                    const SizedBox(height: 6),
                    const SkeletonLoader(width: 140, height: 12),
                    const SizedBox(height: 6),
                    const SkeletonLoader(width: 100, height: 12),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
