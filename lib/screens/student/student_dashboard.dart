import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/alumni_provider.dart';
import '../../utils/constants.dart';
import '../../utils/responsive.dart';
import '../../widgets/alumni_card.dart';
import '../../widgets/domain_card.dart';
import '../alumni/alumni_directory.dart';
import '../welcome/welcome_screen.dart';

// ─── Models for Student Features ──────────────────────────────────────────────

class StudyResource {
  final String title;
  final String domain;
  final String type;
  final String description;
  final List<String> topics;
  final IconData icon;
  final Color color;

  const StudyResource({
    required this.title,
    required this.domain,
    required this.type,
    required this.description,
    required this.topics,
    required this.icon,
    required this.color,
  });
}

class PlacementGuide {
  final String title;
  final String category;
  final String subtitle;
  final String tips;
  final List<String> checklist;
  final IconData icon;
  final Color color;

  const PlacementGuide({
    required this.title,
    required this.category,
    required this.subtitle,
    required this.tips,
    required this.checklist,
    required this.icon,
    required this.color,
  });
}

class CampusAnnouncement {
  final String id;
  final String title;
  final String date;
  final String category;
  final String description;
  final IconData icon;

  const CampusAnnouncement({
    required this.id,
    required this.title,
    required this.date,
    required this.category,
    required this.description,
    required this.icon,
  });
}

// ─── Static Sample Data ───────────────────────────────────────────────────────

const List<StudyResource> kSampleStudyResources = [
  StudyResource(
    title: 'Full Stack Web Development Roadmap',
    domain: 'Full Stack Development',
    type: 'Curated Roadmap',
    description:
        'Step-by-step career pathway from HTML/CSS/JavaScript fundamentals to React, Node.js, REST APIs, databases, and containerization.',
    topics: [
      'HTML5, Modern CSS & Tailwind',
      'JavaScript ES6+ & TypeScript',
      'React Components & State Management',
      'Node.js, Express & REST APIs',
      'PostgreSQL, MongoDB & Prisma ORM',
      'Git, Docker & CI/CD Pipelines'
    ],
    icon: Icons.code_rounded,
    color: Color(0xFF6A1B9A),
  ),
  StudyResource(
    title: 'Data Science & Machine Learning Handbook',
    domain: 'Data Science',
    type: 'Study Guide',
    description:
        'Comprehensive guide covering Python data libraries, exploratory data analysis, classic ML algorithms, and deep learning foundations.',
    topics: [
      'NumPy, Pandas & Data Wrangling',
      'Data Visualisation with Matplotlib & Seaborn',
      'Supervised & Unsupervised ML Algorithms',
      'Feature Engineering & Model Evaluation',
      'Introduction to PyTorch & Transformers'
    ],
    icon: Icons.analytics_rounded,
    color: Color(0xFF7C3AED),
  ),
  StudyResource(
    title: 'Cloud Architecture & AWS Essentials',
    domain: 'Cloud Computing',
    type: 'Technical Guide',
    description:
        'Hands-on reference for core AWS services, cloud security, serverless compute, and Infrastructure as Code.',
    topics: [
      'AWS IAM, Security & Best Practices',
      'Compute with EC2, ECS & Lambda',
      'Storage with S3 & EBS',
      'Virtual Private Cloud (VPC) Networking',
      'Terraform & CloudFormation Basics'
    ],
    icon: Icons.cloud_rounded,
    color: Color(0xFF00838F),
  ),
  StudyResource(
    title: 'Civil Services & UPSC Examination Blueprint',
    domain: 'UPSC',
    type: 'Exam Strategy',
    description:
        'Guidance on prelims GS syllabus, mains structured answer-writing, essay crafting, and optional subject planning.',
    topics: [
      'Indian Polity & Governance',
      'History, Culture & Geography',
      'Economy & Sustainable Development',
      'Ethics, Integrity & Aptitude',
      'Mains Answer Structure & Timed Practice'
    ],
    icon: Icons.account_balance_rounded,
    color: Color(0xFF1565C0),
  ),
];

