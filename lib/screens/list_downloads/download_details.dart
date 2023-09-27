import 'package:downloader/views/downloader_scaffold.dart';
import 'package:downloader/views/icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DownloadDetailsScreen extends StatelessWidget {
  const DownloadDetailsScreen({
    super.key,
    // required this.progress,
  });

  // final DownloadProgress progress;

  @override
  Widget build(BuildContext context) {
    return DownloaderScaffolds(
      title: "Downloads",
      onBack: () => context.pop(),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: DecoratedBox(
              decoration: BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "abc.mp4",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "100 MB",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "https://www.google.com/aads/sdfsds/asd/sf"
                          "/sfds/sdf/sdfds/fsdfsrer/sdfdsf/asd.mp4",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DownloaderIconButton.small(
                        onTap: () {},
                        icon: Icons.copy,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  LinearProgressIndicator(),
                  SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text("Open"),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("Details"),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          childCount: 10,
        ),
      ),
    );
    // return Scaffold(
    //   body: Padding(
    //     padding: EdgeInsets.all(20),
    //     child: SingleChildScrollView(
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           ScaffoldTitleWithBack(
    //             onBack: () {},
    //             title: "Download Details",
    //           ),
    //           SizedBox(height: 40),
    //           Text(
    //             "Download URL: ",
    //             style: TextStyle(
    //               fontWeight: FontWeight.w500,
    //             ),
    //           ),
    //           Row(
    //             children: [
    //               Expanded(child: Text(progress.configs.url)),
    //               DownloaderIconButton.small(
    //                 onTap: () {},
    //                 icon: Icons.copy,
    //               )
    //             ],
    //           ),
    //           SizedBox(height: 20),
    //           Text(
    //             "Save Path ",
    //             style: TextStyle(
    //               fontWeight: FontWeight.w500,
    //             ),
    //           ),
    //           Row(
    //             children: [
    //               Expanded(child: Text(progress.configs.savePath)),
    //               DownloaderIconButton.small(
    //                 onTap: () {},
    //                 icon: Icons.copy,
    //               )
    //             ],
    //           ),
    //           SizedBox(height: 20),
    //           Text(
    //             "Chunk Type: ",
    //             style: TextStyle(
    //               fontWeight: FontWeight.w500,
    //             ),
    //           ),
    //           Row(
    //             children: [
    //               Expanded(
    //                 child: Text(
    //                   progress.configs.chunkConfig.type.name.toUpperCase(),
    //                 ),
    //               ),
    //               DownloaderIconButton.small(
    //                 onTap: () {},
    //                 icon: Icons.copy,
    //               )
    //             ],
    //           ),
    //           SizedBox(height: 20),
    //           Text(
    //             progress.configs.chunkConfig.type == ChunkTypes.number
    //                 ? "Number of Chunks:"
    //                 : "Chunk Size:",
    //             style: TextStyle(
    //               fontWeight: FontWeight.w500,
    //             ),
    //           ),
    //           Row(
    //             children: [
    //               Expanded(
    //                   child: Text("${progress.configs.chunkConfig.value}")),
    //               DownloaderIconButton.small(
    //                 onTap: () {},
    //                 icon: Icons.copy,
    //               )
    //             ],
    //           ),
    //           if (progress.chunks.any((element) => element.future != null)) ...[
    //             SizedBox(height: 20),
    //             Text(
    //               "Chunk Details:",
    //               style: TextStyle(
    //                 fontWeight: FontWeight.w500,
    //               ),
    //             ),
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: progress.chunks
    //                   .map((e) => ValueListenableBuilder(
    //                         valueListenable: e,
    //                         builder: (_, value, child) {
    //                           return Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               child!,
    //                               LinearProgressIndicator(
    //                                 value: value,
    //                               ),
    //                               Divider(),
    //                             ],
    //                           );
    //                         },
    //                         child: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Text("Chunk: ${e.id}"),
    //                             SizedBox(height: 4),
    //                             Text(
    //                                 "Start: ${e.start} Bytes\nEnd: ${e.end} Bytes"),
    //                           ],
    //                         ),
    //                       ))
    //                   .toList(),
    //             ),
    //           ]
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
