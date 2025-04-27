// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';

/// A widget that applies fade and slide animations to its child.
/// 
/// This widget can be used to create consistent animations across the app.
class AnimatedContent extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset slideBegin;
  final Curve curve;

  const AnimatedContent({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1200),
    this.delay = Duration.zero,
    this.slideBegin = const Offset(0, 0.2),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<AnimatedContent> createState() => _AnimatedContentState();
}

class _AnimatedContentState extends State<AnimatedContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.6, curve: widget.curve),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.slideBegin,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.8, curve: widget.curve),
      ),
    );

    if (widget.delay == Duration.zero) {
      _animationController.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _animationController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

/// A widget that applies staggered animations to a list of children.
/// 
/// This widget can be used to create staggered animations for lists or grids.
class StaggeredAnimatedList extends StatelessWidget {
  final List<Widget> children;
  final Duration itemDuration;
  final Duration staggerDuration;
  final Offset slideBegin;
  final Curve curve;
  final ScrollController? scrollController;
  final Axis scrollDirection;
  final EdgeInsetsGeometry padding;

  const StaggeredAnimatedList({
    super.key,
    required this.children,
    this.itemDuration = const Duration(milliseconds: 800),
    this.staggerDuration = const Duration(milliseconds: 50),
    this.slideBegin = const Offset(0, 0.2),
    this.curve = Curves.easeOutCubic,
    this.scrollController,
    this.scrollDirection = Axis.vertical,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      scrollDirection: scrollDirection,
      padding: padding,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return AnimatedContent(
          delay: Duration(milliseconds: index * staggerDuration.inMilliseconds),
          duration: itemDuration,
          slideBegin: slideBegin,
          curve: curve,
          child: children[index],
        );
      },
    );
  }
}

/// A widget that applies staggered animations to a grid of children.
/// 
/// This widget can be used to create staggered animations for grids.
class StaggeredAnimatedGrid extends StatelessWidget {
  final List<Widget> children;
  final Duration itemDuration;
  final Duration staggerDuration;
  final Offset slideBegin;
  final Curve curve;
  final ScrollController? scrollController;
  final SliverGridDelegate gridDelegate;
  final EdgeInsetsGeometry padding;

  const StaggeredAnimatedGrid({
    super.key,
    required this.children,
    required this.gridDelegate,
    this.itemDuration = const Duration(milliseconds: 800),
    this.staggerDuration = const Duration(milliseconds: 50),
    this.slideBegin = const Offset(0, 0.2),
    this.curve = Curves.easeOutCubic,
    this.scrollController,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      padding: padding,
      gridDelegate: gridDelegate,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return AnimatedContent(
          delay: Duration(milliseconds: index * staggerDuration.inMilliseconds),
          duration: itemDuration,
          slideBegin: slideBegin,
          curve: curve,
          child: children[index],
        );
      },
    );
  }
}
