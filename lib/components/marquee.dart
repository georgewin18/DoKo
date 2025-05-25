import 'package:flutter/material.dart';

class Marquee extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final Duration startDelay;
  final Duration endDelay;
  final Axis direction;
  final double gap;
  final int? maxLines;

  const Marquee({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(seconds: 4),
    this.startDelay = const Duration(seconds: 3),
    this.endDelay = const Duration(milliseconds: 1500),
    this.direction = Axis.horizontal,
    this.gap = 150.0,
    this.maxLines,
  });

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _controller;
  late Animation<double> _animation;
  double _textExtent = 0.0;
  double _containerExtent = 0.0;
  bool _isAtStart = true;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    _isAnimating = false;
    await Future.delayed(Duration.zero);
    _isAnimating = true;

    await _calculateTextExtent();

    if (_textExtent > _containerExtent) {
      final maxScroll = _textExtent - _containerExtent;

      _animation = Tween<double>(begin: 0.0, end: maxScroll).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      )..addListener(() {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_animation.value);
        }
      });

      _isAtStart = true;

      while (_isAnimating && mounted) {
        if (_isAtStart) {
          await Future.delayed(widget.startDelay);
          if (!_isAnimating) break;
          await _controller.forward();
        } else {
          await Future.delayed(widget.endDelay);
          if (!_isAnimating) break;
          await _controller.reverse();
        }
        _isAtStart = !_isAtStart;
      }
    } else {
      _controller.stop();
      _scrollController.jumpTo(0);
    }
  }

  Future<void> _calculateTextExtent() async {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      textDirection: TextDirection.ltr,
      maxLines: widget.direction == Axis.vertical ? widget.maxLines : 1,
    );

    final maxWidth = context.size?.width ?? double.infinity;

    textPainter.layout(maxWidth: maxWidth);

    setState(() {
      _textExtent =
          widget.direction == Axis.horizontal
              ? textPainter.width + widget.gap
              : textPainter.height + widget.gap * 0.5;
    });
  }

  @override
  void didUpdateWidget(covariant Marquee oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text) {
      _isAnimating = false;
      _controller.reset();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _start();
      });
    }
  }

  @override
  void dispose() {
    _isAnimating = false;
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _containerExtent =
            widget.direction == Axis.horizontal
                ? constraints.maxWidth
                : constraints.maxHeight;

        final textWidget = Text(
          widget.text,
          style: widget.style,
          maxLines: widget.direction == Axis.vertical ? widget.maxLines : 1,
          overflow: TextOverflow.visible,
        );

        final gradient =
            widget.direction == Axis.horizontal
                ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: const [
                    Colors.white,
                    Colors.white,
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.85, 1.0],
                )
                : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [
                    Colors.white,
                    Colors.white,
                    Colors.transparent,
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 0.8, 1.0],
                );

        return ClipRect(
          child: ShaderMask(
            shaderCallback:
                (bounds) => gradient.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
            blendMode: BlendMode.dstIn,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: widget.direction,
              physics: const NeverScrollableScrollPhysics(),
              child:
                  widget.direction == Axis.horizontal
                      ? Row(children: [textWidget, SizedBox(width: widget.gap)])
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [textWidget, SizedBox(height: widget.gap)],
                      ),
            ),
          ),
        );
      },
    );
  }
}
