import 'package:downloader/models/download_configs.dart';
import 'package:downloader/screens/download_url/store/download_url_screen_store.dart';
import 'package:downloader/views/downloader_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class DownloadUrlScreen extends StatefulWidget {
  const DownloadUrlScreen({super.key});

  @override
  State<DownloadUrlScreen> createState() => _DownloadUrlScreenState();
}

class _DownloadUrlScreenState extends State<DownloadUrlScreen> {
  final store = DownloadUrlScreenStore();

  @override
  Widget build(BuildContext context) {
    return DownloaderScaffolds(
      title: "Download file",
      onBack: () => context.pop(),
      sliver: SliverPadding(
        padding: EdgeInsets.all(20),
        sliver: SliverList.list(
          children: [
            SizedBox(height: 20),
            DownloaderSection(
              title: 'Download URL',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: store.urlController,
                    autofillHints: [AutofillHints.url],
                    onChanged: store.onUrlUpdate,
                    decoration: InputDecoration(
                      hintText: 'Enter file url',
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
            ),
            SizedBox(height: 40),
            DownloaderSection(
              title: 'Save at',
              action: TextButton(
                onPressed: store.saveLocalPath,
                child: Text('Select Folder'),
              ),
              child: Observer(
                builder: (_) {
                  return Text(store.savePath ?? 'Select save path');
                },
              ),
            ),
            SizedBox(height: 40),
            DownloaderSection(
              title: 'Chunk type',
              child: Observer(
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
                    onChanged: store.saveChunkType,
                  );
                },
              ),
            ),
            SizedBox(height: 40),
            Observer(builder: (_) {
              return DownloaderSection(
                title: store.chunkType == ChunkTypes.number
                    ? "Number of chunks"
                    : "Chunk size (in bytes)",
                child: Observer(builder: (_) {
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
              );
            }),
            SizedBox(height: 40),
            Align(
              alignment: Alignment.center,
              child: Observer(builder: (_) {
                return ElevatedButton(
                  onPressed: store.enableButton ? store.download : null,
                  child: Text("Start Download"),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class DownloaderSection extends StatelessWidget {
  const DownloaderSection({
    super.key,
    required this.child,
    required this.title,
    this.action,
  });

  final String title;
  final Widget? action;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (action != null) action!,
          ],
        ),
        child,
      ],
    );
  }
}
