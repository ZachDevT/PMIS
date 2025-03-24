// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax/iconsax.dart';

class ServicePlan {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double? price; // null means no price displayed
  final bool isPopular;
  final int likes; // number of likes
  final double rating;

  ServicePlan({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.price,
    this.isPopular = false,
    this.likes = 0,
    this.rating = 0,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'isPopular': isPopular,
      'likes': likes,
      'rating': rating,
    };
  }

  factory ServicePlan.fromMap(Map<String, dynamic> map) {
    return ServicePlan(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      price: map['price'] != null ? map['price'] as double : null,
      isPopular: map['isPopular'] as bool,
      likes: map['likes'] as int,
      rating: map['rating'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServicePlan.fromJson(String source) =>
      ServicePlan.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ServicePlanCategory {
  final String name;
  final IconData icon;
  const ServicePlanCategory({required this.name, required this.icon});
}

final List<ServicePlanCategory> categories = [
  const ServicePlanCategory(name: "All", icon: Iconsax.activity),
  const ServicePlanCategory(
      name: "Driver training", icon: HugeIcons.strokeRoundedCarParking01),
  const ServicePlanCategory(
      name: "Permit processing", icon: HugeIcons.strokeRoundedLicense),
  const ServicePlanCategory(
      name: "Defensive Driving", icon: HugeIcons.strokeRoundedCar01),
];
