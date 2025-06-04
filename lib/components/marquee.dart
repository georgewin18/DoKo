import 'package:app/constants/colors.dart';
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
  bool _isAtStart = false;
  bool _isAnimating = false;
  bool _isPaused = false;
  bool _isManuallyPaused = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
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
        while (_isPaused && _isAnimating) {
          await Future.delayed(const Duration(milliseconds: 100));
        }

        if (!_isAnimating || !mounted) break;

        if (_isAtStart) {
          await Future.delayed(widget.startDelay);
          if (_isPaused || !_isAnimating) continue;
          await _controller.forward();
        } else {
          await Future.delayed(widget.endDelay);
          if (_isPaused || !_isAnimating) continue;
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
    final constraints = context.findRenderObject() as RenderBox?;
    final maxWidth = constraints?.constraints.maxWidth ?? double.infinity;
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      textDirection: TextDirection.ltr,
      maxLines: widget.direction == Axis.vertical ? null : 1,
    );

    textPainter.layout(
      maxWidth:
          widget.direction == Axis.horizontal ? double.infinity : maxWidth,
    );

    setState(() {
      _textExtent =
          widget.direction == Axis.horizontal
              ? textPainter.width + widget.gap
              : textPainter.height + (textPainter.height * 0.805);
    });
  }

  @override
  void didUpdateWidget(covariant Marquee oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text ||
        oldWidget.direction != widget.direction) {
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
          widget.direction == Axis.horizontal ? " ${widget.text}" : widget.text,
          style: widget.style,
          maxLines: widget.direction == Axis.vertical ? null : 1,
          overflow: TextOverflow.visible,
        );

        final gradient =
            widget.direction == Axis.horizontal
                ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [transparent, white, white, transparent],
                  stops: const [-1.0, 0.01, 0.85, 1.0],
                )
                : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [transparent, white, white, transparent],
                  stops: const [-1.0, 0.1, 0.45, 1.0],
                );

        return GestureDetector(
          onTap: () {
            setState(() {
              _isManuallyPaused = !_isManuallyPaused;
              _isPaused = _isManuallyPaused;
            });

            if (!_isPaused && _isAtStart && !_controller.isAnimating) {
              _controller.forward().then((_) {
                if (mounted && !_isPaused && _isAnimating) {
                  setState(() => _isAtStart = false);
                }
              });
            }
          },
          onTapDown: (_) {
            setState(() {
              if (!_isManuallyPaused) {
                _isPaused = true;
              }
            });
          },
          onTapUp: (_) {
            setState(() {
              if (!_isManuallyPaused) {
                _isPaused = false;
              }
            });
          },
          onTapCancel: () {
            setState(() {
              if (!_isManuallyPaused) {
                _isPaused = false;
              }
            });
          },
          child: ClipRect(
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
                        ? Row(
                          children: [textWidget, SizedBox(width: widget.gap)],
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [textWidget, SizedBox(height: widget.gap)],
                        ),
              ),
            ),
          ),
        );
      },
    );
  }
}
