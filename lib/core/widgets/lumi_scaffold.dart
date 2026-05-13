import 'package:flutter/material.dart';

import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/theme/app_text_styles.dart';

class LumiScaffold extends StatelessWidget {
  const LumiScaffold({
    required this.child,
    super.key,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.centered = false,
    this.maxContentWidth = 440,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });

  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
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

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.deepNight,
      appBar: title == null
          ? null
          : AppBar(
              title: Text(
                title!,
                style: AppTextStyles.eyebrow.copyWith(
                  color: AppColors.textFaint,
                ),
              ),
              actions: actions,
            ),
      body: Stack(children: <Widget>[const _AmbientBackground(), body]),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.deepNight),
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
          gradient: RadialGradient(colors: <Color>[color, Colors.transparent]),
        ),
      ),
    );
  }
}
