import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/alumni_provider.dart';
import '../../utils/constants.dart';
import '../../utils/responsive.dart';
import '../../widgets/alumni_card.dart';
import 'alumni_profile_screen.dart';

/// Alumni Directory — searchable, filterable list/grid of alumni.
///
/// [initialDomain] pre-selects a domain filter when navigating from
/// StudentDashboard or a DomainCard.
///
/// Layout adapts:
///  • Mobile  — vertical list, horizontal filter chips.
///  • Tablet  — 2-column grid.
///  • Desktop — 3-column grid, search/filter panel centred with max-width.
class AlumniDirectory extends StatefulWidget {
  final String initialDomain;

  const AlumniDirectory({super.key, this.initialDomain = 'All'});

  @override
  State<AlumniDirectory> createState() => _AlumniDirectoryState();
}

class _AlumniDirectoryState extends State<AlumniDirectory> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlumniProvider>().setDomainFilter(widget.initialDomain);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    // Reset filters when leaving the screen.
    context.read<AlumniProvider>().clearFilters();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Alumni Directory',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final r = Responsive(constraints.maxWidth);
          return Column(
            children: [
              // ── Search + filter header ────────────────────────────────────
              _SearchFilterHeader(
                  searchController: _searchController, r: r),

              const Divider(height: 1, color: AppColors.divider),

              // ── Results count ─────────────────────────────────────────────
              Consumer<AlumniProvider>(
                builder: (_, p, __) => Padding(
                  padding: EdgeInsets.fromLTRB(
                      r.horizontalPadding, 10, r.horizontalPadding, 4),
                  child: Row(
                    children: [
                      Text(
                        '${p.filteredAlumni.length} alumni found',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Alumni list / grid ────────────────────────────────────────
              Expanded(
                child: Consumer<AlumniProvider>(
                  builder: (_, provider, __) {
                    final alumni = provider.filteredAlumni;

                    if (alumni.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 52,
                              color: AppColors.textSecondary
                                  .withOpacity(0.35),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No alumni found',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Try a different search term or filter',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // ── Grid on tablet/desktop ─────────────────────────────
                    if (!r.isMobile) {
                      return _AlumniGrid(
                          alumni: alumni, r: r);
                    }

                    // ── List on mobile ─────────────────────────────────────
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 24),
                      itemCount: alumni.length,
                      itemBuilder: (context, index) => AlumniCard(
                        alumni: alumni[index],
                        onTap: () => _openProfile(context, alumni[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openProfile(BuildContext context, dynamic alumni) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AlumniProfileScreen(alumni: alumni),
      ),
    );
  }
}

// ─── Search + filter header ────────────────────────────────────────────────────
class _SearchFilterHeader extends StatelessWidget {
  final TextEditingController searchController;
  final Responsive r;

  const _SearchFilterHeader(
      {required this.searchController, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.fromLTRB(
                r.horizontalPadding, 0, r.horizontalPadding, 12),
            child: r.isDesktop
                ? Center(
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: 700),
                      child: _SearchBar(
                          searchController: searchController),
                    ),
                  )
                : _SearchBar(searchController: searchController),
          ),
          // Domain filter chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Consumer<AlumniProvider>(
              builder: (_, provider, __) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                    horizontal: r.horizontalPadding),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected:
                          provider.selectedDomain == 'All',
                      color: AppColors.primary,
                      onTap: () =>
                          provider.setDomainFilter('All'),
                    ),
                    const SizedBox(width: 8),
                    ...kDomains.map(
                      (d) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _FilterChip(
                          label: d.name,
                          isSelected:
                              provider.selectedDomain == d.name,
                          color: d.color,
                          onTap: () =>
                              provider.setDomainFilter(d.name),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Search bar widget ────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController searchController;

  const _SearchBar({required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        onChanged: (v) =>
            context.read<AlumniProvider>().setSearchQuery(v),
        decoration: InputDecoration(
          hintText: 'Search by name, role, company or skill…',
          hintStyle: const TextStyle(
              color: AppColors.textSecondary, fontSize: 13.5),
          prefixIcon: const Icon(Icons.search_rounded,
              color: AppColors.textSecondary, size: 20),
          suffixIcon: Consumer<AlumniProvider>(
            builder: (_, p, __) => p.searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded,
                        color: AppColors.textSecondary, size: 18),
                    onPressed: () {
                      searchController.clear();
                      p.setSearchQuery('');
                    },
                  )
                : const SizedBox.shrink(),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

// ─── Alumni grid for tablet/desktop ───────────────────────────────────────────
class _AlumniGrid extends StatelessWidget {
  final List<dynamic> alumni;
  final Responsive r;

  const _AlumniGrid({required this.alumni, required this.r});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(
          r.horizontalPadding, 12, r.horizontalPadding, 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: r.alumniGridCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: r.isDesktop ? 2.8 : 2.4,
      ),
      itemCount: alumni.length,
      itemBuilder: (context, index) => AlumniCard(
        alumni: alumni[index],
        compact: true,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                AlumniProfileScreen(alumni: alumni[index]),
          ),
        ),
      ),
    );
  }
}

// ─── Domain filter chip ────────────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding:
            const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          border: Border.all(
              color: isSelected ? color : AppColors.divider, width: 1.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color:
                isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
