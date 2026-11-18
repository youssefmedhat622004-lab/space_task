import 'package:flutter/material.dart';

class CelestialBody {
  final String name;
  final String imagePath;
  final String modelPath;
  final String title;
  final String about;
  final String distance;
  final String dayLength;
  final String orbitalPeriod;
  final String radius;
  final String mass;
  final String gravity;
  final String surfaceArea;
  final bool isSun;
  final Color primaryColor;
  final Color secondaryColor;
  final double scaleFactor;

  const CelestialBody({
    required this.name,
    required this.imagePath,
    required this.modelPath,
    required this.title,
    required this.about,
    required this.distance,
    required this.dayLength,
    required this.orbitalPeriod,
    required this.radius,
    required this.mass,
    required this.gravity,
    required this.surfaceArea,
    this.isSun = false,
    required this.primaryColor,
    required this.secondaryColor,
    this.scaleFactor = 1.0,
  });
}