const List<PlacementGuide> kSamplePlacementGuides = [
  PlacementGuide(
    title: 'DSA & Coding Practice',
    category: 'Coding Preparation',
    subtitle: '75 Core Patterns for Technical Coding Rounds',
    tips:
        'Focus on mastering problem patterns rather than memorising solutions. Practice writing clean code and explaining space-time complexity aloud.',
    checklist: [
      'Arrays, HashMaps & Two Pointers',
      'Sliding Window & Two-Pass Algorithms',
      'Linked Lists & Fast/Slow Pointers',
      'Trees, Binary Search Trees & BFS/DFS',
      'Graph Traversals & Topological Sort',
      'Dynamic Programming & Memoization Patterns'
    ],
    icon: Icons.terminal_rounded,
    color: Color(0xFF1E40AF),
  ),
  PlacementGuide(
    title: 'Technical & Mock Interviews',
    category: 'Interview Practice',
    subtitle: 'Core CS Fundamentals & Behavioral STAR Framework',
    tips:
        'Review OOP principles, database indexing, and operating system concurrency. Structure behavioral questions using Situation, Task, Action, and Result.',
    checklist: [
      'OOP Concepts & SOLID Principles',
      'DBMS: Normalization, ACID Properties & SQL Queries',
      'OS: Process vs Thread, Deadlocks & Virtual Memory',
      'Computer Networks: TCP/IP, DNS, HTTP/HTTPS',
      'STAR Method for Teamwork & Conflict Resolution'
    ],
    icon: Icons.record_voice_over_rounded,
    color: Color(0xFF047857),
  ),
  PlacementGuide(
    title: 'Resume & Portfolio Review',
    category: 'Application Prep',
    subtitle: 'ATS-Friendly Structure & High-Impact Project Bullets',
    tips:
        'Quantify your contributions with metrics. Highlight production-grade full-stack projects, deployed URLs, and open-source contributions.',
    checklist: [
      'Single-page clean format with standard section headers',
      'Bullet points starting with strong action verbs',
      'Quantified outcomes (e.g., "reduced query latency by 40%")',
      'Active GitHub profile and live project deployment links',
      'Tailored technical keywords aligned with job descriptions'
    ],
    icon: Icons.description_rounded,
    color: Color(0xFFB45309),
  ),
];

const List<CampusAnnouncement> kSampleAnnouncements = [
  CampusAnnouncement(
    id: 'ann_1',
    title: 'Annual Alumni–Student Mentorship Summit 2026',
    date: 'Nov 15, 2026',
    category: 'Featured Event',
    description:
        'Interactive 1-on-1 virtual sessions with senior alumni working at Google, Microsoft, Amazon, and Zoho.',
    icon: Icons.event_available_rounded,
  ),
  CampusAnnouncement(
    id: 'ann_2',
    title: 'Tech Placement Season: Mock Coding Drive',
    date: 'Nov 22, 2026',
    category: 'Placement Drive',
    description:
        'Simulated campus placement tests covering aptitude, core CS multiple-choice questions, and live coding.',
    icon: Icons.campaign_rounded,
  ),
];

