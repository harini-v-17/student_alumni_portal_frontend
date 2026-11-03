import 'package:flutter/material.dart';
import '../models/alumni_model.dart';
import '../utils/constants.dart';

/// A card that displays a brief summary of an alumni profile.
/// Tapping it triggers [onTap] to open the full profile screen.
///
/// [compact] mode removes the outer margin so the card works inside
/// a GridView cell without double-spacing.
class AlumniCard extends StatelessWidget {
  final AlumniModel alumni;
  final VoidCallback onTap;
  /// When true the card fills its parent (for GridView cells).
  /// When false (default) horizontal/vertical margin is applied.
  final bool compact;

  const AlumniCard({
    super.key,
    required this.alumni,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final domainInfo = getDomainInfo(alumni.domain);
    final domainColor = domainInfo?.color ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: compact
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Avatar with initials
              CircleAvatar(
                radius: 24,
                backgroundColor: domainColor,
                child: Text(
                  alumni.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Name + designation + company + domain chip
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      alumni.name,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      alumni.designation,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.business_rounded,
                            size: 11, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${alumni.company} · ${alumni.batch}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    // Domain chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: domainInfo?.lightColor ??
                            AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        alumni.domain,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: domainColor,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textSecondary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
