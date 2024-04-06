import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BouncingButton extends StatefulWidget {
  final Function onTap;
  final String text;

  const BouncingButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  _BouncingButtonState createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 1.0, end: 0.9).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      onTap: () {
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            widget.text,
            style: GoogleFonts.roboto(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Colors.grey[700],
      ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
