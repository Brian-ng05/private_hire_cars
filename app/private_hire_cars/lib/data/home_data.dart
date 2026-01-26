import 'package:flutter/material.dart';

// 1. The Service Model (4 nút book xe trên Home Screen)
class ServiceItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon; 
  final String route; // route của nút dẫn đến màn hình được định nghĩa trong main.dart

  ServiceItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });
}

// 2. The Promotion Model (Ad Banners)
class PromotionItem {
  final String id;
  final String title;
  final String discountCode;
  final String discountAmount;
  final Color backgroundColor; // trong back-end thì đoạn này cỏ thể là URL của ảnh(string)
  final String route;

  PromotionItem({
    required this.id,
    required this.title,
    required this.discountCode,
    required this.discountAmount,
    required this.backgroundColor,
    required this.route,
  });
}