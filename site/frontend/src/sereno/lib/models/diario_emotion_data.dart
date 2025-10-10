import 'dart:ffi';

import 'package:flutter/material.dart';

class EmotionData {
  final String emotion;
  final Color color;
  final String imagePath;
  final double percentage;

  EmotionData(this.emotion, this.percentage, this.color, this.imagePath);
}