// ─── Student Dashboard ────────────────────────────────────────────────────────

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  // Nav index: 0 = Home, 1 = Browse Alumni, 2 = Resources, 3 = Placement, 4 = Opportunities
  int _navIndex = 0;

  void _logout() {
    context.read<AuthProvider>().logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  void _onNavChange(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AlumniDirectory(initialDomain: 'All'),
        ),
      );
    } else {
      setState(() => _navIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return LayoutBuilder(
      builder: (context, constraints) {
        final r = Responsive(constraints.maxWidth);

        final logoutAction = IconButton(
          icon: const Icon(Icons.logout, size: 20),
          tooltip: 'Logout',
          onPressed: _logout,
        );

        Widget currentBody;
        switch (_navIndex) {
          case 0:
            currentBody = _HomeBody(
              user: user,
              r: r,
              onNavigateTab: (idx) => setState(() => _navIndex = idx),
            );
            break;
          case 2:
            currentBody = _LearningResourcesFullView(r: r);
            break;
          case 3:
            currentBody = _PlacementPrepFullView(r: r);
            break;
          case 4:
            currentBody = _OpportunitiesFullView(r: r);
            break;
          default:
            currentBody = _HomeBody(
              user: user,
              r: r,
              onNavigateTab: (idx) => setState(() => _navIndex = idx),
            );
        }

        // Desktop
        if (r.isDesktop) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Row(
              children: [
                _StudentSidebar(
                  navIndex: _navIndex,
                  onNavChange: _onNavChange,
                  onLogout: _logout,
                  userName: user?.name ?? 'Student',
                ),
                Expanded(child: currentBody),
              ],
            ),
          );
        }

        // Tablet
        if (r.isTablet) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: const Text(
                'University Portal',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
              ),
              actions: [logoutAction],
            ),
            body: Row(
              children: [
                NavigationRail(
                  backgroundColor: AppColors.primary,
                  selectedIndex: _navIndex > 4 ? 0 : _navIndex,
                  onDestinationSelected: _onNavChange,
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: const IconThemeData(color: Colors.white, size: 22),
                  unselectedIconTheme: IconThemeData(color: Colors.white.withOpacity(0.55), size: 22),
                  selectedLabelTextStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                  unselectedLabelTextStyle: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 11),
                  indicatorColor: Colors.white.withOpacity(0.18),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.people_outline_rounded),
                      selectedIcon: Icon(Icons.people_rounded),
                      label: Text('Alumni'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.menu_book_outlined),
                      selectedIcon: Icon(Icons.menu_book_rounded),
                      label: Text('Resources'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.psychology_outlined),
                      selectedIcon: Icon(Icons.psychology_rounded),
                      label: Text('Placement'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.campaign_outlined),
                      selectedIcon: Icon(Icons.campaign_rounded),
                      label: Text('Updates'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1, thickness: 1, color: AppColors.divider),
                Expanded(child: currentBody),
              ],
            ),
          );
        }

        // Mobile
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              _navIndex == 0
                  ? 'University Portal'
                  : _navIndex == 2
                      ? 'Learning Resources'
                      : _navIndex == 3
                          ? 'Placement Prep'
                          : 'Recent Updates & Jobs',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
            ),
            actions: [logoutAction],
          ),
          body: currentBody,
          bottomNavigationBar: NavigationBar(
            backgroundColor: Colors.white,
            indicatorColor: AppColors.primary.withOpacity(0.12),
            selectedIndex: _navIndex > 4 ? 0 : _navIndex,
            onDestinationSelected: _onNavChange,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.people_outline_rounded),
                selectedIcon: Icon(Icons.people_rounded, color: AppColors.primary),
                label: 'Browse Alumni',
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book_rounded, color: AppColors.primary),
                label: 'Resources',
              ),
              NavigationDestination(
                icon: Icon(Icons.psychology_outlined),
                selectedIcon: Icon(Icons.psychology_rounded, color: AppColors.primary),
                label: 'Placement',
              ),
              NavigationDestination(
                icon: Icon(Icons.campaign_outlined),
                selectedIcon: Icon(Icons.campaign_rounded, color: AppColors.primary),
                label: 'Updates',
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Desktop Sidebar ──────────────────────────────────────────────────────────

class _StudentSidebar extends StatelessWidget {
  final int navIndex;
  final ValueChanged<int> onNavChange;
  final VoidCallback onLogout;
  final String userName;

  const _StudentSidebar({
    required this.navIndex,
    required this.onNavChange,
    required this.onLogout,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      color: AppColors.primary,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.account_balance, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'University Portal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withOpacity(0.15), height: 24),
            _SidebarNavItem(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_rounded,
              label: 'Home',
              isSelected: navIndex == 0,
              onTap: () => onNavChange(0),
            ),
            _SidebarNavItem(
              icon: Icons.people_outline_rounded,
              selectedIcon: Icons.people_rounded,
              label: 'Browse Alumni',
              isSelected: navIndex == 1,
              onTap: () => onNavChange(1),
            ),
            _SidebarNavItem(
              icon: Icons.menu_book_outlined,
              selectedIcon: Icons.menu_book_rounded,
              label: 'Learning Resources',
              isSelected: navIndex == 2,
              onTap: () => onNavChange(2),
            ),
            _SidebarNavItem(
              icon: Icons.psychology_outlined,
              selectedIcon: Icons.psychology_rounded,
              label: 'Placement Prep',
              isSelected: navIndex == 3,
              onTap: () => onNavChange(3),
            ),
            _SidebarNavItem(
              icon: Icons.campaign_outlined,
              selectedIcon: Icons.campaign_rounded,
              label: 'Recent Updates & Jobs',
              isSelected: navIndex == 4,
              onTap: () => onNavChange(4),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'S',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Student Portal',
                          style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withOpacity(0.15), height: 1),
            _SidebarNavItem(
              icon: Icons.logout,
              selectedIcon: Icons.logout,
              label: 'Logout',
              isSelected: false,
              isDestructive: true,
              onTap: onLogout,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SidebarNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              size: 20,
              color: isDestructive
                  ? Colors.red.shade200
                  : isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.7),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isDestructive
                    ? Colors.red.shade200
                    : isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Home Body ────────────────────────────────────────────────────────────────

class _HomeBody extends StatelessWidget {
  final dynamic user;
  final Responsive r;
  final ValueChanged<int> onNavigateTab;

  const _HomeBody({
    required this.user,
    required this.r,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── Welcome Banner ─────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _WelcomeBanner(user: user, r: r, onNavigateTab: onNavigateTab),
        ),

        // ── Feature 1: Recent Updates & Opportunities Banner ───────────────
        SliverToBoxAdapter(
          child: _RecentUpdatesSection(r: r, onNavigateTab: onNavigateTab),
        ),

        // ── Feature 2: Placement Preparation Hub ───────────────────────────
        SliverToBoxAdapter(
          child: _PlacementPrepSection(r: r, onNavigateTab: onNavigateTab),
        ),

        // ── Feature 3: Learning Resources Section ──────────────────────────
        SliverToBoxAdapter(
          child: _LearningResourcesSection(r: r, onNavigateTab: onNavigateTab),
        ),

        // ── Existing: Explore Career Domains ───────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(r.horizontalPadding, 28, r.horizontalPadding, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Explore Career Domains',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AlumniDirectory(initialDomain: 'All'),
                    ),
                  ),
                  child: const Text('View All', style: TextStyle(color: AppColors.accent, fontSize: 13)),
                ),
              ],
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, catIndex) {
              final category = kDomainCategories[catIndex];
              return _DomainCategorySection(category: category, r: r);
            },
            childCount: kDomainCategories.length,
          ),
        ),

        // ── Existing: Recently Added Alumni heading ────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(r.horizontalPadding, 24, r.horizontalPadding, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recently Added Alumni',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AlumniDirectory(initialDomain: 'All'),
                    ),
                  ),
                  child: const Text('View Directory', style: TextStyle(color: AppColors.accent, fontSize: 13)),
                ),
              ],
            ),
          ),
        ),

        // ── Existing: Alumni grid / list ───────────────────────────────────
        SliverToBoxAdapter(
          child: Consumer<AlumniProvider>(
            builder: (_, provider, __) {
              final recent = provider.recentAlumni;
              return _AlumniSection(recent: recent, r: r);
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 36)),
      ],
    );
  }
}

