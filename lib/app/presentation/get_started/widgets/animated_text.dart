import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle style;
  const AnimatedText({
    required this.text,
    Key? key,
    required this.style,
  }) : super(key: key);

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _textAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _textAnimation = IntTween(begin: 0, end: widget.text.length).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Text(
          widget.text.substring(0, _textAnimation.value),
          style: widget.style,
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text) {
      _controller.reset();
      _textAnimation = IntTween(begin: 0, end: widget.text.length).animate(_controller);
      _controller.forward();
    }
  }
}
