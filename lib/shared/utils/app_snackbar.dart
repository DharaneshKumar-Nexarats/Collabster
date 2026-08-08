import 'package:flutter/material.dart';

enum SnackBarType { success, error, info }

class AppSnackBar {
  /// Displays a floating professional SnackBar.
  /// Automatically clears any previously queued SnackBars to prevent stacking/repeating.
  static void show(
    BuildContext context,
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    showWithMessenger(messenger, message, type: type, duration: duration);
  }

  /// Displays a floating professional SnackBar using an explicit [ScaffoldMessengerState].
  static void showWithMessenger(
    ScaffoldMessengerState messenger,
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Clear all existing and queued snackbars to prevent repeating
    messenger.clearSnackBars();

    Color bgColor;
    Color borderColor;
    IconData icon;
    Color iconColor;

    switch (type) {
      case SnackBarType.error:
        bgColor = const Color(0xFF991B1B); // Deep rich red
        borderColor = const Color(0xFFEF4444);
        icon = Icons.error_outline_rounded;
        iconColor = const Color(0xFFFCA5A5);
        break;
      case SnackBarType.success:
        bgColor = const Color(0xFF065F46); // Deep rich green
        borderColor = const Color(0xFF10B981);
        icon = Icons.check_circle_outline_rounded;
        iconColor = const Color(0xFF6EE7B7);
        break;
      case SnackBarType.info:
        bgColor = const Color(0xFF1E1B4B); // Deep indigo/slate
        borderColor = const Color(0xFF6366F1);
        icon = Icons.info_outline_rounded;
        iconColor = const Color(0xFFA5B4FC);
        break;
    }

    messenger.showSnackBar(
      SnackBar(
        elevation: 8,
        behavior: SnackBarBehavior.floating,
        backgroundColor: bgColor,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor.withValues(alpha: 0.35), width: 1),
        ),
        duration: duration,
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    show(context, message, type: SnackBarType.error);
  }

  static void showSuccess(BuildContext context, String message) {
    show(context, message, type: SnackBarType.success);
  }

  static void showInfo(BuildContext context, String message) {
    show(context, message, type: SnackBarType.info);
  }
}