// ─── Welcome Banner ───────────────────────────────────────────────────────────

class _WelcomeBanner extends StatelessWidget {
  final dynamic user;
  final Responsive r;
  final ValueChanged<int> onNavigateTab;

  const _WelcomeBanner({
    required this.user,
    required this.r,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.fromLTRB(
        r.horizontalPadding,
        r.isDesktop ? 28 : 16,
        r.horizontalPadding,
        24,
      ),
      child: r.isDesktop ? _desktopBanner(context) : _mobileBanner(context),
    );
  }

  Widget _mobileBanner(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.school_rounded, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${user?.name ?? 'Student'}!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Batch of ${user?.batch ?? '2025'} · Connect with mentors & explore career paths',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            _QuickAction(
              icon: Icons.people_outline_rounded,
              label: 'Browse Alumni',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AlumniDirectory(initialDomain: 'All'),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _QuickAction(
              icon: Icons.psychology_outlined,
              label: 'Placement Prep',
              onTap: () => onNavigateTab(3),
            ),
          ],
        ),
      ],
    );
  }

  Widget _desktopBanner(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, ${user?.name ?? 'Student'}!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Batch of ${user?.batch ?? '2025'} · Explore career roadmaps, placement preparation, and alumni mentors across 13 domains.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AlumniDirectory(initialDomain: 'All'),
                      ),
                    ),
                    icon: const Icon(Icons.people_outline_rounded, size: 16),
                    label: const Text('Browse All Alumni'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => onNavigateTab(2),
                    icon: const Icon(Icons.menu_book_rounded, size: 16),
                    label: const Text('Study Roadmaps'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.16),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => onNavigateTab(3),
                    icon: const Icon(Icons.psychology_rounded, size: 16),
                    label: const Text('Placement Hub'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.16),
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
        const SizedBox(width: 32),
        _BannerStats(),
      ],
    );
  }
}

