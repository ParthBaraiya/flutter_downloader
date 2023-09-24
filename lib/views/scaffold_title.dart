import 'package:flutter/material.dart';

class ScaffoldTitle extends Text {
  ScaffoldTitle({
    required String title,
  }) : super(
          title,
          style: TextStyle(
            fontSize: 40,
          ),
        );
}
