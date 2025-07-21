import 'package:flutter/material.dart';
import 'package:motouber/theme/app_theme.dart';

class ModernCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final double elevation;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final bool useGradient;

  const ModernCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.gradient,
    this.padding,
    this.elevation = 8,
    this.onTap,
    this.borderRadius,
    this.useGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    Widget content = Container(
      decoration: BoxDecoration(
        gradient: useGradient 
            ? (gradient ?? AppTheme.primaryGradient)
            : null,
        color: useGradient 
            ? null 
            : (backgroundColor ?? (isDark ? AppTheme.darkColor : Colors.white)),
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: isDark && !useGradient
            ? Border.all(color: AppTheme.chromeColor.withOpacity(0.2))
            : null,
        boxShadow: [
          BoxShadow(
            color: useGradient 
                ? AppTheme.primaryColor.withOpacity(0.3)
                : (isDark 
                    ? AppTheme.secondaryColor.withOpacity(0.2)
                    : AppTheme.primaryColor.withOpacity(0.1)),
            blurRadius: elevation,
            offset: Offset(0, elevation / 2),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: content,
      );
    }

    return content;
  }
}

class GlowingCard extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const GlowingCard({
    super.key,
    required this.child,
    this.glowColor = AppTheme.secondaryColor,
    this.padding,
    this.onTap,
  });

  @override
  State<GlowingCard> createState() => _GlowingCardState();
}

class _GlowingCardState extends State<GlowingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(_animation.value * 0.5),
                blurRadius: 20 * _animation.value,
                spreadRadius: 2 * _animation.value,
              ),
            ],
          ),
          child: ModernCard(
            onTap: widget.onTap,
            padding: widget.padding,
            child: widget.child,
          ),
        );
      },
    );
  }
}