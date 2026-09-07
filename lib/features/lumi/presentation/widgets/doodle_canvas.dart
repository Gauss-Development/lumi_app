import 'package:flutter/material.dart';

import 'package:lumi/features/lumi/domain/entities/lumi.dart';

class DoodleCanvas extends StatefulWidget {
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
  State<DoodleCanvas> createState() => _DoodleCanvasState();
}

class _DoodleCanvasState extends State<DoodleCanvas> {
  late List<DoodlePoint> _points = List<DoodlePoint>.of(widget.points);

  @override
  void didUpdateWidget(covariant DoodleCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.points != widget.points && widget.points != _points) {
      _points = List<DoodlePoint>.of(widget.points);
    }
  }

  void _addPoint(Offset localPosition, BoxConstraints constraints) {
    setState(() {
      _points = <DoodlePoint>[
        ..._points,
        DoodlePoint(
          dx: localPosition.dx / constraints.maxWidth,
          dy: localPosition.dy / constraints.maxHeight,
        ),
      ];
    });
  }

  void _commitStroke() {
    widget.onChanged(List<DoodlePoint>.of(_points));
  }

  void _clear() {
    setState(() => _points = const <DoodlePoint>[]);
    widget.onClear();
  }

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
                    _addPoint(details.localPosition, constraints);
                  },
                  onPanUpdate: (DragUpdateDetails details) {
                    _addPoint(details.localPosition, constraints);
                  },
                  onPanEnd: (_) => _commitStroke(),
                  onPanCancel: _commitStroke,
                  child: CustomPaint(
                    painter: _DoodlePainter(
                      points: _points,
                      color: widget.color,
                    ),
                    child: const SizedBox.expand(),
                  ),
                );
              },
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: TextButton(onPressed: _clear, child: const Text('Clear')),
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
