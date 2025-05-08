import 'dart:async';
import 'package:flutter/material.dart';

class Marquee extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration speed;
  final Duration delay;
  final int revealUntilIndex;
  final int? maxLines; // ← tambahkan maxLines opsional

  const Marquee({
    super.key,
    required this.text,
    required this.revealUntilIndex,
    this.style,
    this.speed = const Duration(milliseconds: 200),
    this.delay = const Duration(seconds: 1),
    this.maxLines, // ← opsional
  });

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> {
  late Timer _timer;
  int _startIndex = 0;
  int _endIndex = 0;
  String _visibleText = '';
  bool _isReversing = false;

  @override
  void initState() {
    super.initState();
    _resetState();
    Future.delayed(widget.delay, () {
      _startTyping();
    });
  }

  void _resetState() {
    _startIndex = 0;
    _endIndex = widget.revealUntilIndex;
    _isReversing = false;
    _updateVisibleText(showCursor: true);
  }

  void _updateVisibleText({bool showCursor = true}) {
    final text = widget.text.substring(_startIndex, _endIndex);
    if (showCursor && _endIndex < widget.text.length) {
      _visibleText =
          '$text'
          '_';
    } else if (_endIndex < widget.text.length) {
      _visibleText = '$text${widget.text[_endIndex]}';
    } else {
      _visibleText = text;
    }
  }

  void _startTyping() {
    _timer = Timer.periodic(widget.speed, (timer) {
      if (!_isReversing) {
        if (_endIndex + 1 >= widget.text.length) {
          setState(() {
            _updateVisibleText(showCursor: false);
            _isReversing = true;
          });
          timer.cancel();
          Future.delayed(Duration(seconds: 1), () {
            if (!mounted) return;
            _startTyping();
          });
        } else {
          setState(() {
            _startIndex++;
            _endIndex++;
            _updateVisibleText(showCursor: true);
          });
        }
      } else {
        if (_endIndex <= widget.revealUntilIndex) {
          setState(() {
            _resetState();
          });
          timer.cancel();
          Future.delayed(widget.delay, () {
            if (!mounted) return;
            _startTyping();
          });
        } else {
          setState(() {
            _startIndex--;
            _endIndex--;
            _updateVisibleText(showCursor: true);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_visibleText, style: widget.style, maxLines: widget.maxLines);
  }
}
