import 'package:downloader/models/download_configs.dart';
import 'package:downloader/models/download_progress.dart';
import 'package:downloader/screens/download_url/store/download_url_screen_store.dart';
import 'package:downloader/services/navigation_service/navigation_service.dart';
import 'package:downloader/views/scaffold_title.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class DownloadUrlScreen extends StatefulWidget {
  const DownloadUrlScreen({super.key});

  @override
  State<DownloadUrlScreen> createState() => _DownloadUrlScreenState();
}

class _DownloadUrlScreenState extends State<DownloadUrlScreen> {
  final store = DownloadUrlScreenStore();

  DownloadProgress? _progress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     InkWell(
            //       onTap: () =>,
            //       borderRadius: BorderRadius.circular(30),
            //       child: Padding(
            //         padding: EdgeInsets.all(10),
            //         child: DownloaderIconLarge(
            //           icon: Icons.arrow_back,
            //         ),
            //       ),
            //     ),
            //     SizedBox(height: 20),
            //     Padding(
            //       padding: EdgeInsets.symmetric(
            //         horizontal: 20,
            //       ),
            //       child: ScaffoldTitle(title: ""),
            //     ),
            //   ],
            // ),

            ScaffoldTitleWithBack(
              onBack: () => DownloadUtilScreens.home.go(context),
              title: "File Downloader",
            ),

            SizedBox(height: 40),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Download URL",
                  style: TextStyle(fontSize: 14),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: store.urlController,
                    autofillHints: [AutofillHints.url],
                    onChanged: store.onUrlUpdate,
                    decoration: InputDecoration(
                      hintText: 'Enter file url',
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Observer(
                  builder: (_) => Text(
                    "Download Size: ${store.downloadSize}",
                  ),
                ),
              ],
            ),

            SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Save at:",
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        store.savePath =
                            await FilePicker.platform.getDirectoryPath();
                      },
                      child: Text('Select Folder'),
                    ),
                  ],
                ),
                Observer(
                  builder: (_) {
                    return Text(store.savePath ?? 'Select save path');
                  },
                ),
              ],
            ),

            SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Chunk type",
                      ),
                    ),
                  ],
                ),
                Observer(
                  builder: (_) {
                    return DropdownButtonFormField<ChunkTypes>(
                      value: store.chunkType,
                      items: ChunkTypes.values.map((e) {
                        return DropdownMenuItem<ChunkTypes>(
                          value: e,
                          child: Text(
                            e.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        store.chunkType = value ?? store.chunkType;
                        store.chunkSizeController.clear();
                      },
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Observer(
                        builder: (context) {
                          return Text(
                            store.chunkType == ChunkTypes.number
                                ? "Number of chunks"
                                : "Chunk size",
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Observer(builder: (context) {
                  return TextFormField(
                    controller: store.chunkSizeController,
                    keyboardType: TextInputType.number,
                    onChanged: store.onChunkUpdated,
                    decoration: InputDecoration(
                      hintText: store.chunkType == ChunkTypes.number
                          ? "How many chunks you want to use?"
                          : "Select size of one chunk",
                    ),
                  );
                }),
              ],
            ),

            SizedBox(height: 40),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () => store.download(context),
                child: Text("Start Download"),
              ),
            ),

            // ElevatedButton(
            //   onPressed: _startDownload,
            //   child: Text(
            //     "Start Download...",
            //   ),
            // ),
            // if (_progress != null)
            //   Expanded(
            //     child: ValueListenableBuilder(
            //       valueListenable: _progress!,
            //       builder: (_, snapshot, __) {
            //         if (snapshot >= 0) {
            //           return Text(
            //             "Creating File: ${((snapshot * 100) / _progress!.totalSize).toStringAsFixed(0)}",
            //           );
            //         }
            //
            //         return ListView(
            //           children: _progress!.chunks.map((e) {
            //             return ValueListenableBuilder(
            //               valueListenable: e,
            //               builder: (_, value, child) {
            //                 return Column(
            //                   children: [
            //                     child!,
            //                     LinearProgressIndicator(
            //                       value: value,
            //                     ),
            //                   ],
            //                 );
            //               },
            //               child: Column(
            //                 children: [
            //                   Text("Downloading Chunk: ${e.id}"),
            //                   Text("Start: ${e.start}, End: ${e.end}"),
            //                   Divider(),
            //                 ],
            //               ),
            //             );
            //           }).toList(),
            //         );
            //       },
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
