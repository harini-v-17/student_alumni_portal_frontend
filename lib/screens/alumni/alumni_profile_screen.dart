import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/alumni_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/alumni_provider.dart';
import '../../utils/constants.dart';
import '../../utils/responsive.dart';

/// Full profile detail screen for a single alumni.
/// Reached by tapping an [AlumniCard] in AlumniDirectory.
///
/// Desktop: two-column layout (header left, details right).
/// Tablet/Mobile: single-column, standard scroll.
class AlumniProfileScreen extends StatelessWidget {
  final AlumniModel alumni;

  const AlumniProfileScreen({super.key, required this.alumni});

  @override
  Widget build(BuildContext context) {
    final domainInfo = getDomainInfo(alumni.domain);
    final domainColor = domainInfo?.color ?? AppColors.primary;
    final bool isGovt = _isGovernmentDomain(alumni.domain);
    final String orgLabel =
        isGovt ? 'Department / Organisation' : 'Company';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final r = Responsive(constraints.maxWidth);
          if (r.isDesktop) {
            return _DesktopProfileLayout(
              alumni: alumni,
              domainInfo: domainInfo,
              domainColor: domainColor,
              orgLabel: orgLabel,
            );
          }
          // Tablet + Mobile
          return _ScrollableProfileLayout(
            alumni: alumni,
            domainInfo: domainInfo,
            domainColor: domainColor,
            orgLabel: orgLabel,
            r: r,
          );
        },
      ),
    );
  }

  bool _isGovernmentDomain(String domain) {
    const govtDomains = {
      'UPSC',
      'TNPSC',
      'SSC',
      'Banking Exams',
      'Other Government Exams'
    };
    return govtDomains.contains(domain);
  }
}

// ─── Desktop two-column layout ────────────────────────────────────────────────
class _DesktopProfileLayout extends StatelessWidget {
  final AlumniModel alumni;
  final DomainInfo? domainInfo;
  final Color domainColor;
  final String orgLabel;

