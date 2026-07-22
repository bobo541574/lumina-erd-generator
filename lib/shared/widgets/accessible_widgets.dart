import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeySet, KeyEvent, KeyDownEvent, HardwareKeyboard;

class AccessibleWidget extends StatelessWidget {
  final Widget child;
  final String? semanticsLabel;
  final String? semanticsHint;
  final bool excludeSemantics;
  final Set<LogicalKeySet>? keyboardShortcuts;
  final VoidCallback? onKeyAction;

  const AccessibleWidget({
    super.key,
    required this.child,
    this.semanticsLabel,
    this.semanticsHint,
    this.excludeSemantics = false,
    this.keyboardShortcuts,
    this.onKeyAction,
  });

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    if (semanticsLabel != null || semanticsHint != null) {
      result = Semantics(
        label: semanticsLabel,
        hint: semanticsHint,
        button: onKeyAction != null,
        child: result,
      );
    }

    if (excludeSemantics) {
      result = ExcludeSemantics(child: result);
    }

    if (onKeyAction != null && keyboardShortcuts != null) {
      result = Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            for (final shortcut in keyboardShortcuts!) {
              if (shortcut.accepts(event, HardwareKeyboard.instance)) {
                onKeyAction!();
                return KeyEventResult.handled;
              }
            }
          }
          return KeyEventResult.ignored;
        },
        child: result,
      );
    }

    return result;
  }
}

class AccessibleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String semanticsLabel;
  final String? semanticsHint;
  final LogicalKeySet? shortcut;

  const AccessibleButton({
    super.key,
    required this.child,
    this.onPressed,
    required this.semanticsLabel,
    this.semanticsHint,
    this.shortcut,
  });

  @override
  Widget build(BuildContext context) {
    Widget result = Semantics(
      button: true,
      label: semanticsLabel,
      hint: semanticsHint,
      enabled: onPressed != null,
      child: child,
    );

    if (shortcut != null && onPressed != null) {
      result = CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          shortcut!: onPressed!,
        },
        child: result,
      );
    }

    return result;
  }
}

class ScaleAccessibleText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const ScaleAccessibleText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    final scaledStyle = style?.copyWith(
      fontSize: style?.fontSize != null
          ? textScaler.scale(style!.fontSize!).clamp(
              (style!.fontSize ?? 14) * 0.8,
              (style!.fontSize ?? 14) * 1.3,
            )
          : null,
    );

    return Text(
      text,
      style: scaledStyle,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
