import 'package:flutter/material.dart';

import 'package:lumi/core/theme/app_colors.dart';
<<<<<<< HEAD
=======
import 'package:lumi/core/theme/app_text_styles.dart';
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e

class LumiScaffold extends StatelessWidget {
  const LumiScaffold({
    required this.child,
    super.key,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
<<<<<<< HEAD
=======
    this.centered = false,
    this.maxContentWidth = 440,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
  });

  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
<<<<<<< HEAD

  @override
  Widget build(BuildContext context) {
=======
  final bool centered;
  final double maxContentWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final Widget body = SafeArea(
      child: Padding(
        padding: padding,
        child: Align(
          alignment: centered ? Alignment.center : Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: child,
          ),
        ),
      ),
    );

>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.deepNight,
      appBar: title == null
          ? null
<<<<<<< HEAD
          : AppBar(title: Text(title!), actions: actions),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [AppColors.glowAmber, AppColors.deepNight],
            stops: [0.0, 0.85],
          ),
        ),
        child: SafeArea(child: child),
=======
          : AppBar(
              title: Text(
                title!,
                style: AppTextStyles.eyebrow.copyWith(color: AppColors.textFaint),
              ),
              actions: actions,
            ),
      body: Stack(
        children: <Widget>[
          const _AmbientBackground(),
          body,
        ],
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
<<<<<<< HEAD
=======

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.deepNight,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -140,
              left: -140,
              child: _GlowBlob(
                color: AppColors.softLavender.withValues(alpha: 0.27),
                size: 420,
              ),
            ),
            Positioned(
              bottom: -180,
              right: -150,
              child: _GlowBlob(
                color: AppColors.coral.withValues(alpha: 0.22),
                size: 480,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[
              color,
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
