import 'package:downloader/services/navigation_service/navigation_service.dart';
import 'package:downloader/views/icons.dart';
import 'package:downloader/views/scaffold_title.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ScaffoldTitle(title: "File Downloader"),
                ),
                Tooltip(
                  message: "List Downloads",
                  verticalOffset: 40,
                  child: InkWell(
                    onTap: () => DownloadUtilScreens.downloads.go(context),
                    borderRadius: BorderRadius.circular(40),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.download,
                        size: 34,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          offset: Offset(4, 4),
                          blurRadius: 10,
                          spreadRadius: -5,
                        )
                      ],
                    ),
                    child: InkWell(
                      onTap: () => DownloadUtilScreens.downloadUrl.go(context),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Download URL",
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            DownloaderIconLarge(
                              icon: Icons.chevron_right_rounded,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
