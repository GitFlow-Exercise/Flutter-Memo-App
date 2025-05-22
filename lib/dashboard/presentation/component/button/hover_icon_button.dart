import 'package:flutter/material.dart';

class HoverIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color color;
  final Duration hoverDuration;
  final bool hideHover;

  const HoverIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 24.0,
    this.color = Colors.black,
    this.hoverDuration = const Duration(milliseconds: 200),
    required this.hideHover,
  });

  @override
  State<HoverIconButton> createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<HoverIconButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final List<BoxShadow> boxShadow = _hovering && !widget.hideHover
        ? [
            BoxShadow(
              color: widget.color.withAlpha(150),
              blurRadius: 8,
              spreadRadius: 1,
            )
          ]
        : [
            BoxShadow(
              color: widget.color.withAlpha(30),
              blurRadius: 8,
              spreadRadius: 1,
            )
          ];

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: widget.hoverDuration,
          decoration: BoxDecoration(
            boxShadow: boxShadow,
            shape: BoxShape.circle
          ),
          child: Icon(
            widget.icon,
            size: widget.size,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}