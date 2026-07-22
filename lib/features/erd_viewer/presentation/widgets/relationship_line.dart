import 'dart:math';
import 'package:flutter/material.dart';
import '../../../schema_parser/domain/models/relationship_schema.dart';
import '../../../../core/constants/app_constants.dart';

class RelationshipLine extends CustomPainter {
  final Offset sourcePosition;
  final Offset targetPosition;
  final RelationshipSchema relationship;
  final bool isHighlighted;
  final double nodeWidth;
  final double nodeHeight;
  final String lineStyle;
  final String notationStyle;
  final Color normalColor;
  final Color highlightedColor;
  final Color inferredColor;

  RelationshipLine({
    required this.sourcePosition,
    required this.targetPosition,
    required this.relationship,
    this.isHighlighted = false,
    this.nodeWidth = AppConstants.defaultNodeWidth,
    this.nodeHeight = 160.0,
    this.lineStyle = 'orthogonal',
    this.notationStyle = 'crowsFoot',
    this.normalColor = const Color(0x99303F9F),
    this.highlightedColor = Colors.orange,
    this.inferredColor = const Color(0x99EF6C00),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final color = isHighlighted
        ? highlightedColor
        : relationship.isInferred
        ? inferredColor
        : normalColor;

    final paint = Paint()
      ..color = color
      ..strokeWidth = isHighlighted ? 2.5 : 1.5
      ..style = PaintingStyle.stroke;

    final sourcePoint = _getSourceEdgePoint();
    final targetPoint = _getTargetEdgePoint();

    switch (lineStyle) {
      case 'straight':
        canvas.drawLine(sourcePoint, targetPoint, paint);
      case 'orthogonal':
        _drawOrthogonalLine(canvas, sourcePoint, targetPoint, paint);
      default:
        _drawCurvedLine(canvas, sourcePoint, targetPoint, paint);
    }

    _drawNotation(canvas, sourcePoint, targetPoint, color);
  }

  Offset _getSourceEdgePoint() {
    final centerX = sourcePosition.dx + nodeWidth / 2;
    final centerY = sourcePosition.dy + nodeHeight / 2;
    final targetCenterX = targetPosition.dx + nodeWidth / 2;

    if (targetCenterX > centerX + nodeWidth * 0.1) {
      return Offset(sourcePosition.dx + nodeWidth, centerY);
    } else if (targetCenterX < centerX - nodeWidth * 0.1) {
      return Offset(sourcePosition.dx, centerY);
    } else {
      return Offset(sourcePosition.dx + nodeWidth, centerY);
    }
  }

  Offset _getTargetEdgePoint() {
    final centerX = targetPosition.dx + nodeWidth / 2;
    final centerY = targetPosition.dy + nodeHeight / 2;
    final sourceCenterX = sourcePosition.dx + nodeWidth / 2;

    if (sourceCenterX < centerX - nodeWidth * 0.1) {
      return Offset(targetPosition.dx, centerY);
    } else if (sourceCenterX > centerX + nodeWidth * 0.1) {
      return Offset(targetPosition.dx + nodeWidth, centerY);
    } else {
      return Offset(targetPosition.dx, centerY);
    }
  }

  void _drawCurvedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    final midX = (start.dx + end.dx) / 2;
    final midY = (start.dy + end.dy) / 2;

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = sqrt(dx * dx + dy * dy);

    final curvature = min(distance * 0.2, 50.0);

    final controlPoint1 = Offset(midX - curvature, midY);
    final controlPoint2 = Offset(midX + curvature, midY);

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        end.dx,
        end.dy,
      );

    canvas.drawPath(path, paint);
  }

  void _drawOrthogonalLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
  ) {
    final midX = (start.dx + end.dx) / 2;

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(midX, start.dy)
      ..lineTo(midX, end.dy)
      ..lineTo(end.dx, end.dy);

    canvas.drawPath(path, paint);
  }

  void _drawNotation(
    Canvas canvas,
    Offset sourcePoint,
    Offset targetPoint,
    Color color,
  ) {
    final sourceDir = _directionFromSource(sourcePoint, targetPoint);
    final targetDir = _directionFromSource(targetPoint, sourcePoint);

    switch (relationship.type) {
      case RelationshipType.hasMany:
        _drawOneBar(canvas, sourcePoint, sourceDir, color);
        _drawCrowFoot(canvas, targetPoint, targetDir, color);
        break;
      case RelationshipType.belongsTo:
        _drawCrowFoot(canvas, sourcePoint, sourceDir, color);
        _drawOneBar(canvas, targetPoint, targetDir, color);
        break;
      case RelationshipType.hasOne:
        _drawOneBar(canvas, sourcePoint, sourceDir, color);
        _drawOneBar(canvas, targetPoint, targetDir, color);
        break;
      case RelationshipType.belongsToMany:
        _drawCrowFoot(canvas, sourcePoint, sourceDir, color);
        _drawCrowFoot(canvas, targetPoint, targetDir, color);
        break;
    }
  }

  double _directionFromSource(Offset source, Offset target) {
    return atan2(target.dy - source.dy, target.dx - source.dx);
  }

  void _drawOneBar(Canvas canvas, Offset point, double angle, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const barLength = 8.0;
    final perpAngle = angle + pi / 2;

    final p1 = Offset(
      point.dx + barLength * cos(perpAngle),
      point.dy + barLength * sin(perpAngle),
    );
    final p2 = Offset(
      point.dx - barLength * cos(perpAngle),
      point.dy - barLength * sin(perpAngle),
    );

    canvas.drawLine(p1, p2, paint);
  }

  void _drawCrowFoot(Canvas canvas, Offset point, double angle, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const spread = pi / 5;
    const length = 12.0;

    final left = Offset(
      point.dx + length * cos(angle + spread),
      point.dy + length * sin(angle + spread),
    );
    final right = Offset(
      point.dx + length * cos(angle - spread),
      point.dy + length * sin(angle - spread),
    );
    final center = Offset(
      point.dx + length * cos(angle),
      point.dy + length * sin(angle),
    );

    canvas.drawLine(point, left, paint);
    canvas.drawLine(point, right, paint);
    canvas.drawLine(point, center, paint);
  }

  @override
  bool shouldRepaint(covariant RelationshipLine oldDelegate) {
    return oldDelegate.sourcePosition != sourcePosition ||
        oldDelegate.targetPosition != targetPosition ||
        oldDelegate.isHighlighted != isHighlighted ||
        oldDelegate.relationship != relationship ||
        oldDelegate.lineStyle != lineStyle ||
        oldDelegate.notationStyle != notationStyle ||
        oldDelegate.normalColor != normalColor ||
        oldDelegate.highlightedColor != highlightedColor;
  }
}
