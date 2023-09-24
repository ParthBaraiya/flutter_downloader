import 'package:downloader/models/download_configs.dart';
import 'package:downloader/services/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'download_url_screen_store.g.dart';

const sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];

class DownloadUrlScreenStore = _DownloadUrlScreenStore
    with _$DownloadUrlScreenStore;

abstract class _DownloadUrlScreenStore with Store {
  _DownloadUrlScreenStore() {
    urlController.addListener(() async {
      final url = Uri.parse(urlController.text.trim());

      final size = await url.getDownloadSize();

      _urlDownloadSize = size;
    });
  }

  final urlController = TextEditingController();
  final chunkSizeController = TextEditingController();

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

    var size = _urlDownloadSize ?? 0.0;
    var count = 0;

    while (size >= 1024 && count <= sizes.length) {
      size = size / 1000;
      count++;
    }

    return '${size.toStringAsFixed(1)}${sizes[count]}';
  }

  void onUrlUpdate(String url) {}

  void onChunkUpdated(String url) {}

  Future<void> download() async {}
}
