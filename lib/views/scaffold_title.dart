import 'package:downloader/views/icons.dart';
import 'package:flutter/material.dart';

class ScaffoldTitle extends Text {
  ScaffoldTitle({
    required String title,
  }) : super(
          title,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        );

  ScaffoldTitle.small({
    required String title,
  }) : super(
          title,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        );
}

class ScaffoldTitleWithBack extends Column {
  ScaffoldTitleWithBack({
    required VoidCallback onBack,
    required String title,
  }) : super(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DownloaderIconButton.large(
              onTap: onBack,
              icon: Icons.arrow_back,
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: ScaffoldTitle(
                title: title,
              ),
            ),
          ],
        );
}
