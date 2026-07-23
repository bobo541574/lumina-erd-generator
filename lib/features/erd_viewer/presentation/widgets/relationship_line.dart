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
  final List<Rect> obstacleRects;

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
    this.obstacleRects = const [],
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

    final sourceRect = Rect.fromLTWH(
      sourcePosition.dx,
      sourcePosition.dy,
      nodeWidth,
      nodeHeight,
    );
    final targetRect = Rect.fromLTWH(
      targetPosition.dx,
      targetPosition.dy,
      nodeWidth,
      nodeHeight,
    );

    final sourcePoint = _getBestEdgePoint(sourceRect, targetRect);
    final targetPoint = _getBestEdgePoint(targetRect, sourceRect);

    final sourceDir = _edgeDirection(sourceRect, sourcePoint);
    final targetDir = _edgeDirection(targetRect, targetPoint);

    final routed = _routeWithObstacleAvoidance(
      sourcePoint,
      targetPoint,
      sourceDir,
      targetDir,
    );

    switch (lineStyle) {
      case 'straight':
        canvas.drawLine(sourcePoint, targetPoint, paint);
      case 'orthogonal':
        _drawOrthogonalLine(canvas, routed, paint);
      default:
        _drawCurvedLine(canvas, sourcePoint, targetPoint, sourceDir, targetDir, routed, paint);
    }

    _drawNotation(canvas, sourcePoint, targetPoint, sourceDir, targetDir, color);
  }

  Offset _getBestEdgePoint(Rect rect, Rect otherRect) {
    final cx = rect.center.dx;
    final cy = rect.center.dy;
    final candidates = <Offset>[
      Offset(rect.right, cy),
      Offset(rect.left, cy),
      Offset(cx, rect.bottom),
      Offset(cx, rect.top),
    ];

    var best = candidates.first;
    var bestDist = double.infinity;
    for (final c in candidates) {
      final d = (c - otherRect.center).distanceSquared;
      if (d < bestDist) {
        bestDist = d;
        best = c;
      }
    }
    return best;
  }

  double _edgeDirection(Rect rect, Offset point) {
    if (point.dx == rect.left) return pi;
    if (point.dx == rect.right) return 0;
    if (point.dy == rect.top) return -pi / 2;
    if (point.dy == rect.bottom) return pi / 2;
    return 0;
  }

  List<Offset> _routeWithObstacleAvoidance(
    Offset start,
    Offset end,
    double startDir,
    double endDir,
  ) {
    if (obstacleRects.isEmpty) return [start, end];

    final segment = LineSegment(start, end);
    final blocked = obstacleRects.any((r) => segment.intersectsRect(r));
    if (!blocked) return [start, end];

    final waypoints = <Offset>[start];
    final midX = (start.dx + end.dx) / 2;
    final offsetX = (end.dx - start.dx).abs() * 0.25;

    if (start.dy < end.dy) {
      waypoints.add(Offset(midX + offsetX, start.dy));
      waypoints.add(Offset(midX + offsetX, end.dy));
    } else {
      waypoints.add(Offset(midX - offsetX, start.dy));
      waypoints.add(Offset(midX - offsetX, end.dy));
    }
    waypoints.add(end);
    return waypoints;
  }

  void _drawCurvedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    double startDir,
    double endDir,
    List<Offset> routed,
    Paint paint,
  ) {
    if (routed.length == 2) {
      final distance = (end - start).distance;
      final curvature = min(distance * 0.25, 80.0);

      final cp1 = Offset(
        start.dx + cos(startDir) * curvature,
        start.dy + sin(startDir) * curvature,
      );
      final cp2 = Offset(
        end.dx + cos(endDir) * curvature,
        end.dy + sin(endDir) * curvature,
      );

      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, end.dx, end.dy);

      canvas.drawPath(path, paint);
      return;
    }

    final path = Path()..moveTo(routed.first.dx, routed.first.dy);

    if (routed.length == 2) {
      path.lineTo(routed[1].dx, routed[1].dy);
    } else if (routed.length == 3) {
      path.lineTo(routed[1].dx, routed[1].dy);
      path.lineTo(routed[2].dx, routed[2].dy);
    } else if (routed.length == 4) {
      final cornerRadius = min(20.0, (routed[1] - routed[0]).distance * 0.4);
      final direction = (routed[2] - routed[1]).direction;

      path.lineTo(routed[1].dx, routed[1].dy);

      path.quadraticBezierTo(
        routed[1].dx + cos(direction) * cornerRadius,
        routed[1].dy + sin(direction) * cornerRadius,
        routed[2].dx,
        routed[2].dy,
      );
      path.lineTo(routed[3].dx, routed[3].dy);
    }

    canvas.drawPath(path, paint);
  }

  void _drawOrthogonalLine(
    Canvas canvas,
    List<Offset> routed,
    Paint paint,
  ) {
    final path = Path()..moveTo(routed.first.dx, routed.first.dy);

    for (var i = 1; i < routed.length; i++) {
      path.lineTo(routed[i].dx, routed[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  void _drawNotation(
    Canvas canvas,
    Offset sourcePoint,
    Offset targetPoint,
    double sourceDir,
    double targetDir,
    Color color,
  ) {
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
        oldDelegate.highlightedColor != highlightedColor ||
        oldDelegate.obstacleRects != obstacleRects;
  }
}

class LineSegment {
  final Offset a;
  final Offset b;

  LineSegment(this.a, this.b);

  bool intersectsRect(Rect rect) {
    if (rect.contains(a) || rect.contains(b)) return true;

    if (_intersectsEdge(rect.topLeft, rect.topRight)) return true;
    if (_intersectsEdge(rect.topRight, rect.bottomRight)) return true;
    if (_intersectsEdge(rect.bottomRight, rect.bottomLeft)) return true;
    if (_intersectsEdge(rect.bottomLeft, rect.topLeft)) return true;

    return false;
  }

  bool _intersectsEdge(Offset c, Offset d) {
    final cross = (b.dx - a.dx) * (d.dy - c.dy) - (b.dy - a.dy) * (d.dx - c.dx);
    if (cross.abs() < 1e-10) return false;

    final t = ((c.dx - a.dx) * (d.dy - c.dy) - (c.dy - a.dy) * (d.dx - c.dx)) / cross;
    final u = ((c.dx - a.dx) * (b.dy - a.dy) - (c.dy - a.dy) * (b.dx - a.dx)) / cross;

    return t >= 0 && t <= 1 && u >= 0 && u <= 1;
  }
}
