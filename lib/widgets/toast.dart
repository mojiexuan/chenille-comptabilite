import 'package:flutter/material.dart';

/// Toast工具类
class Toast {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  /// 显示Toast
  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
    Color? textColor,
  }) {
    if (_isVisible) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isVisible = false;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        backgroundColor: backgroundColor,
        textColor: textColor,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isVisible = true;

    Future.delayed(duration, () {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isVisible = false;
    });
  }

  /// 显示成功提示
  static void success(BuildContext context, String message) {
    show(context, message, backgroundColor: Colors.green);
  }

  /// 显示错误提示
  static void error(BuildContext context, String message) {
    show(context, message, backgroundColor: Colors.red);
  }

  /// 显示警告提示
  static void warning(BuildContext context, String message) {
    show(context, message, backgroundColor: Colors.orange);
  }
}

/// Toast组件
class _ToastWidget extends StatefulWidget {
  final String message;
  final Color? backgroundColor;
  final Color? textColor;

  const _ToastWidget({
    required this.message,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.1,
      left: 32,
      right: 32,
      child: FadeTransition(
        opacity: _animation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.black87,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              widget.message,
              style: TextStyle(
                color: widget.textColor ?? Colors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

