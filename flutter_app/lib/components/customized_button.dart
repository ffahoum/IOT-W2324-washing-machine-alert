import 'package:flutter/material.dart';
import '../colors.dart';
import 'dart:ui' as ui;

class NeumorphicContainer extends StatelessWidget {
  const NeumorphicContainer({
    Key? key,
    this.child,
    this.pressed,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.color,
    this.borderRadius,
    this.border,
    this.decoration,
    this.foregroundDecoration,
    this.disableForegroundDecoration,
    this.disabled,
  }) : super(key: key);

  final bool? pressed;
  final double? width;
  final double? height;
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final EdgeInsetsGeometry? padding;
  final bool? disableForegroundDecoration;
  final bool? disabled;

  @override
  Widget build(BuildContext context) {
    BorderRadius deafultRadius =
        BorderRadius.circular(20);
    InnerShadowDecoration defaultForegroundDecoration = InnerShadowDecoration(
      colors: pressed == true
          ? [
              CustomColors.containerInnerShadowTop,
              CustomColors.containerInnerShadowBottom
            ]
          : [
              CustomColors.container,
              CustomColors.container,
            ],
      borderRadius: borderRadius ?? deafultRadius,
    );

    return Opacity(
      opacity: disabled == true ? .5 : 1,
      child: AnimatedContainer(
        width: width,
        height: height,
        margin: margin,
        duration: const Duration(milliseconds: 150),
        padding: padding ?? const EdgeInsets.all(8.0),
        foregroundDecoration: disableForegroundDecoration != true
            ? foregroundDecoration ?? defaultForegroundDecoration
            : null,
        decoration: decoration ??
            BoxDecoration(
              borderRadius: borderRadius ?? deafultRadius,
              border: border,
              color: pressed == true
                  ? CustomColors.containerPressed
                  : color ?? CustomColors.container,
              boxShadow: pressed == true
                  ? null
                  : [
                      BoxShadow(
                        blurRadius: 10,
                        offset: const Offset(-6, -6),
                        color: CustomColors.containerShadowTop,
                      ),
                      BoxShadow(
                        blurRadius: 10,
                        offset: const Offset(6, 6),
                        color: CustomColors.containerShadowBottom,
                      ),
                    ],
            ),
        child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: borderRadius ?? deafultRadius,
          child: child,
        ),
      ),
    );
  }
}

class InnerShadowDecoration extends Decoration {
  const InnerShadowDecoration({
    required this.colors,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
  });

  final BoxShape shape;
  final BorderRadiusGeometry? borderRadius;
  final List<Color> colors;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _InnerShadowDecorationPainter(this, onChanged);
  }

  InnerShadowDecoration scale(double factor) {
    List<Color> lerpColors = [];
    for (ui.Color? color in colors) {
      var lerpColor = Color.lerp(null, color, factor);
      if (lerpColor != null) {
        lerpColors.add(lerpColor);
      }
    }

    return InnerShadowDecoration(
      colors: lerpColors,
      borderRadius: borderRadius,
      shape: shape,
    );
  }

  @override
  InnerShadowDecoration? lerpFrom(Decoration? a, double t) {
    if (a == null) return scale(t);
    if (a is InnerShadowDecoration) {
      return InnerShadowDecoration.lerp(a, this, t);
    }
    return super.lerpFrom(a, t) as InnerShadowDecoration?;
  }

  @override
  InnerShadowDecoration? lerpTo(Decoration? b, double t) {
    if (b == null) return scale(1.0 - t);
    if (b is InnerShadowDecoration) {
      return InnerShadowDecoration.lerp(this, b, t);
    }
    return super.lerpTo(b, t) as InnerShadowDecoration?;
  }

  static InnerShadowDecoration? lerp(
      InnerShadowDecoration? a, InnerShadowDecoration? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b?.scale(t);
    if (b == null) return a.scale(1.0 - t);
    if (t == 0.0) return a;
    if (t == 1.0) return b;

    List<Color> lerpColors = [];
    for (int i = 0; i < a.colors.length; i++) {
      ui.Color? aColor = a.colors[i];
      ui.Color? bColor;

      if (b.colors.length > i) {
        bColor = b.colors[i];
      } else {
        break;
      }

      var lerpColor = Color.lerp(aColor, bColor, t);
      if (lerpColor != null) {
        lerpColors.add(lerpColor);
      }
    }

    return InnerShadowDecoration(
      colors: lerpColors,
      borderRadius:
          BorderRadiusGeometry.lerp(a.borderRadius, b.borderRadius, t),
      shape: t < 0.5 ? a.shape : b.shape,
    );
  }
}

class _InnerShadowDecorationPainter extends BoxPainter {
  _InnerShadowDecorationPainter(this._decoration, VoidCallback? onChanged)
      : super(onChanged);

  final InnerShadowDecoration _decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = offset & configuration.size!;

    late Path clipPath;
    switch (_decoration.shape) {
      case BoxShape.circle:
        clipPath = Path()..addOval(rect);
        break;
      case BoxShape.rectangle:
        if (_decoration.borderRadius != null) {
          clipPath = Path()
            ..addRRect(_decoration.borderRadius!
                .resolve(configuration.textDirection)
                .toRRect(rect));
        } else {
          clipPath = Path()..addRect(rect);
        }
        break;
    }

    // based on https://gist.github.com/pskink/da43c327b75eec05d903fa1b4d0c4d3e#file-decorations-dart-L97
    const depression = 12.0;
    final delta = 10 / rect.longestSide;
    final stops = [0.5 - delta, 0.5 + delta];

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(rect.inflate(depression * 2))
      ..addPath(clipPath, Offset.zero);
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, depression);
    final clipSize = rect.size.aspectRatio > 1
        ? Size(rect.width, rect.height / 2)
        : Size(rect.width / 2, rect.height);

    canvas.save();
    canvas.clipPath(clipPath);

    for (final alignment in [Alignment.topLeft, Alignment.bottomRight]) {
      final shaderRect =
          alignment.inscribe(Size.square(rect.longestSide), rect);
      paint
        .shader = ui.Gradient.linear(
          shaderRect.topLeft,
          shaderRect.bottomRight,
          _decoration.colors,
          stops,
        );

      canvas.save();
      canvas.clipRect(alignment.inscribe(clipSize, rect));
      canvas.drawPath(path, paint);
      canvas.restore();
    }

    canvas.restore();
  }
}


class NeumorphicButton extends StatefulWidget {
  const NeumorphicButton({
    Key? key,
    required this.child,
    this.width = 90,
    this.height = 60,
    this.pressed,
    this.onTap,
    this.margin,
    this.color,
    this.disabled,
  }) : super(key: key);

  final bool? pressed;
  final double width;
  final double height;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final GestureTapCallback? onTap;
  final Color? color;
  final bool? disabled;

  @override
  NeumorphicButtonState createState() => NeumorphicButtonState();
}

class NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTap,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: NeumorphicContainer(
        pressed: widget.pressed ?? _isPressed,
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        color: widget.color,
        disabled: widget.disabled,
        child: widget.child,
      ),
    );
  }

  void _onTap(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });

    if (widget.onTap != null && widget.disabled != true) {
      widget.onTap!();
    }
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }
}
