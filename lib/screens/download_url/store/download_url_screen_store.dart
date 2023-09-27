import 'package:downloader/models/download_configs.dart';
import 'package:downloader/services/download_service/download_utility.dart';
import 'package:downloader/services/extensions.dart';
import 'package:downloader/values/constants.dart';
import 'package:file_picker/file_picker.dart';
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

  @computed
  bool get enableButton {
    bool enableButton = true;

    final url = urlController.text.trim();

    if (url.isEmpty || RegExp(AppConstants.urlRegExp).hasMatch(url))
      return false;

    final chunkSize = int.tryParse(chunkSizeController.text.trim()) ?? 0;

    if (chunkSize <= 0) return false;

    if (savePath == null || savePath!.isEmpty) return false;

    return enableButton;
  }

  void onUrlUpdate(String url) async {
    final url = Uri.parse(urlController.text.trim());

    final size = await url.getDownloadSize();

    _urlDownloadSize = size;
  }

  void onChunkUpdated(String chunk) {}

  Future<void> saveLocalPath() async {
    savePath = await FilePicker.platform.getDirectoryPath();
  }

  void saveChunkType(ChunkTypes? value) {
    chunkType = value ?? chunkType;
    chunkSizeController.clear();
  }

  Future<void> download() async {
    if (!enableButton) return;

    final configs = DownloadConfigs()
      ..savePath = savePath!
      ..url = urlController.text.trim()
      ..chunkConfig = (ChunkConfigs()
        ..value = int.parse(chunkSizeController.text.trim())
        ..type = chunkType);

    final result = await FileDownload.fromSettings(
      size: _urlDownloadSize!,
      savePath: savePath!,
      url: urlController.text.trim(),
      chunkConfig: ChunkConfigs()
        ..value = int.parse(chunkSizeController.text.trim())
        ..type = chunkType,
    ).download();

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => DownloadDetailsScreen(
    //       progress: result,
    //     ),
    //   ),
    // );
  }

  void dispose() {
    urlController.dispose();
    chunkSizeController.dispose();
  }
}
