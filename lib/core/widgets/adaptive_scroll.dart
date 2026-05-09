import 'package:flutter/material.dart';

class AdaptiveScrollColumn extends StatelessWidget {
  const AdaptiveScrollColumn({
    required this.children,
    super.key,
    this.padding = EdgeInsets.zero,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.reserveBottomInset = false,
  });

  final List<Widget> children;
  final EdgeInsets padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool reserveBottomInset;

  @override
  Widget build(BuildContext context) {
    final double bottomInset =
        reserveBottomInset ? MediaQuery.viewInsetsOf(context).bottom : 0;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.only(bottom: bottomInset),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (constraints.maxHeight - bottomInset)
                  .clamp(0, double.infinity),
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: padding,
                child: Column(
                  mainAxisAlignment: mainAxisAlignment,
                  crossAxisAlignment: crossAxisAlignment,
                  children: children,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AdaptiveSheetBody extends StatelessWidget {
  const AdaptiveSheetBody({
    required this.child,
    super.key,
    this.maxHeightFraction = 0.9,
  });

  final Widget child;
  final double maxHeightFraction;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);
    final double maxHeight = mq.size.height * maxHeightFraction;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
        child: child,
      ),
    );
  }
}
