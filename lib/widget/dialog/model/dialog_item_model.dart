import 'package:flutter/material.dart';

class DialogItemModel {
  VoidCallback onTap;
  String text;
  IconData? icon;

  DialogItemModel({
    required this.onTap,
    required this.text,
    this.icon,
  });
}