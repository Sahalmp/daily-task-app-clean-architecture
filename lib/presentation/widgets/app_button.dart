import 'package:flutter/material.dart';
class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool fullWidth;
  final ButtonStyle? style;
  final bool outlined;

  const AppButton._({
    required this.onPressed,
    required this.child,
    this.fullWidth = true,
    this.style,
    this.outlined = false,
    super.key,
  });

  factory AppButton.primary({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool fullWidth = true,
    ButtonStyle? style,
  }) => AppButton._(
        key: key,
        onPressed: onPressed,
        fullWidth: fullWidth,
        style: style,
        outlined: false,
        child: child,
      );

  factory AppButton.outlined({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool fullWidth = true,
    ButtonStyle? style,
  }) => AppButton._(
        key: key,
        onPressed: onPressed,
        fullWidth: fullWidth,
        style: style,
        outlined: true,
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final Widget btn = outlined
        ? OutlinedButton(onPressed: onPressed, style: style, child: child)
        : ElevatedButton(onPressed: onPressed, style: style, child: child);
    if (fullWidth) {
      return SizedBox(width: double.infinity, child: btn);
    }
    return btn;
  }
}