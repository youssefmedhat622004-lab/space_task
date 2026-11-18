import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/celestial_data.dart';
import '../models/celestial_body.dart';
import '../theme/app_theme.dart';
import '../widgets/star_field_background.dart';

class DetailScreen extends StatefulWidget {
  final CelestialBody body;
  final int initialIndex;

  const DetailScreen({
    super.key,
    required this.body,
    required this.initialIndex,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late PageController _pageController;
  late int _currentIndex;
  bool _show3DModel = true;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentBody = CelestialData.bodies[_currentIndex];

    return Scaffold(
      body: StarFieldBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Custom Navigation Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textLight),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      currentBody.name.toUpperCase(),
                      style: GoogleFonts.orbitron(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: currentBody.primaryColor,
                        letterSpacing: 2.0,
                      ),
                    ),
                    Row(
                      children: [
                        // Toggle 3D / 2D Image View
                        IconButton(
                          icon: Icon(
                            _show3DModel ? Icons.image_rounded : Icons.view_in_ar_rounded,
                            color: currentBody.primaryColor,
                          ),
                          tooltip: _show3DModel ? 'Switch to 2D Image' : 'Switch to 3D Model',
                          onPressed: () {
                            setState(() => _show3DModel = !_show3DModel);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: _isFavorite ? const Color(0xFFFF5252) : AppTheme.textMuted,
                          ),
                          onPressed: () {
                            setState(() => _isFavorite = !_isFavorite);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Page View for swiping between celestial bodies
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: CelestialData.bodies.length,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final body = CelestialData.bodies[index];
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Interactive 3D Model Viewer or PNG Display
                          Container(
                            height: 320,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: AppTheme.cardDark.withValues(alpha: 0.5),
                              border: Border.all(
                                color: body.primaryColor.withValues(alpha: 0.3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: body.primaryColor.withValues(alpha: 0.2),
                                  blurRadius: 30,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Stack(
                                children: [
                                  if (_show3DModel)
                                    ModelViewer(
                                      key: ValueKey('model_${body.name}'),
                                      src: body.modelPath,
                                      alt: '3D model of ${body.name}',
                                      ar: false,
                                      autoRotate: true,
                                      autoRotateDelay: 0,
                                      rotationPerSecond: '30deg',
                                      cameraControls: true,
                                      backgroundColor: Colors.transparent,
                                    )
                                  else
                                    Center(
                                      child: Hero(
                                        tag: 'planet_img_${body.name}',
                                        child: Image.asset(
                                          body.imagePath,
                                          fit: BoxFit.contain,
                                          height: 260,
                                        ),
                                      ),
                                    ),
                                  // Badge indicator for mode
                                  Positioned(
                                    bottom: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.7),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: body.primaryColor.withValues(alpha: 0.5)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _show3DModel ? Icons.view_in_ar_rounded : Icons.image_outlined,
                                            size: 14,
                                            color: body.primaryColor,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            _show3DModel ? '3D Interactive (Drag to rotate)' : '2D Image',
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 10,
                                              color: AppTheme.textLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                          const SizedBox(height: 24),

                          // Title and Subtitle
                          Text(
                            body.title,
                            style: GoogleFonts.orbitron(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textLight,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // About Section
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.cardDark.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppTheme.cardBorder),
                            ),
                            child: Text(
                              body.about,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppTheme.textLight.withValues(alpha: 0.9),
                                height: 1.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Specification Sheet Section Header
                          Text(
                            'SPECIFICATIONS',
                            style: GoogleFonts.orbitron(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: body.primaryColor,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Data Specifications Grid
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 2.2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            children: [
                              _buildSpecCard('Distance from Sun', body.distance, Icons.straighten_rounded, body.primaryColor),
                              _buildSpecCard('Length of Day', body.dayLength, Icons.access_time_rounded, body.primaryColor),
                              _buildSpecCard('Orbital Period', body.orbitalPeriod, Icons.sync_rounded, body.primaryColor),
                              _buildSpecCard('Radius', body.radius, Icons.panorama_fish_eye_rounded, body.primaryColor),
                              _buildSpecCard('Mass', body.mass, Icons.scale_rounded, body.primaryColor),
                              _buildSpecCard('Gravity', body.gravity, Icons.south_rounded, body.primaryColor),
                              _buildSpecCard('Surface Area', body.surfaceArea, Icons.grid_view_rounded, body.primaryColor),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Planet Quick Selection Strip
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: AppTheme.cardDark.withValues(alpha: 0.9),
                  border: const Border(top: BorderSide(color: AppTheme.cardBorder)),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: CelestialData.bodies.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemBuilder: (context, index) {
                    final b = CelestialData.bodies[index];
                    final isSelected = index == _currentIndex;

                    return GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? b.primaryColor.withValues(alpha: 0.25)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? b.primaryColor : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Image.asset(b.imagePath, width: 28, height: 28),
                            const SizedBox(width: 8),
                            Text(
                              b.name,
                              style: GoogleFonts.orbitron(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? b.primaryColor : AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10,
                    color: AppTheme.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
