import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/alumni_provider.dart';
import '../../utils/constants.dart';
import '../../utils/responsive.dart';
import '../../models/alumni_model.dart';
import '../alumni/alumni_profile_screen.dart';
import '../alumni/alumni_directory.dart';
import '../auth/alumni_login_screen.dart';
import '../welcome/welcome_screen.dart';

/// Alumni Dashboard — the full central workspace for logged-in Alumni.
///
/// Provides:
///  • Protected authentication session guard (redirects if not logged in).
///  • Clean, reliable Alumni Logout (clears session and returns to Alumni Login).
///  • Multi-tab navigation: Overview, Alumni Network, Student Mentorship Queries,
///    Job Postings, and My Profile.
///  • Live interaction: edit profile, respond to student mentorship queries,
///    and publish internship/job opportunities.
class AlumniDashboardScreen extends StatefulWidget {
  const AlumniDashboardScreen({super.key});

  @override
  State<AlumniDashboardScreen> createState() => _AlumniDashboardScreenState();
}

class _AlumniDashboardScreenState extends State<AlumniDashboardScreen> {
  int _navIndex = 0;

  void _handleLogout() {
    // 1. Immediately clear the Alumni login session and authentication state
    context.read<AuthProvider>().logoutAlumni();

    // 2. Navigate directly to the first page (Student / Alumni Login Selection Page)
    // 3. Reset the navigation history so pressing Back cannot reopen the Alumni Dashboard
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  void _showEditProfileDialog(AuthUser user) {
    final nameCtrl = TextEditingController(text: user.name);
    final desigCtrl = TextEditingController(text: user.designation);
    final compCtrl = TextEditingController(text: user.company);
    final batchCtrl = TextEditingController(text: user.batch);
    final emailCtrl = TextEditingController(text: user.email);
    String selectedDomain = user.domain.isNotEmpty ? user.domain : 'Full Stack Development';
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
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
              child: SingleChildScrollView(
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
                      children: const [
                        Icon(Icons.edit_note_rounded, color: AppColors.accent, size: 24),
                        SizedBox(width: 10),
                        Text(
                          'Edit Alumni Profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFieldLabel('Full Name'),
                    TextFormField(
                      controller: nameCtrl,
                      decoration: _inputDeco('Enter your name'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel('Designation / Role'),
                    TextFormField(
                      controller: desigCtrl,
                      decoration: _inputDeco('e.g. Senior Software Engineer'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Designation is required' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel('Company / Organisation'),
                    TextFormField(
                      controller: compCtrl,
                      decoration: _inputDeco('e.g. Microsoft'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Organisation is required' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel('Specialisation Domain'),
                    DropdownButtonFormField<String>(
                      value: kDomains.any((d) => d.name == selectedDomain) ? selectedDomain : kDomains.first.name,
                      isExpanded: true,
                      decoration: _inputDeco(''),
                      items: kDomains.map((d) => DropdownMenuItem(value: d.name, child: Text(d.name, overflow: TextOverflow.ellipsis))).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setSheetState(() => selectedDomain = val);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Batch Year'),
                              TextFormField(
                                controller: batchCtrl,
                                decoration: _inputDeco('e.g. 2020'),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'Batch is required' : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Email Address'),
                              TextFormField(
                                controller: emailCtrl,
                                decoration: _inputDeco('alumni@example.com'),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'Email is required' : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;
                          context.read<AuthProvider>().updateAlumniProfile(
                                name: nameCtrl.text.trim(),
                                designation: desigCtrl.text.trim(),
                                company: compCtrl.text.trim(),
                                domain: selectedDomain,
                                batch: batchCtrl.text.trim(),
                                email: emailCtrl.text.trim(),
                              );
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile updated successfully!'),
                              backgroundColor: AppColors.accent,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: const Text('Save Profile Changes', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPostOpportunityDialog(AuthUser user) {
    final titleCtrl = TextEditingController();
    final compCtrl = TextEditingController(text: user.company);
    final locCtrl = TextEditingController(text: 'Bengaluru / Hybrid');
    final descCtrl = TextEditingController();
    final emailCtrl = TextEditingController(text: user.email);
    String selectedType = 'Full-time';
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
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
              child: SingleChildScrollView(
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
                      children: const [
                        Icon(Icons.add_business_rounded, color: AppColors.accent, size: 24),
                        SizedBox(width: 10),
                        Text(
                          'Post Job or Internship',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFieldLabel('Opportunity Title'),
                    TextFormField(
                      controller: titleCtrl,
                      decoration: _inputDeco('e.g. Associate Software Engineer'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Company Name'),
                              TextFormField(
                                controller: compCtrl,
                                decoration: _inputDeco('Company name'),
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Job Type'),
                              DropdownButtonFormField<String>(
                                value: selectedType,
                                isExpanded: true,
                                decoration: _inputDeco(''),
                                items: const [
                                  DropdownMenuItem(value: 'Full-time', child: Text('Full-time')),
                                  DropdownMenuItem(value: 'Internship', child: Text('Internship')),
                                  DropdownMenuItem(value: 'Contract', child: Text('Contract')),
                                  DropdownMenuItem(value: 'Remote', child: Text('Remote')),
                                ],
                                onChanged: (v) {
                                  if (v != null) setSheetState(() => selectedType = v);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel('Location / Work Mode'),
                    TextFormField(
                      controller: locCtrl,
                      decoration: _inputDeco('e.g. Bengaluru / Hybrid or Remote'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Location is required' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel('Description & Requirements'),
                    TextFormField(
                      controller: descCtrl,
                      maxLines: 3,
                      decoration: _inputDeco('Details about skills, requirements, and eligibility...'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Description is required' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel('Contact / Application Email'),
                    TextFormField(
                      controller: emailCtrl,
                      decoration: _inputDeco('Email for resumes'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Email is required' : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;
                          final newJob = JobOpportunity(
                            id: 'job_${DateTime.now().millisecondsSinceEpoch}',
                            title: titleCtrl.text.trim(),
                            company: compCtrl.text.trim(),
                            location: locCtrl.text.trim(),
                            type: selectedType,
                            description: descCtrl.text.trim(),
                            postedBy: user.name,
                            postedDate: 'Just now',
                            contactEmail: emailCtrl.text.trim(),
                          );
                          context.read<AlumniProvider>().addJobOpportunity(newJob);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Opportunity "${newJob.title}" posted successfully!'),
                              backgroundColor: AppColors.accent,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: const Text('Publish Opportunity', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      );

  InputDecoration _inputDeco(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    // ── Session Guard ────────────────────────────────────────────────────────
    // If not authenticated or not alumni, immediately prevent dashboard access.
    if (!auth.isLoggedIn || user == null || user.role != UserRole.alumni) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            (route) => false,
          );
        }
      });
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    final domainInfo = getDomainInfo(user.domain);
    final domainColor = domainInfo?.color ?? AppColors.accent;

    return LayoutBuilder(
      builder: (context, constraints) {
        final r = Responsive(constraints.maxWidth);

        Widget currentBody;
        switch (_navIndex) {
          case 0:
            currentBody = _OverviewTab(
              user: user,
              domainInfo: domainInfo,
              domainColor: domainColor,
              r: r,
              onSwitchTab: (idx) => setState(() => _navIndex = idx),
              onEditProfile: () => _showEditProfileDialog(user),
              onPostJob: () => _showPostOpportunityDialog(user),
            );
            break;
          case 1:
            currentBody = const _AlumniDirectoryTab();
            break;
          case 2:
            currentBody = _MentorshipQueriesTab(domainColor: domainColor);
            break;
          case 3:
            currentBody = _OpportunitiesTab(
              user: user,
              domainColor: domainColor,
              onPostJob: () => _showPostOpportunityDialog(user),
            );
            break;
          case 4:
            currentBody = _MyProfileTab(
              user: user,
              domainInfo: domainInfo,
              domainColor: domainColor,
              r: r,
              onEditProfile: () => _showEditProfileDialog(user),
            );
            break;
          default:
            currentBody = const SizedBox.shrink();
        }

        // ── Desktop Layout with Permanent Sidebar ───────────────────────────
        if (r.isDesktop) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Row(
              children: [
                _DesktopSidebar(
                  user: user,
                  selectedIndex: _navIndex,
                  onSelectIndex: (idx) => setState(() => _navIndex = idx),
                  onLogout: _handleLogout,
                  domainColor: domainColor,
                ),
                Expanded(child: currentBody),
              ],
            ),
          );
        }

        // ── Tablet Layout with NavigationRail ────────────────────────────────
        if (r.isTablet) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: const Text(
                'Alumni Portal',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, size: 20),
                  tooltip: 'Logout',
                  onPressed: _handleLogout,
                ),
              ],
            ),
            body: Row(
              children: [
                NavigationRail(
                  backgroundColor: AppColors.accent,
                  selectedIndex: _navIndex,
                  onDestinationSelected: (idx) => setState(() => _navIndex = idx),
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: const IconThemeData(color: Colors.white, size: 22),
                  unselectedIconTheme: IconThemeData(color: Colors.white.withOpacity(0.55), size: 22),
                  selectedLabelTextStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                  unselectedLabelTextStyle: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 11),
                  indicatorColor: Colors.white.withOpacity(0.18),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard_rounded),
                      label: Text('Overview'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.people_outline),
                      selectedIcon: Icon(Icons.people_rounded),
                      label: Text('Directory'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.question_answer_outlined),
                      selectedIcon: Icon(Icons.question_answer_rounded),
                      label: Text('Mentorship'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.work_outline),
                      selectedIcon: Icon(Icons.work_rounded),
                      label: Text('Jobs'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: Text('Profile'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1, thickness: 1, color: AppColors.divider),
                Expanded(child: currentBody),
              ],
            ),
          );
        }

        // ── Mobile Layout with Bottom Navigation ─────────────────────────────
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              _navIndex == 0
                  ? 'Alumni Portal'
                  : _navIndex == 1
                      ? 'Alumni Directory'
                      : _navIndex == 2
                          ? 'Mentorship Queries'
                          : _navIndex == 3
                              ? 'Job Opportunities'
                              : 'My Profile',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, size: 20),
                tooltip: 'Logout',
                onPressed: _handleLogout,
              ),
            ],
          ),
          body: currentBody,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _navIndex,
            onTap: (idx) => setState(() => _navIndex = idx),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.accent,
            unselectedItemColor: AppColors.textSecondary,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard_rounded),
                label: 'Overview',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people_rounded),
                label: 'Directory',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.question_answer_outlined),
                activeIcon: Icon(Icons.question_answer_rounded),
                label: 'Mentorship',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work_outline),
                activeIcon: Icon(Icons.work_rounded),
                label: 'Jobs',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Desktop Sidebar ──────────────────────────────────────────────────────────
class _DesktopSidebar extends StatelessWidget {
  final AuthUser user;
  final int selectedIndex;
  final ValueChanged<int> onSelectIndex;
  final VoidCallback onLogout;
  final Color domainColor;

  const _DesktopSidebar({
    required this.user,
    required this.selectedIndex,
    required this.onSelectIndex,
    required this.onLogout,
    required this.domainColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: AppColors.accent,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Alumni Portal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withOpacity(0.18), height: 28),

            // Navigation Items
            _SidebarNavTile(
              icon: Icons.dashboard_rounded,
              label: 'Overview',
              isSelected: selectedIndex == 0,
              onTap: () => onSelectIndex(0),
            ),
            _SidebarNavTile(
              icon: Icons.people_alt_rounded,
              label: 'Alumni Network',
              isSelected: selectedIndex == 1,
              onTap: () => onSelectIndex(1),
            ),
            Consumer<AlumniProvider>(
              builder: (_, p, __) => _SidebarNavTile(
                icon: Icons.question_answer_rounded,
                label: 'Mentorship Queries',
                isSelected: selectedIndex == 2,
                badgeCount: p.mentorshipQueries.where((q) => q.status == 'Pending').length,
                onTap: () => onSelectIndex(2),
              ),
            ),
            _SidebarNavTile(
              icon: Icons.work_rounded,
              label: 'Job Postings',
              isSelected: selectedIndex == 3,
              onTap: () => onSelectIndex(3),
            ),
            _SidebarNavTile(
              icon: Icons.account_circle_rounded,
              label: 'My Profile',
              isSelected: selectedIndex == 4,
              onTap: () => onSelectIndex(4),
            ),

            const Spacer(),

            // Logged in user chip
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'A',
                      style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          user.company.isNotEmpty ? user.company : 'Alumni Member',
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: Colors.white.withOpacity(0.18), height: 1),
            _SidebarNavTile(
              icon: Icons.logout_rounded,
              label: 'Log Out',
              isSelected: false,
              isDestructive: true,
              onTap: onLogout,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _SidebarNavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? badgeCount;
  final bool isDestructive;

  const _SidebarNavTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badgeCount,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDestructive
                  ? Colors.red.shade200
                  : isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.7),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isDestructive
                      ? Colors.red.shade200
                      : isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.7),
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (badgeCount != null && badgeCount! > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── TAB 0: OVERVIEW TAB ──────────────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  final AuthUser user;
  final DomainInfo? domainInfo;
  final Color domainColor;
  final Responsive r;
  final ValueChanged<int> onSwitchTab;
  final VoidCallback onEditProfile;
  final VoidCallback onPostJob;

  const _OverviewTab({
    required this.user,
    required this.domainInfo,
    required this.domainColor,
    required this.r,
    required this.onSwitchTab,
    required this.onEditProfile,
    required this.onPostJob,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero Banner ────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            color: AppColors.accent,
            padding: EdgeInsets.fromLTRB(
              r.isDesktop ? 36 : 20,
              20,
              r.isDesktop ? 36 : 20,
              28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: r.isDesktop ? 36 : 28,
                      backgroundColor: Colors.white,
                      child: Text(
                        _initials(user.name),
                        style: TextStyle(
                          color: domainColor,
                          fontSize: r.isDesktop ? 22 : 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                          ),
                          Text(
                            user.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: r.isDesktop ? 24 : 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              if (user.domain.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (domainInfo != null) ...[
                                        Icon(domainInfo!.icon, size: 12, color: Colors.white),
                                        const SizedBox(width: 5),
                                      ],
                                      Flexible(
                                        child: Text(
                                          user.domain,
                                          style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (user.company.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    user.company,
                                    style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              if (user.batch.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Batch of ${user.batch}',
                                    style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Quick Action Bar
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      onPressed: onEditProfile,
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.accent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => onSwitchTab(1),
                      icon: const Icon(Icons.people_alt, size: 16),
                      label: const Text('Browse Directory'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.18),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: onPostJob,
                      icon: const Icon(Icons.add_circle_outline, size: 16),
                      label: const Text('Post Opportunity'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.18),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Main Content Area ──────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(r.isDesktop ? 32 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Network Overview Stats
                Row(
                  children: const [
                    Expanded(
                      child: _StatWidget(
                        label: 'Total Alumni',
                        value: '1,200+',
                        icon: Icons.people_rounded,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _StatWidget(
                        label: 'Domains',
                        value: '13',
                        icon: Icons.grid_view_rounded,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _StatWidget(
                        label: 'Batches',
                        value: '10+',
                        icon: Icons.calendar_today_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Student Mentorship Requests Card
                Consumer<AlumniProvider>(
                  builder: (ctx, p, _) {
                    final queries = p.mentorshipQueries;
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.question_answer_rounded, color: AppColors.accent, size: 20),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Mentorship Queries',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: AppColors.accentLight, borderRadius: BorderRadius.circular(12)),
                                child: Text(
                                  '${queries.length} total',
                                  style: const TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 4),
                              TextButton(
                                onPressed: () => onSwitchTab(2),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  visualDensity: VisualDensity.compact,
                                ),
                                child: const Text('View All', style: TextStyle(color: AppColors.accent, fontSize: 12.5)),
                              ),
                            ],
                          ),
                          const Divider(height: 20, color: AppColors.divider),
                          if (queries.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text('No student queries at the moment.', style: TextStyle(color: AppColors.textSecondary)),
                            )
                          else
                            ...queries.take(2).map(
                                  (q) => _QueryMiniCard(
                                    query: q,
                                    onAccept: () => p.updateQueryStatus(q.id, 'Accepted'),
                                    onComplete: () => p.updateQueryStatus(q.id, 'Completed'),
                                  ),
                                ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Job Postings Preview
                Consumer<AlumniProvider>(
                  builder: (ctx, p, _) {
                    final jobs = p.jobOpportunities;
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.work_rounded, color: AppColors.accent, size: 20),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Opportunities & Jobs',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () => onSwitchTab(3),
                                child: const Text('View All', style: TextStyle(color: AppColors.accent, fontSize: 12.5)),
                              ),
                            ],
                          ),
                          const Divider(height: 20, color: AppColors.divider),
                          ...jobs.take(2).map((j) => _OpportunityMiniCard(job: j)),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts.isNotEmpty && parts[0].isNotEmpty ? parts[0][0].toUpperCase() : 'A';
  }
}

// ─── TAB 1: ALUMNI DIRECTORY TAB ──────────────────────────────────────────────
class _AlumniDirectoryTab extends StatelessWidget {
  const _AlumniDirectoryTab();

  @override
  Widget build(BuildContext context) {
    return const AlumniDirectory(initialDomain: 'All');
  }
}

// ─── TAB 2: MENTORSHIP QUERIES TAB ────────────────────────────────────────────
class _MentorshipQueriesTab extends StatelessWidget {
  final Color domainColor;

  const _MentorshipQueriesTab({required this.domainColor});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AlumniProvider>();
    final queries = p.mentorshipQueries;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.question_answer_rounded, color: AppColors.accent, size: 24),
              const SizedBox(width: 10),
              const Text(
                'Student Mentorship Queries',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.accentLight, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  '${queries.length} Requests',
                  style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Respond to students seeking career advice, mock interviews, or resume reviews.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          if (queries.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('No mentorship queries found.'),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: queries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (ctx, i) {
                final q = queries[i];
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.accent.withOpacity(0.12),
                            child: Text(
                              q.studentName.isNotEmpty ? q.studentName[0].toUpperCase() : 'S',
                              style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  q.studentName,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.textPrimary),
                                ),
                                Text(
                                  '${q.studentEmail} · Batch ${q.studentBatch}',
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          _StatusBadge(status: q.status),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              q.topic,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              q.message,
                              style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (q.status == 'Pending') ...[
                            OutlinedButton.icon(
                              onPressed: () {
                                p.updateQueryStatus(q.id, 'Declined');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Query declined.')),
                                );
                              },
                              icon: const Icon(Icons.close, size: 14),
                              label: const Text('Decline'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red.shade600,
                                side: BorderSide(color: Colors.red.shade300),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () {
                                p.updateQueryStatus(q.id, 'Accepted');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Accepted query from ${q.studentName}! You can now contact them via ${q.studentEmail}.'),
                                    backgroundColor: AppColors.accent,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.check, size: 14),
                              label: const Text('Accept & Connect'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ] else if (q.status == 'Accepted') ...[
                            ElevatedButton.icon(
                              onPressed: () {
                                p.updateQueryStatus(q.id, 'Completed');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Marked mentorship session as completed.')),
                                );
                              },
                              icon: const Icon(Icons.done_all, size: 14),
                              label: const Text('Mark Completed'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ] else ...[
                            Text(
                              'Completed on ${q.requestedDate}',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ─── TAB 3: OPPORTUNITIES TAB ─────────────────────────────────────────────────
class _OpportunitiesTab extends StatelessWidget {
  final AuthUser user;
  final Color domainColor;
  final VoidCallback onPostJob;

  const _OpportunitiesTab({
    required this.user,
    required this.domainColor,
    required this.onPostJob,
  });

  @override
  Widget build(BuildContext context) {
    final jobs = context.watch<AlumniProvider>().jobOpportunities;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.work_rounded, color: AppColors.accent, size: 24),
              const SizedBox(width: 10),
              const Text(
                'Alumni Job & Internship Board',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: onPostJob,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Post New Job'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Share career openings, internships, and entry-level positions with college students.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: jobs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (ctx, i) {
              final job = jobs[i];
              return Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.accentLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.business_center_rounded, color: AppColors.accent, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job.title,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${job.company} · ${job.location}',
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: job.type == 'Internship' ? Colors.orange.shade50 : AppColors.accentLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: job.type == 'Internship' ? Colors.orange.shade300 : AppColors.accent.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            job.type,
                            style: TextStyle(
                              color: job.type == 'Internship' ? Colors.orange.shade800 : AppColors.accent,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      job.description,
                      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Posted by ${job.postedBy} · ${job.postedDate}',
                          style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Contact email: ${job.contactEmail} (Application details copied)'),
                                backgroundColor: AppColors.accent,
                              ),
                            );
                          },
                          icon: const Icon(Icons.send_rounded, size: 14),
                          label: const Text('Contact Recruiter'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── TAB 4: MY PROFILE TAB ────────────────────────────────────────────────────
class _MyProfileTab extends StatelessWidget {
  final AuthUser user;
  final DomainInfo? domainInfo;
  final Color domainColor;
  final Responsive r;
  final VoidCallback onEditProfile;

  const _MyProfileTab({
    required this.user,
    required this.domainInfo,
    required this.domainColor,
    required this.r,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(r.isDesktop ? 32 : 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Breakpoints.maxFormWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3)),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: domainColor.withOpacity(0.12),
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : 'A',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: domainColor),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${user.designation} · ${user.company}',
                      style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: domainInfo?.lightColor ?? domainColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: domainColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        user.domain,
                        style: TextStyle(color: domainColor, fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: onEditProfile,
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit Profile Details'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Details List
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    _DetailRow(icon: Icons.badge_rounded, label: 'Designation', value: user.designation),
                    const Divider(height: 1, indent: 48, color: AppColors.divider),
                    _DetailRow(icon: Icons.business_rounded, label: 'Organisation', value: user.company),
                    const Divider(height: 1, indent: 48, color: AppColors.divider),
                    _DetailRow(icon: Icons.school_rounded, label: 'Batch', value: 'Batch of ${user.batch}'),
                    const Divider(height: 1, indent: 48, color: AppColors.divider),
                    _DetailRow(icon: Icons.email_rounded, label: 'Email Address', value: user.email, isEmail: true),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // View As Student Sees It
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    final synthetic = AlumniModel(
                      id: 'auth_user',
                      name: user.name,
                      domain: user.domain,
                      company: user.company,
                      designation: user.designation,
                      batch: user.batch,
                      email: user.email,
                      bio: 'Alumni mentor registered on the University Alumni Portal.',
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AlumniProfileScreen(alumni: synthetic)),
                    );
                  },
                  icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                  label: const Text('Preview Public Profile'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: const BorderSide(color: AppColors.accent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Small Reusable Widgets ───────────────────────────────────────────────────

class _StatWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatWidget({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: AppColors.accent),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg = AppColors.accentLight;
    Color fg = AppColors.accent;

    if (status == 'Accepted') {
      bg = Colors.green.shade50;
      fg = Colors.green.shade700;
    } else if (status == 'Completed') {
      bg = Colors.blue.shade50;
      fg = Colors.blue.shade700;
    } else if (status == 'Declined') {
      bg = Colors.red.shade50;
      fg = Colors.red.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(
        status,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _QueryMiniCard extends StatelessWidget {
  final MentorshipQuery query;
  final VoidCallback onAccept;
  final VoidCallback onComplete;

  const _QueryMiniCard({
    required this.query,
    required this.onAccept,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      query.studentName,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(status: query.status),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  query.topic,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (query.status == 'Pending')
            TextButton(
              onPressed: onAccept,
              child: const Text('Accept', style: TextStyle(color: AppColors.accent, fontSize: 12)),
            ),
        ],
      ),
    );
  }
}

class _OpportunityMiniCard extends StatelessWidget {
  final JobOpportunity job;

  const _OpportunityMiniCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.business_rounded, color: AppColors.accent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary),
                ),
                Text(
                  '${job.company} · ${job.type}',
                  style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isEmail;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isEmail = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : '—',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isEmail ? AppColors.accent : AppColors.textPrimary,
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
