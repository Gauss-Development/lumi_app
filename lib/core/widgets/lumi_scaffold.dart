import 'package:flutter/material.dart';

import 'package:lumi/core/theme/app_colors.dart';

class LumiScaffold extends StatelessWidget {
  const LumiScaffold({
    required this.child,
    super.key,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.deepNight,
      appBar: title == null
          ? null
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
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
