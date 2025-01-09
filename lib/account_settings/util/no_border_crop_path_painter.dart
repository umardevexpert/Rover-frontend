import 'package:flutter/material.dart';

/// Draw a solid path around the given path
class NoBorderCropPathPainter extends CustomPainter {
  static const _strokeWidth = 0.0;
  final Path _path;
  final _paint = Paint()
    ..color = Colors.transparent
    ..strokeWidth = _strokeWidth
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  /// Draw a solid path around the given path
  NoBorderCropPathPainter(this._path);

  /// Return a CustomPaint widget with the current CustomPainter
  static CustomPaint drawPath(Path path) => CustomPaint(painter: NoBorderCropPathPainter(path));

  @override
  void paint(Canvas canvas, Size size) => canvas.drawPath(_path, _paint);

  @override
  bool shouldRepaint(covariant NoBorderCropPathPainter oldDelegate) => oldDelegate._path != _path;
}
