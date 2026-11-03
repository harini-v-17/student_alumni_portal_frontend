import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// A compact, horizontally scrollable domain card for the Student Dashboard.
/// Displays an icon and the domain name. Tapping triggers [onTap].
class DomainCard extends StatelessWidget {
  final DomainInfo domain;
  final VoidCallback onTap;

  const DomainCard({
    super.key,
    required this.domain,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: domain.color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Thin accent bar at top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(height: 3, color: domain.color),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon in soft rounded square
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: domain.lightColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(domain.icon,
                          color: domain.color, size: 20),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      domain.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'View',
                          style: TextStyle(
                            fontSize: 11,
                            color: domain.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(Icons.arrow_forward_rounded,
                            size: 11, color: domain.color),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
