import 'package:downloader/models/download_configs.dart';
import 'package:downloader/models/download_progress.dart';
import 'package:downloader/views/icons.dart';
import 'package:downloader/views/scaffold_title.dart';
import 'package:flutter/material.dart';

class DownloadDetailsScreen extends StatelessWidget {
  const DownloadDetailsScreen({
    super.key,
    required this.progress,
  });

  final DownloadProgress progress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaffoldTitleWithBack(
                onBack: () {},
                title: "Download Details",
              ),
              SizedBox(height: 40),
              Text(
                "Download URL: ",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Expanded(child: Text(progress.configs.url)),
                  DownloaderIconButton.small(
                    onTap: () {},
                    icon: Icons.copy,
                  )
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Save Path ",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Expanded(child: Text(progress.configs.savePath)),
                  DownloaderIconButton.small(
                    onTap: () {},
                    icon: Icons.copy,
                  )
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Chunk Type: ",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      progress.configs.chunkConfig.type.name.toUpperCase(),
                    ),
                  ),
                  DownloaderIconButton.small(
                    onTap: () {},
                    icon: Icons.copy,
                  )
                ],
              ),
              SizedBox(height: 20),
              Text(
                progress.configs.chunkConfig.type == ChunkTypes.number
                    ? "Number of Chunks:"
                    : "Chunk Size:",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Text("${progress.configs.chunkConfig.value}")),
                  DownloaderIconButton.small(
                    onTap: () {},
                    icon: Icons.copy,
                  )
                ],
              ),
              if (progress.chunks.any((element) => element.future != null)) ...[
                SizedBox(height: 20),
                Text(
                  "Chunk Details:",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: progress.chunks
                      .map((e) => ValueListenableBuilder(
                            valueListenable: e,
                            builder: (_, value, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  child!,
                                  LinearProgressIndicator(
                                    value: value,
                                  ),
                                  Divider(),
                                ],
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Chunk: ${e.id}"),
                                SizedBox(height: 4),
                                Text(
                                    "Start: ${e.start} Bytes\nEnd: ${e.end} Bytes"),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
