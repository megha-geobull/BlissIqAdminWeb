import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String label;
  final Color color;
  final double height;
  final double borderRadius;
  final VoidCallback onPressed;
  final Color textColor;

  const CustomButton({
    Key? key,
    required this.label,
    this.color = Colors.amber,
    this.height = 50,
    this.borderRadius = 8.0,
    required this.onPressed,
    this.textColor = Colors.black87,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: widget.height,
        decoration: BoxDecoration(
          color: _isPressed ? widget.color.withOpacity(0.8) : widget.color,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: widget.textColor,
          ),
        ),
      ),
    );
  }
}
