import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/celestial_data.dart';
import '../models/celestial_body.dart';
import '../theme/app_theme.dart';
import '../widgets/star_field_background.dart';
import '../widgets/celestial_card.dart';
import 'detail_screen.dart';
import 'solar_system_3d_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All'; // All, Planets, Stars, Favorites
  final Set<String> _favoriteNames = {'Earth', 'Mars', 'Saturn'};

  List<CelestialBody> get _filteredBodies {
    return CelestialData.bodies.where((body) {
      final matchesSearch = body.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          body.title.toLowerCase().contains(_searchQuery.toLowerCase());
      
      if (!matchesSearch) return false;

      if (_selectedCategory == 'Planets') return !body.isSun;
      if (_selectedCategory == 'Stars') return body.isSun;
      if (_selectedCategory == 'Favorites') return _favoriteNames.contains(body.name);

      return true;
    }).toList();
  }

  void _toggleFavorite(String name) {
    setState(() {
      if (_favoriteNames.contains(name)) {
        _favoriteNames.remove(name);
      } else {
        _favoriteNames.add(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarFieldBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Top Bar Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'EXPLORE THE',
                                style: GoogleFonts.orbitron(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.accentCyan,
                                  letterSpacing: 2.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'SOLAR SYSTEM',
                                style: GoogleFonts.orbitron(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textLight,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.cardDark,
                              border: Border.all(color: AppTheme.cardBorder),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.accentCyan.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.blur_on_rounded, color: AppTheme.accentCyan),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SolarSystem3DScreen(),
                                  ),
                                );
                              },
                              tooltip: 'Open 3D Solar System View',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.cardDark.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.cardBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (value) => setState(() => _searchQuery = value),
                          style: GoogleFonts.spaceGrotesk(color: AppTheme.textLight),
                          decoration: InputDecoration(
                            hintText: 'Search planet or star...',
                            hintStyle: GoogleFonts.spaceGrotesk(color: AppTheme.textMuted),
                            prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.accentCyan),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, color: AppTheme.textMuted),
                                    onPressed: () => setState(() => _searchQuery = ''),
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 3D Solar System Interactive Banner
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SolarSystem3DScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF1E1035),
                                Color(0xFF0F1B40),
                                Color(0xFF0A2E5C),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: AppTheme.accentCyan.withValues(alpha: 0.5),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accentPurple.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppTheme.accentCyan.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'INTERACTIVE 3D',
                                        style: GoogleFonts.orbitron(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.accentCyan,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Full Solar System',
                                      style: GoogleFonts.orbitron(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textLight,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Experience 3D orbit model in real-time view',
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 12,
                                        color: AppTheme.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.accentCyan,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.accentCyan.withValues(alpha: 0.5),
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.view_in_ar_rounded,
                                  color: Colors.black,
                                  size: 26,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fade(duration: 500.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 20),

                      // Category Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: ['All', 'Planets', 'Stars', 'Favorites'].map((category) {
                            final isSelected = _selectedCategory == category;
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: FilterChip(
                                label: Text(
                                  category,
                                  style: GoogleFonts.orbitron(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? Colors.black : AppTheme.textLight,
                                  ),
                                ),
                                selected: isSelected,
                                selectedColor: AppTheme.accentCyan,
                                backgroundColor: AppTheme.cardDark,
                                side: BorderSide(
                                  color: isSelected ? AppTheme.accentCyan : AppTheme.cardBorder,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() => _selectedCategory = category);
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Planet Cards Grid
              _filteredBodies.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.search_off_rounded,
                                size: 60,
                                color: AppTheme.textMuted,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No celestial bodies found',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 16,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final body = _filteredBodies[index];
                            final isFav = _favoriteNames.contains(body.name);

                            return CelestialCard(
                              body: body,
                              isFavorite: isFav,
                              onFavoriteToggle: (_) => _toggleFavorite(body.name),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailScreen(
                                      body: body,
                                      initialIndex: CelestialData.bodies.indexOf(body),
                                    ),
                                  ),
                                );
                              },
                            ).animate().fade(duration: 350.ms, delay: (index * 50).ms).slideY(begin: 0.1, end: 0);
                          },
                          childCount: _filteredBodies.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                      ),
                    ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }
}
