import 'package:flutter/material.dart';

class SkeletonCard extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const SkeletonCard({
    super.key,
    this.height = 200,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: borderRadius,
      ),
      child: const _ShimmerAnimation(),
    );
  }
}

class _ShimmerAnimation extends StatefulWidget {
  const _ShimmerAnimation();

  @override
  State<_ShimmerAnimation> createState() => _ShimmerAnimationState();
}

class _ShimmerAnimationState extends State<_ShimmerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 - _controller.value * 2, 0),
              end: Alignment(1.0 - _controller.value * 2, 0),
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade200,
                Colors.grey.shade300,
              ],
            ).createShader(bounds);
          },
          child: Container(
            color: Colors.white,
          ),
        );
      },
    );
  }
}

/// Grid skeleton untuk loading state
class SkeletonGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;

  const SkeletonGrid({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.62,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => SkeletonCard(
        height: 300,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
