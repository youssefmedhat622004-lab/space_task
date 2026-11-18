import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/celestial_body.dart';
import '../theme/app_theme.dart';

class CelestialCard extends StatefulWidget {
  final CelestialBody body;
  final VoidCallback onTap;
  final bool isFavorite;
  final ValueChanged<bool>? onFavoriteToggle;

  const CelestialCard({
    super.key,
    required this.body,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  State<CelestialCard> createState() => _CelestialCardState();
}

class _CelestialCardState extends State<CelestialCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final double scale = _isHovered ? 1.02 : 1.0;
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.diagonal3Values(scale, scale, 1.0),
          decoration: BoxDecoration(
            color: AppTheme.cardDark.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered
                  ? widget.body.primaryColor
                  : widget.body.primaryColor.withValues(alpha: 0.3),
              width: _isHovered ? 2.0 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.body.primaryColor.withValues(alpha: _isHovered ? 0.35 : 0.12),
                blurRadius: _isHovered ? 20 : 12,
                spreadRadius: _isHovered ? 2 : 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Glowing background spot
                Positioned(
                  top: -40,
                  right: -40,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: widget.body.primaryColor.withValues(alpha: 0.2),
                          blurRadius: 40,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Tag & Favorite button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: widget.body.primaryColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: widget.body.primaryColor.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              widget.body.isSun ? 'STAR' : 'PLANET',
                              style: GoogleFonts.orbitron(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: widget.body.primaryColor,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          if (widget.onFavoriteToggle != null)
                            IconButton(
                              icon: Icon(
                                widget.isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: widget.isFavorite
                                    ? const Color(0xFFFF5252)
                                    : AppTheme.textMuted,
                                size: 20,
                              ),
                              onPressed: () =>
                                  widget.onFavoriteToggle!(!widget.isFavorite),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Image Display
                      Expanded(
                        child: Center(
                          child: Hero(
                            tag: 'planet_img_${widget.body.name}',
                            child: Image.asset(
                              widget.body.imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.public,
                                  size: 60,
                                  color: widget.body.primaryColor,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Name & Distance
                      Text(
                        widget.body.name,
                        style: GoogleFonts.orbitron(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.near_me_outlined,
                            size: 14,
                            color: widget.body.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.body.distance == '0 km'
                                  ? 'Center of Solar System'
                                  : widget.body.distance,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 12,
                                color: AppTheme.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Explore Button Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Explore 3D',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: widget.body.primaryColor,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: widget.body.primaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
