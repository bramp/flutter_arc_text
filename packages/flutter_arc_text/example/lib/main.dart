import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Storybook(
        initialStory: 'Arc text',
        stories: [
          Story(
            name: 'Arc text',
            builder: (context) {
              final displayCircle = context.knobs.boolean(
                label: 'Display circle',
                initial: true,
              );
              final radius = context.knobs
                  .slider(label: 'Radius', initial: 100, max: 200, min: 50);
              final startAngle = context.knobs
                      .slider(label: 'Start angle', initial: 0, max: 360) *
                  pi /
                  180;
              final stretchAngle = context.knobs
                      .slider(label: 'Stretch angle', initial: 0, max: 360) *
                  pi /
                  180;
              final text = context.knobs.text(
                label: 'Text',
                initial: 'Hello, Flutter! I am ArcText widget. '
                    'I can draw circular text.',
              );
              final alignment = context.knobs.options(
                label: 'Alignment',
                options: const [
                  Option(
                    label: 'Start',
                    value: StartAngleAlignment.start,
                  ),
                  Option(
                    label: 'Center',
                    value: StartAngleAlignment.center,
                  ),
                  Option(label: 'End', value: StartAngleAlignment.end),
                ],
                initial: StartAngleAlignment.start,
              );
              final hasBackground = context.knobs.boolean(label: 'Background');
              final hasDecoration = context.knobs.boolean(label: 'Decoration');

              return Container(
                decoration: displayCircle
                    ? BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(radius),
                        color: Colors.white,
                      )
                    : null,
                width: radius * 2,
                height: radius * 2,
                child: ArcText(
                  radius: radius,
                  text: text,
                  textStyle: const TextStyle(fontSize: 18, color: Colors.black),
                  startAngle: startAngle,
                  startAngleAlignment: alignment,
                  placement: context.knobs.options(
                    label: 'Placement',
                    options: const [
                      Option(label: 'Outside', value: Placement.outside),
                      Option(label: 'Inside', value: Placement.inside),
                      Option(label: 'Middle', value: Placement.middle),
                    ],
                    initial: Placement.outside,
                  ),
                  direction:
                      context.knobs.boolean(label: 'Clockwise', initial: true)
                          ? Direction.clockwise
                          : Direction.counterClockwise,
                  stretchAngle: stretchAngle == 0 ? null : stretchAngle,
                  painterDelegate: _makeDelegate(hasBackground, hasDecoration),
                ),
              );
            },
          ),
        ],
      );
}

final _backgroundPaint = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 2
  ..color = Colors.black;

final _decorationPaint = Paint()
  ..style = PaintingStyle.stroke
  ..strokeCap = StrokeCap.round
  ..strokeWidth = 32
  ..color = Colors.yellow;

PainterDelegate _makeDelegate(bool hasBackground, bool hasDecoration) =>
    (canvas, size, painter) {
      final rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: painter.radius,
      );

      if (hasBackground) {
        canvas.drawArc(
          rect,
          painter.startAngle,
          painter.sweepAngle,
          false,
          _decorationPaint,
        );
      }

      painter.paint(canvas, size);

      if (hasDecoration) {
        canvas.drawArc(
          rect,
          painter.finalAngle + radians(10),
          2 * pi - painter.sweepAngle - radians(20),
          false,
          _backgroundPaint,
        );
      }
    };
