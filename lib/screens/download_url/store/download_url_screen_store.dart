import 'package:downloader/models/download_configs.dart';
import 'package:downloader/screens/list_downloads/download_details.dart';
import 'package:downloader/services/download_utility.dart';
import 'package:downloader/services/extensions.dart';
import 'package:downloader/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'download_url_screen_store.g.dart';

class DownloadUrlScreenStore = _DownloadUrlScreenStore
    with _$DownloadUrlScreenStore;

abstract class _DownloadUrlScreenStore with Store {
  final urlController = TextEditingController(
      text:
          "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_30mb.mp4");
  final chunkSizeController = TextEditingController(text: "20");

  @observable
  String? savePath;

  @observable
  ChunkTypes chunkType = ChunkTypes.number;

  @observable
  int size = 10;

  @observable
  int? _urlDownloadSize;

  @computed
  String get downloadSize {
    if (_urlDownloadSize == null) {
      return "Enter url to calculate size.";
    }

    return (_urlDownloadSize ?? 0.0).sizeString;
  }

  void onUrlUpdate(String url) async {
    final url = Uri.parse(urlController.text.trim());

    final size = await url.getDownloadSize();

    _urlDownloadSize = size;
  }

  void onChunkUpdated(String chunk) {}

  Future<void> download(BuildContext context) async {
    final regExp = RegExp(AppConstants.urlRegExp);
    final url = urlController.text.trim();

    if (url.isEmpty || regExp.hasMatch(url)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Entered url is not valid.'),
          ),
        );

      return;
    }

    final chunkSize = int.tryParse(chunkSizeController.text.trim()) ?? 0;

    if (chunkSize <= 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Chunk size must be > 0.'),
          ),
        );

      return;
    }

    if (savePath == null || savePath!.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text("Please select savePath first."),
          ),
        );

      return;
    }

    // TODO: Add other validations.

    final configs = DownloadConfigs()
      ..savePath = savePath!
      ..url = url
      ..chunkConfig = (ChunkConfigs()
        ..value = chunkSize
        ..type = chunkType);

    final result = await FileDownloaderUtility(
      configs: configs,
    ).download();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DownloadDetailsScreen(
          progress: result,
        ),
      ),
    );
  }
}