  const _DesktopProfileLayout({
    required this.alumni,
    required this.domainInfo,
    required this.domainColor,
    required this.orgLabel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // AppBar
        SliverAppBar(
          pinned: true,
          backgroundColor: domainColor,
          foregroundColor: Colors.white,
          title: Text(
            alumni.name,
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 17),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Left panel: avatar + key info ───────────────────────
                    SizedBox(
                      width: 300,
                      child: Column(
                        children: [
                          _ProfileHeaderCard(
                            alumni: alumni,
                            domainInfo: domainInfo,
                            domainColor: domainColor,
                            orgLabel: orgLabel,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 28),
                    // ── Right panel: bio + skills + button ──────────────────
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _AboutSection(
                              alumni: alumni,
                              domainInfo: domainInfo,
                              domainColor: domainColor),
                          const SizedBox(height: 24),
                          if (alumni.skills.isNotEmpty)
                            _SkillsSection(
                                alumni: alumni,
                                domainInfo: domainInfo,
                                domainColor: domainColor),
                          const SizedBox(height: 28),
                          _ConnectButton(
                              alumni: alumni, domainColor: domainColor),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Tablet/Mobile scrollable layout ─────────────────────────────────────────
class _ScrollableProfileLayout extends StatelessWidget {
  final AlumniModel alumni;
  final DomainInfo? domainInfo;
  final Color domainColor;
  final String orgLabel;
  final Responsive r;

  const _ScrollableProfileLayout({
    required this.alumni,
    required this.domainInfo,
    required this.domainColor,
    required this.orgLabel,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── Coloured header with avatar ──────────────────────────────────
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          backgroundColor: domainColor,
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    domainColor,
                    domainColor.withOpacity(0.78),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 48),
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white,
                    child: Text(
                      alumni.initials,
                      style: TextStyle(
                        color: domainColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    alumni.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${alumni.designation} · ${alumni.company}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Profile body ─────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: r.isTablet
                      ? Breakpoints.maxFormWidth
                      : double.infinity),
              child: Padding(
                padding: EdgeInsets.all(r.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Domain chip
                    _DomainChip(
                        alumni: alumni,
                        domainInfo: domainInfo,
                        domainColor: domainColor),
                    const SizedBox(height: 20),

                    // Info card
                    _InfoCard(
                      items: [
                        _InfoRow(
                          icon: Icons.business_rounded,
                          label: orgLabel,
                          value: alumni.company,
                        ),
                        _InfoRow(
                          icon: Icons.badge_rounded,
                          label: 'Designation',
                          value: alumni.designation,
                        ),
                        _InfoRow(
                          icon: Icons.school_rounded,
                          label: 'Batch',
                          value: 'Batch of ${alumni.batch}',
                        ),
                        _InfoRow(
                          icon: Icons.email_rounded,
                          label: 'Email',
                          value: alumni.email,
                          isEmail: true,
                          accentColor: domainColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _AboutSection(
                        alumni: alumni,
                        domainInfo: domainInfo,
                        domainColor: domainColor),

                    if (alumni.skills.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _SkillsSection(
                          alumni: alumni,
                          domainInfo: domainInfo,
                          domainColor: domainColor),
                    ],
                    const SizedBox(height: 28),

                    _ConnectButton(
                        alumni: alumni, domainColor: domainColor),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Desktop left-panel profile header card ───────────────────────────────────
class _ProfileHeaderCard extends StatelessWidget {
  final AlumniModel alumni;
  final DomainInfo? domainInfo;
  final Color domainColor;
  final String orgLabel;

  const _ProfileHeaderCard({
    required this.alumni,
    required this.domainInfo,
    required this.domainColor,
    required this.orgLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Coloured header band
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [domainColor, domainColor.withOpacity(0.78)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Text(
                    alumni.initials,
                    style: TextStyle(
                      color: domainColor,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  alumni.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alumni.designation,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 10),
                _DomainChip(
                  alumni: alumni,
                  domainInfo: domainInfo,
                  domainColor: domainColor,
                  isWhite: true,
                ),
              ],
            ),
          ),
          // Info rows
          _InfoCard(
            items: [
              _InfoRow(
                icon: Icons.business_rounded,
                label: orgLabel,
                value: alumni.company,
              ),
              _InfoRow(
                icon: Icons.badge_rounded,
                label: 'Designation',
                value: alumni.designation,
              ),
              _InfoRow(
                icon: Icons.school_rounded,
                label: 'Batch',
                value: 'Batch of ${alumni.batch}',
              ),
              _InfoRow(
                icon: Icons.email_rounded,
                label: 'Email',
                value: alumni.email,
                isEmail: true,
                accentColor: domainColor,
              ),
            ],
            rounded: false,
          ),
        ],
      ),
    );
  }
}

// ─── Domain Chip ──────────────────────────────────────────────────────────────
class _DomainChip extends StatelessWidget {
  final AlumniModel alumni;
  final DomainInfo? domainInfo;
  final Color domainColor;
  final bool isWhite;

  const _DomainChip({
    required this.alumni,
    required this.domainInfo,
    required this.domainColor,
    this.isWhite = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isWhite
        ? Colors.white.withOpacity(0.2)
        : (domainInfo?.lightColor ?? domainColor.withOpacity(0.1));
    final textColor = isWhite ? Colors.white : domainColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: isWhite
            ? Border.all(
                color: Colors.white.withOpacity(0.3), width: 1)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (domainInfo != null)
            Icon(domainInfo!.icon, size: 13, color: textColor),
          if (domainInfo != null) const SizedBox(width: 5),
          Flexible(
            child: Text(
              alumni.domain,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── About Section ────────────────────────────────────────────────────────────
class _AboutSection extends StatelessWidget {
  final AlumniModel alumni;
  final DomainInfo? domainInfo;
  final Color domainColor;

  const _AboutSection({
    required this.alumni,
    required this.domainInfo,
    required this.domainColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
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
          child: Text(
            alumni.bio,
            style: const TextStyle(
              fontSize: 13.5,
              color: AppColors.textSecondary,
              height: 1.65,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Skills Section ───────────────────────────────────────────────────────────
class _SkillsSection extends StatelessWidget {
  final AlumniModel alumni;
  final DomainInfo? domainInfo;
  final Color domainColor;

  const _SkillsSection({
    required this.alumni,
    required this.domainInfo,
    required this.domainColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Skills & Expertise',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: alumni.skills
              .map(
                (skill) => Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: domainInfo?.lightColor ??
                        domainColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: domainColor.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      fontSize: 12,
                      color: domainColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

// ─── Connect Button ───────────────────────────────────────────────────────────
class _ConnectButton extends StatelessWidget {
  final AlumniModel alumni;
  final Color domainColor;

  const _ConnectButton({required this.alumni, required this.domainColor});

  void _showConnectDialog(BuildContext context) {
    final authUser = context.read<AuthProvider>().currentUser;
    final topicCtrl =
        TextEditingController(text: 'Career Advice & Mentorship');
    final messageCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: domainColor.withOpacity(0.12),
                      child: Text(
                        alumni.initials,
                        style: TextStyle(
                          color: domainColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Connect with ${alumni.name}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${alumni.designation} · ${alumni.company}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'Topic / Purpose',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: topicCtrl.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Career Advice & Mentorship',
                      child: Text('Career Advice & Mentorship'),
                    ),
                    DropdownMenuItem(
                      value: 'Resume Review',
                      child: Text('Resume Review'),
                    ),
                    DropdownMenuItem(
                      value: 'Mock Interview Prep',
                      child: Text('Mock Interview Prep'),
                    ),
                    DropdownMenuItem(
                      value: 'Job Referral Query',
                      child: Text('Job Referral Query'),
                    ),
                    DropdownMenuItem(
                      value: 'General Networking',
                      child: Text('General Networking'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) topicCtrl.text = v;
                  },
                ),
                const SizedBox(height: 14),
                const Text(
                  'Message',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: messageCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText:
                        'Introduce yourself and describe how they can help you...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please write a brief message'
                      : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      final senderName =
                          authUser?.name ?? 'Student / Alumni';
                      final senderEmail =
                          authUser?.email ?? 'user@university.edu';
                      final senderBatch =
                          authUser?.batch.isNotEmpty == true
                              ? authUser!.batch
                              : '2025';

                      context.read<AlumniProvider>().sendMentorshipQuery(
                            studentName: senderName,
                            studentEmail: senderEmail,
                            studentBatch: senderBatch,
                            topic: topicCtrl.text,
                            message: messageCtrl.text.trim(),
                          );

                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle_outline,
                                  color: Colors.white, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                    'Connection request sent to ${alumni.name}!'),
                              ),
                            ],
                          ),
                          backgroundColor: domainColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: domainColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text('Send Request',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showConnectDialog(context),
        icon: const Icon(Icons.connect_without_contact_rounded, size: 18),
        label: const Text('Connect with Alumni'),
        style: ElevatedButton.styleFrom(
          backgroundColor: domainColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ─── Info Card ─────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final List<_InfoRow> items;
  final bool rounded;

  const _InfoCard({required this.items, this.rounded = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius:
            rounded ? BorderRadius.circular(12) : BorderRadius.zero,
        boxShadow: rounded
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        children: items
            .asMap()
            .entries
            .map(
              (e) => Column(
                children: [
                  e.value,
                  if (e.key < items.length - 1)
                    const Divider(
                        height: 1,
                        indent: 48,
                        color: AppColors.divider),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

// ─── Info Row ──────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isEmail;
  final Color? accentColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isEmail = false,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              size: 18, color: accentColor ?? AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: isEmail
                        ? (accentColor ?? AppColors.primary)
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
