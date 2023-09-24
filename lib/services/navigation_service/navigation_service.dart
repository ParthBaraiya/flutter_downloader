import 'package:downloader/screens/download_url/download_url_screen.dart';
import 'package:downloader/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static final router = GoRouter(
    initialLocation: DownloadUtilScreens.home.url,
    routes: [
      GoRoute(
        path: DownloadUtilScreens.home.url,
        name: DownloadUtilScreens.home.name,
        pageBuilder: (_, state) {
          return NoTransitionPage(
            child: const Home(),
          );
        },
      ),
      GoRoute(
        path: DownloadUtilScreens.downloadUrl.url,
        name: DownloadUtilScreens.downloadUrl.name,
        pageBuilder: (_, state) {
          return NoTransitionPage(
            child: const DownloadUrlScreen(),
          );
        },
      ),
    ],
  );
}

class DownloadUtilScreen {
  final String url;
  final String name;

  const DownloadUtilScreen({
    required this.url,
    required this.name,
  });

  void go(BuildContext context) {
    context.go(url);
  }
}

abstract class DownloadUtilScreens {
  static const downloadUrl = DownloadUtilScreen(
    url: '/download-url',
    name: 'Download URL',
  );

  static const home = DownloadUtilScreen(
    url: '/home',
    name: 'Home Page',
  );

  static const downloads = DownloadUtilScreen(
    url: '/downloads',
    name: 'Downloads List',
  );

  static const download = DownloadUtilScreen(
    url: '/downloads/{id}',
    name: 'Download Details',
  );

  static const downloadFromPage = DownloadUtilScreen(
    url: '/download-from-page',
    name: 'Download From Page',
  );
}
