import 'package:flutter/material.dart';

class DownloaderIcon extends Icon {
  DownloaderIcon.large({
    required IconData icon,
  }) : super(
          icon,
          size: 40,
        );

  DownloaderIcon.small({
    required IconData icon,
  }) : super(
          icon,
          size: 24,
        );

  DownloaderIcon.medium({
    required IconData icon,
  }) : super(
          icon,
          size: 32,
        );
}

class DownloaderIconButton extends InkWell {
  DownloaderIconButton._({required super.onTap, required Icon icon})
      : super(
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: icon,
          ),
        );

  factory DownloaderIconButton.large({
    required VoidCallback onTap,
    required IconData icon,
  }) =>
      DownloaderIconButton._(
        onTap: onTap,
        icon: DownloaderIcon.large(
          icon: icon,
        ),
      );

  factory DownloaderIconButton.small({
    required VoidCallback onTap,
    required IconData icon,
  }) =>
      DownloaderIconButton._(
        onTap: onTap,
        icon: DownloaderIcon.small(
          icon: icon,
        ),
      );

  factory DownloaderIconButton.medium({
    required VoidCallback onTap,
    required IconData icon,
  }) =>
      DownloaderIconButton._(
        onTap: onTap,
        icon: DownloaderIcon.medium(
          icon: icon,
        ),
      );
}
