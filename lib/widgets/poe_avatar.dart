import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Circular avatar with online indicator dot.
class PoeAvatar extends StatelessWidget {
  const PoeAvatar({
    super.key,
    this.url,
    this.name = '?',
    this.size = 48,
    this.isOnline = false,
    this.showOnline = true,
  });

  final String? url;
  final String name;
  final double size;
  final bool isOnline;
  final bool showOnline;

  @override
  Widget build(BuildContext context) {
    final fallback = 'https://ui-avatars.com/api/?background=random&size=${(size * 2).toInt()}&name=${Uri.encodeComponent(name)}';
    final src = (url == null || url!.isEmpty) ? fallback : url;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: CachedNetworkImage(
            imageUrl: src,
            width: size,
            height: size,
            fit: BoxFit.cover,
            placeholder: (context, _) => Container(
              width: size,
              height: size,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            errorWidget: (context, _, __) => Container(
              width: size,
              height: size,
              color: Theme.of(context).colorScheme.primaryContainer,
              alignment: Alignment.center,
              child: Text(
                name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?',
                style: TextStyle(
                  fontSize: size * 0.42,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ),
        if (showOnline && isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: const Color(0xFF34C759),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
