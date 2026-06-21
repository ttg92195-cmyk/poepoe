import 'package:flutter/material.dart';

/// Centralized color palette for PoePoe Chat.
/// Uses Material 3 seed-color approach for automatic tonal palettes.
class AppColors {
  AppColors._();

  /// Brand seed color (deep violet). Material 3 will derive tonal palettes.
  static const Color seed = Color(0xFF6C4EE3);

  /// Accent used for "send" buttons and unread badges.
  static const Color accent = Color(0xFFFF7A59);

  /// Bubble colors for the chat room (light theme).
  static const Color myBubbleLight = Color(0xFF6C4EE3);
  static const Color peerBubbleLight = Color(0xFFF1F1F4);

  /// Bubble colors for the chat room (dark theme).
  static const Color myBubbleDark = Color(0xFF8B6BFF);
  static const Color peerBubbleDark = Color(0xFF2A2A2E);

  /// Online indicator dot.
  static const Color online = Color(0xFF34C759);

  /// Delivered / read check marks.
  static const Color read = Color(0xFF4FA8FF);
}
