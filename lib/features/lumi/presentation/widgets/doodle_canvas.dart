import 'package:flutter/material.dart';

import 'package:lumi/features/lumi/domain/entities/lumi.dart';

class DoodleCanvas extends StatelessWidget {
  const DoodleCanvas({
    required this.points,
    required this.color,
    required this.onChanged,
    required this.onClear,
    super.key,
  });

  final List<DoodlePoint> points;
  final Color color;
  final ValueChanged<List<DoodlePoint>> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return GestureDetector(
                  onPanStart: (DragStartDetails details) {
                    onChanged(<DoodlePoint>[
                      ...points,
                      DoodlePoint(
                        dx: details.localPosition.dx / constraints.maxWidth,
                        dy: details.localPosition.dy / constraints.maxHeight,
                      ),
                    ]);
                  },
                  onPanUpdate: (DragUpdateDetails details) {
                    onChanged(<DoodlePoint>[
                      ...points,
                      DoodlePoint(
                        dx: details.localPosition.dx / constraints.maxWidth,
                        dy: details.localPosition.dy / constraints.maxHeight,
                      ),
                    ]);
                  },
                  child: CustomPaint(
                    painter: _DoodlePainter(points: points, color: color),
                    child: const SizedBox.expand(),
                  ),
                );
              },
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: TextButton(onPressed: onClear, child: const Text('Clear')),
          ),
        ],
      ),
    );
  }
}

class _DoodlePainter extends CustomPainter {
  const _DoodlePainter({required this.points, required this.color});

  final List<DoodlePoint> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) {
      return;
    }

    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Path path = Path();
    path.moveTo(points.first.dx * size.width, points.first.dy * size.height);

    for (final DoodlePoint point in points.skip(1)) {
      path.lineTo(point.dx * size.width, point.dy * size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DoodlePainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}
