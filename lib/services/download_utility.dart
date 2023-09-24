import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:downloader/models/download_configs.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileDownloaderUtility {
  final DownloadConfigs configs;

  FileDownloaderUtility({
    required this.configs,
  });

  int? _bytes;

  Future<DownloadProgress> download() async {
    try {
      if (_bytes == null) {
        _bytes = await configs.getBytes();
      }

      if (_bytes == null || _bytes == 0) {
        throw 'File not found error...';
      }

      final totalBytes = _bytes!;

      var chunks = 0;
      var chunkSize = 0;

      switch (configs.chunkConfig.type) {
        case ChunkTypes.number:
          chunks = configs.chunkConfig.value;
          chunkSize = (totalBytes / chunks).ceil();
          break;
        case ChunkTypes.size:
          chunkSize = math.min(totalBytes, configs.chunkConfig.value);
          chunks = (totalBytes / chunkSize).ceil();
          break;
      }

      if (chunks < 1 || chunkSize < 1) {
        throw 'Chunk or ChunkSize can not be < 1';
      }

      final futures = <Future<ChunkProgress>>[];

      for (int i = 0; i < chunks; i++) {
        final startByte = i * chunkSize;

        futures.add(
          _downloadChunk(
            startByte,
            (i == chunks - 1) ? totalBytes - 1 : startByte + chunkSize - 1,
            i,
          ),
        );
      }

      final results = await Future.wait(futures);

      final completer = Completer<File>();

      final progress = DownloadProgress(
        chunks: results,
        totalSize: totalBytes,
        configs: configs,
        future: completer.future,
      );

      Future.wait(results.where((e) => e.future != null).map((e) => e.future!))
          .then((value) async {
        final op = File(configs.savePath);

        progress.value = 0;

        if (!op.existsSync()) {
          op.createSync(recursive: true);
        }
        final sink = op.openWrite();

        for (final file in results) {
          final stream = File(file.filePath).openRead().asBroadcastStream();

          stream.listen((event) {
            progress.value += event.length;
          });

          await sink.addStream(stream);
        }

        await sink.close();

        results.forEach((element) {
          File(element.filePath).deleteSync();
        });

        if (!completer.isCompleted) {
          completer.complete(op);
        }
      });

      return progress;
    } catch (e) {
      print(e);

      throw 'Something went wrong.';
    }
  }

  Future<ChunkProgress> _downloadChunk(
      int startByte, int endByte, int chunkId) async {
    final response = await HttpClient().getUrl(configs.url);

    response.headers.add('range', 'bytes=$startByte-$endByte');

    final dir = (await getDownloadsDirectory())!.path;

    // final dir = (await getApplicationCacheDirectory()).path;

    final request = await response.close();

    final completer = Completer<File>();

    final file = File(path.join(
      dir,
      path.basename(configs.savePath),
      '${DateTime.now().millisecondsSinceEpoch}-$chunkId-$startByte-$endByte.chunk',
    ));

    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    final chunk = ChunkProgress(
      id: chunkId,
      start: startByte,
      end: endByte,
      filePath: file.path,
      future: completer.future,
    );

    final totalLen = endByte - startByte + 1;

    var progress = 0;

    final stream = request.asBroadcastStream();

    final subscription = stream.listen((event) {
      progress += event.length;

      chunk.value = progress / totalLen;
      print(
          "Chunk - $chunkId, Downloaded: ${event.length}, Progress: ${chunk.value}");
    });

    stream.toList().then((value) async {
      final bytes = value.expand((element) => element).toList();

      await file.writeAsBytes(bytes);

      subscription.cancel();

      if (!completer.isCompleted) {
        completer.complete(file);
      }
      print('Downloaded chunk $chunkId');
    });

    return chunk;
  }
}
