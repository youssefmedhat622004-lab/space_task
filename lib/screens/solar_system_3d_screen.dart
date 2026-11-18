import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../theme/app_theme.dart';
import '../widgets/star_field_background.dart';

class SolarSystem3DScreen extends StatefulWidget {
  const SolarSystem3DScreen({super.key});

  @override
  State<SolarSystem3DScreen> createState() => _SolarSystem3DScreenState();
}

class _SolarSystem3DScreenState extends State<SolarSystem3DScreen> {
  bool _autoRotate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarFieldBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // 3D Solar System Model Viewer
              Positioned.fill(
                child: ModelViewer(
                  key: ValueKey('solar_system_model_$_autoRotate'),
                  src: 'assets/models/solar_system.glb',
                  alt: '3D Solar System Model',
                  ar: false,
                  autoRotate: _autoRotate,
                  autoRotateDelay: 0,
                  rotationPerSecond: '15deg',
                  cameraControls: true,
                  backgroundColor: Colors.transparent,
                ),
              ),

              // Top Bar
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textLight),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Text(
                      '3D SOLAR SYSTEM',
                      style: GoogleFonts.orbitron(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentCyan,
                        letterSpacing: 2.0,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: IconButton(
                        icon: Icon(
                          _autoRotate ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                          color: AppTheme.accentCyan,
                        ),
                        tooltip: _autoRotate ? 'Pause Rotation' : 'Auto Rotate',
                        onPressed: () {
                          setState(() => _autoRotate = !_autoRotate);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Control & Hints Bar
              Positioned(
                bottom: 24,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.accentCyan.withValues(alpha: 0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentCyan.withValues(alpha: 0.15),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHintItem(Icons.touch_app_rounded, 'Drag to rotate 360°'),
                      _buildHintItem(Icons.zoom_in_rounded, 'Pinch to zoom'),
                      _buildHintItem(Icons.pan_tool_rounded, 'Two fingers to pan'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHintItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.accentCyan),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 11,
            color: AppTheme.textLight,
          ),
        ),
      ],
    );
  }
}
