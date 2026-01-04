import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quanly/core/services/image_storage_service.dart';

class MemberAvatar extends StatelessWidget {
  final String? imageUrl; // Relative path from AppData
  final String name;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;

  const MemberAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.radius = 20,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final imageStorageService = ImageStorageService();
    final defaultColor = backgroundColor ?? Colors.grey.shade300;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return FutureBuilder<String?>(
        future: imageStorageService.getFullImagePath(imageUrl),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final file = File(snapshot.data!);
            if (file.existsSync()) {
              return CircleAvatar(
                radius: radius,
                backgroundImage: FileImage(file),
                backgroundColor: defaultColor,
                onBackgroundImageError: (exception, stackTrace) {
                  // Fallback to default avatar if image fails to load
                },
                child: file.existsSync() ? null : _buildDefaultAvatar(),
              );
            }
          }
          return _buildDefaultAvatar();
        },
      );
    }

    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    final defaultColor = backgroundColor ?? Colors.grey.shade300;
    final defaultTextColor = textColor ?? Colors.grey.shade700;
    
    return CircleAvatar(
      radius: radius,
      backgroundColor: defaultColor,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: radius * 0.6,
          fontWeight: FontWeight.bold,
          color: defaultTextColor,
        ),
      ),
    );
  }
}