class _BannerStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.16), width: 1),
      ),
      child: Column(
        children: const [
          _BannerStat(value: '1,200+', label: 'Alumni Mentors'),
          SizedBox(height: 14),
          _BannerStat(value: '13', label: 'Career Domains'),
          SizedBox(height: 14),
          _BannerStat(value: '10+', label: 'Graduating Batches'),
        ],
      ),
    );
  }
}

class _BannerStat extends StatelessWidget {
  final String value;
  final String label;

  const _BannerStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── FEATURE 1: RECENT UPDATES & OPPORTUNITIES ─────────────────────────────────

class _RecentUpdatesSection extends StatelessWidget {
  final Responsive r;
  final ValueChanged<int> onNavigateTab;

  const _RecentUpdatesSection({
    required this.r,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final jobs = context.watch<AlumniProvider>().jobOpportunities;
    final hp = r.horizontalPadding;

    return Padding(
      padding: EdgeInsets.fromLTRB(hp, 24, hp, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.campaign_rounded, color: AppColors.accent, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Campus Updates & Alumni Jobs',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => onNavigateTab(4),
                child: const Text('View All', style: TextStyle(color: AppColors.accent, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Two-column or stack layout: Announcements + Latest Jobs
          if (r.isDesktop || r.isTablet)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _AnnouncementCard(announcement: kSampleAnnouncements.first),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: jobs.isNotEmpty
                      ? _JobPreviewCard(job: jobs.first)
                      : _AnnouncementCard(announcement: kSampleAnnouncements.last),
                ),
              ],
            )
          else
            Column(
              children: [
                _AnnouncementCard(announcement: kSampleAnnouncements.first),
                if (jobs.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _JobPreviewCard(job: jobs.first),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final CampusAnnouncement announcement;

  const _AnnouncementCard({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  announcement.category,
                  style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
              const Spacer(),
              Text(
                announcement.date,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            announcement.title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            announcement.description,
            style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Registered interest for: ${announcement.title}'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.bookmark_add_outlined, size: 14),
              label: const Text('RSVP / Learn More', style: TextStyle(fontSize: 12)),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JobPreviewCard extends StatelessWidget {
  final JobOpportunity job;

  const _JobPreviewCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: job.type == 'Internship' ? Colors.orange.shade50 : AppColors.accentLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  job.type,
                  style: TextStyle(
                    color: job.type == 'Internship' ? Colors.orange.shade800 : AppColors.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                job.postedDate,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            job.title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            '${job.company} · ${job.location}',
            style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                _showJobDetailsModal(context, job);
              },
              icon: const Icon(Icons.open_in_new_rounded, size: 14),
              label: const Text('View Opportunity', style: TextStyle(fontSize: 12)),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accent,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── FEATURE 2: PLACEMENT PREPARATION HUB ──────────────────────────────────────

class _PlacementPrepSection extends StatelessWidget {
  final Responsive r;
  final ValueChanged<int> onNavigateTab;

  const _PlacementPrepSection({
    required this.r,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final hp = r.horizontalPadding;

    return Padding(
      padding: EdgeInsets.fromLTRB(hp, 28, hp, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.psychology_rounded, color: Colors.green.shade700, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Placement Preparation Hub',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => onNavigateTab(3),
                child: const Text('Full Hub', style: TextStyle(color: AppColors.accent, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (r.isDesktop || r.isTablet)
            Row(
              children: kSamplePlacementGuides
                  .map(
                    (guide) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _PlacementGuideCard(guide: guide),
                      ),
                    ),
                  )
                  .toList(),
            )
          else
            Column(
              children: kSamplePlacementGuides
                  .map(
                    (guide) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _PlacementGuideCard(guide: guide),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _PlacementGuideCard extends StatelessWidget {
  final PlacementGuide guide;

  const _PlacementGuideCard({required this.guide});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showPlacementGuideModal(context, guide),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: guide.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(guide.icon, color: guide.color, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    guide.category,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: guide.color,
                      letterSpacing: 0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              guide.title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              guide.subtitle,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.35),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${guide.checklist.length} Topics & Tips',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: guide.color),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, size: 12, color: guide.color),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── FEATURE 3: LEARNING RESOURCES SECTION ─────────────────────────────────────

class _LearningResourcesSection extends StatelessWidget {
  final Responsive r;
  final ValueChanged<int> onNavigateTab;

  const _LearningResourcesSection({
    required this.r,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final hp = r.horizontalPadding;

    return Padding(
      padding: EdgeInsets.fromLTRB(hp, 28, hp, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.menu_book_rounded, color: Colors.purple.shade700, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Domain Study Materials & Roadmaps',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => onNavigateTab(2),
                child: const Text('View Library', style: TextStyle(color: AppColors.accent, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (r.isDesktop || r.isTablet)
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: r.isDesktop ? 2 : 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: r.isDesktop ? 3.0 : 2.5,
              ),
              itemCount: kSampleStudyResources.length,
              itemBuilder: (context, i) => _StudyResourceCard(resource: kSampleStudyResources[i]),
            )
          else
            Column(
              children: kSampleStudyResources
                  .map(
                    (res) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _StudyResourceCard(resource: res),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _StudyResourceCard extends StatelessWidget {
  final StudyResource resource;

  const _StudyResourceCard({required this.resource});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showStudyResourceModal(context, resource),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: resource.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(resource.icon, color: resource.color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: resource.color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      resource.type,
                      style: TextStyle(color: resource.color, fontSize: 10.5, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    resource.title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    resource.domain,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: resource.color, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── FULL VIEW TABS ───────────────────────────────────────────────────────────

class _LearningResourcesFullView extends StatelessWidget {
  final Responsive r;

  const _LearningResourcesFullView({required this.r});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(r.isDesktop ? 32 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 24),
              SizedBox(width: 10),
              Text(
                'Student Resource Library',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Explore career roadmaps, reference sheets, and domain-wise preparation blueprints.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: kSampleStudyResources.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (ctx, i) {
              final res = kSampleStudyResources[i];
              return Container(
                padding: const EdgeInsets.all(20),
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
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: res.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(res.icon, color: res.color, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                res.title,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary),
                              ),
                              Text(
                                '${res.domain} · ${res.type}',
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      res.description,
                      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4),
                    ),
                    const SizedBox(height: 14),
                    const Text('Topics Covered:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: res.topics
                          .map(
                            (t) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: Text(t, style: const TextStyle(fontSize: 11.5, color: AppColors.textPrimary)),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Study guide "${res.title}" opened.'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                        icon: const Icon(Icons.download_done_rounded, size: 16),
                        label: const Text('Open Study Material'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: res.color,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
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

class _PlacementPrepFullView extends StatelessWidget {
  final Responsive r;

  const _PlacementPrepFullView({required this.r});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(r.isDesktop ? 32 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.psychology_rounded, color: AppColors.primary, size: 24),
              SizedBox(width: 10),
              Text(
                'Placement & Interview Preparation',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Master coding challenges, prepare for technical rounds, and optimize your resume.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: kSamplePlacementGuides.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (ctx, i) {
              final g = kSamplePlacementGuides[i];
              return Container(
                padding: const EdgeInsets.all(20),
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
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: g.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(g.icon, color: g.color, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                g.title,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary),
                              ),
                              Text(
                                g.subtitle,
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: g.color.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline_rounded, color: g.color, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              g.tips,
                              style: TextStyle(fontSize: 12.5, color: g.color, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Key Preparation Checklist:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    const SizedBox(height: 8),
                    ...g.checklist.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(item, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                            ),
                          ],
                        ),
                      ),
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

class _OpportunitiesFullView extends StatelessWidget {
  final Responsive r;

  const _OpportunitiesFullView({required this.r});

  @override
  Widget build(BuildContext context) {
    final jobs = context.watch<AlumniProvider>().jobOpportunities;

    return SingleChildScrollView(
      padding: EdgeInsets.all(r.isDesktop ? 32 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.campaign_rounded, color: AppColors.primary, size: 24),
              SizedBox(width: 10),
              Text(
                'Campus Updates & Alumni Opportunities',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Explore campus announcements, recruitment drives, and positions shared by alumni.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          const Text('Campus Announcements', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ...kSampleAnnouncements.map((ann) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _AnnouncementCard(announcement: ann),
              )),
          const SizedBox(height: 20),
          const Text('Active Opportunities from Alumni', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ...jobs.map((job) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _JobPreviewCard(job: job),
              )),
        ],
      ),
    );
  }
}

// ─── Modal Sheet Helpers ──────────────────────────────────────────────────────

void _showStudyResourceModal(BuildContext context, StudyResource resource) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: resource.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(resource.icon, color: resource.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary),
                    ),
                    Text(
                      '${resource.domain} · ${resource.type}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(resource.description, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4)),
          const SizedBox(height: 16),
          const Text('Included Study Modules:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 8),
          ...resource.topics.map(
            (t) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: resource.color, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(t, style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Study guide for "${resource.title}" is ready.'),
                    backgroundColor: resource.color,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: resource.color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text('Access Study Material', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    ),
  );
}

void _showPlacementGuideModal(BuildContext context, PlacementGuide guide) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: guide.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(guide.icon, color: guide.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guide.title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary),
                    ),
                    Text(
                      guide.subtitle,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: guide.color.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline, size: 16, color: guide.color),
                const SizedBox(width: 8),
                Expanded(child: Text(guide.tips, style: TextStyle(fontSize: 12.5, color: guide.color, height: 1.35))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Recommended Action Items:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 8),
          ...guide.checklist.map(
            (c) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  const Icon(Icons.task_alt_rounded, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(c, style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Starting preparation checklist for ${guide.title}.'),
                    backgroundColor: guide.color,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: guide.color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text('Start Preparation', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    ),
  );
}

void _showJobDetailsModal(BuildContext context, JobOpportunity job) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Text(job.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text('${job.company} · ${job.location}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 14),
          Text(job.description, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4)),
          const SizedBox(height: 14),
          Text('Posted by ${job.postedBy} · ${job.postedDate}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Application details copied! Send your resume to ${job.contactEmail}'),
                    backgroundColor: AppColors.accent,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text('Apply / Contact Alumni Recruiter', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    ),
  );
}

// ─── Domain Category Section (Existing) ───────────────────────────────────────

class _DomainCategorySection extends StatelessWidget {
  final DomainCategory category;
  final Responsive r;

  const _DomainCategorySection({required this.category, required this.r});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        left: r.horizontalPadding,
        right: r.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                category.categoryName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (r.isMobile)
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: category.domains.length,
                itemBuilder: (context, i) {
                  final domain = category.domains[i];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: 140,
                      child: DomainCard(
                        domain: domain,
                        onTap: () => _navigate(context, domain.name),
                      ),
                    ),
                  );
                },
              ),
            )
          else
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: r.domainGridCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
              ),
              itemCount: category.domains.length,
              itemBuilder: (context, i) {
                final domain = category.domains[i];
                return DomainCard(
                  domain: domain,
                  onTap: () => _navigate(context, domain.name),
                );
              },
            ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, String domainName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AlumniDirectory(initialDomain: domainName),
      ),
    );
  }
}

// ─── Alumni Section (Existing) ────────────────────────────────────────────────

class _AlumniSection extends StatelessWidget {
  final List<dynamic> recent;
  final Responsive r;

  const _AlumniSection({required this.recent, required this.r});

  @override
  Widget build(BuildContext context) {
    final hp = r.horizontalPadding;

    if (r.isDesktop || r.isTablet) {
      return Padding(
        padding: EdgeInsets.fromLTRB(hp, 12, hp, 4),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: r.alumniGridCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: r.isDesktop ? 2.8 : 2.5,
          ),
          itemCount: recent.length,
          itemBuilder: (context, index) => AlumniCard(
            alumni: recent[index],
            compact: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AlumniDirectory(initialDomain: recent[index].domain),
              ),
            ),
          ),
        ),
      );
    }

    // Mobile list
    return Column(
      children: [
        ...recent.map(
          (alumni) => AlumniCard(
            alumni: alumni,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AlumniDirectory(initialDomain: alumni.domain),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(hp, 8, hp, 4),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AlumniDirectory(initialDomain: 'All'),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'View All Alumni',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
