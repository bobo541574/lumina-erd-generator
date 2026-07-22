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

  RelationshipLine({
    required this.sourcePosition,
    required this.targetPosition,
    required this.relationship,
    this.isHighlighted = false,
    this.nodeWidth = AppConstants.defaultNodeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final sourceCenter = Offset(
      sourcePosition.dx + nodeWidth / 2,
      sourcePosition.dy + 60,
    );
    final targetCenter = Offset(
      targetPosition.dx + nodeWidth / 2,
      targetPosition.dy + 60,
    );

    final color = isHighlighted
        ? Colors.orange
        : relationship.isInferred
        ? Colors.orange.withValues(alpha: 0.6)
        : Colors.blue.withValues(alpha: 0.6);

    final paint = Paint()
      ..color = color
      ..strokeWidth = isHighlighted ? 2.5 : 1.5
      ..style = PaintingStyle.stroke;

    final sourcePoint = _getEdgePoint(sourceCenter, targetCenter, nodeWidth);
    final targetPoint = _getEdgePoint(targetCenter, sourceCenter, nodeWidth);

    _drawCurvedLine(canvas, sourcePoint, targetPoint, paint);

    _drawArrowHead(canvas, sourcePoint, targetPoint, color, relationship.type);

    if (relationship.type == RelationshipType.belongsToMany) {
      _drawCrowFoot(canvas, targetPoint, sourcePoint, color);
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

  void _drawArrowHead(
    Canvas canvas,
    Offset start,
    Offset end,
    Color color,
    RelationshipType type,
  ) {
    final arrowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final angle = atan2(end.dy - start.dy, end.dx - start.dx);
    const arrowLength = 10.0;
    const arrowWidth = 6.0;

    final p1 = end;
    final p2 = Offset(
      end.dx - arrowLength * cos(angle - pi / 6),
      end.dy - arrowLength * sin(angle - pi / 6),
    );
    final p3 = Offset(
      end.dx - arrowLength * cos(angle + pi / 6),
      end.dy - arrowLength * sin(angle + pi / 6),
    );

    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();

    canvas.drawPath(path, arrowPaint);
  }

  void _drawCrowFoot(Canvas canvas, Offset target, Offset source, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final angle = atan2(source.dy - target.dy, source.dx - target.dx);
    const spread = pi / 5;
    const length = 12.0;

    final left = Offset(
      target.dx + length * cos(angle + spread),
      target.dy + length * sin(angle + spread),
    );
    final right = Offset(
      target.dx + length * cos(angle - spread),
      target.dy + length * sin(angle - spread),
    );

    canvas.drawLine(target, left, paint);
    canvas.drawLine(target, right, paint);
  }

  Offset _getEdgePoint(Offset center, Offset target, double width) {
    final dx = target.dx - center.dx;
    final dy = target.dy - center.dy;
    final distance = sqrt(dx * dx + dy * dy);

    if (distance == 0) return center;

    final halfWidth = width / 2;
    const halfHeight = 60.0;

    final scaleX = halfWidth / distance;
    final scaleY = halfHeight / distance;
    final scale = min(scaleX, scaleY);

    return Offset(center.dx + dx * scale, center.dy + dy * scale);
  }

  @override
  bool shouldRepaint(covariant RelationshipLine oldDelegate) {
    return oldDelegate.sourcePosition != sourcePosition ||
        oldDelegate.targetPosition != targetPosition ||
        oldDelegate.isHighlighted != isHighlighted ||
        oldDelegate.relationship != relationship;
  }
}
