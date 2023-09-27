import 'dart:async';
import 'dart:io';

import 'package:downloader/models/download_configs.dart';
import 'package:downloader/services/download_service/chunk_download_service.dart';
import 'package:downloader/services/download_service/downloader_interface.dart';
import 'package:downloader/values/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

// class FileDownload {
//   final DownloadConfigs configs;
//
//   FileDownload({
//     required this.configs,
//   });
//
//   int? _bytes;
//
//   Future<DownloadProgress> download() async {
//     try {
//       if (_bytes == null) {
//         _bytes = await Uri.parse(configs.url).getDownloadSize();
//       }
//
//       if (_bytes == null || _bytes == 0) {
//         throw 'File not found error...';
//       }
//
//       final totalBytes = _bytes!;
//
//       var chunks = 0;
//       var chunkSize = 0;
//
//       switch (configs.chunkConfig.type) {
//         case ChunkTypes.number:
//           chunks = configs.chunkConfig.value;
//           chunkSize = (totalBytes / chunks).ceil();
//           break;
//         case ChunkTypes.size:
//           chunkSize = math.min(totalBytes, configs.chunkConfig.value);
//           chunks = (totalBytes / chunkSize).ceil();
//           break;
//       }
//
//       if (chunks < 1 || chunkSize < 1) {
//         throw 'Chunk or ChunkSize can not be < 1';
//       }
//
//       final futures = <Future<ChunkProgress>>[];
//
//       for (int i = 0; i < chunks; i++) {
//         final startByte = i * chunkSize;
//
//         futures.add(
//           _downloadChunk(
//             startByte,
//             (i == chunks - 1) ? totalBytes - 1 : startByte + chunkSize - 1,
//             i,
//           ),
//         );
//       }
//
//       final results = await Future.wait(futures);
//
//       final completer = Completer<File>();
//
//       final progress = DownloadProgress()
//         ..chunks = results
//         ..totalSize = totalBytes
//         ..configs = configs
//         ..future = completer.future;
//
//       Future.wait(results.where((e) => e.future != null).map((e) => e.future!))
//           .then((value) async {
//         final op = File(path.join(
//           configs.savePath,
//           configs.url.split("?").first.split("#").first.split("/").last,
//         ));
//
//         progress.value = 0;
//
//         if (!op.existsSync()) {
//           op.createSync(recursive: true);
//         }
//         final sink = op.openWrite();
//
//         for (final file in results) {
//           final stream = File(file.filePath).openRead().asBroadcastStream();
//
//           stream.listen((event) {
//             progress.value += event.length;
//           });
//
//           await sink.addStream(stream);
//         }
//
//         await sink.close();
//
//         results.forEach((element) {
//           File(element.filePath).deleteSync();
//         });
//
//         if (!completer.isCompleted) {
//           completer.complete(op);
//         }
//       });
//
//       return progress;
//     } catch (e) {
//       throw 'Something went wrong.';
//     }
//   }
//
//   Future<ChunkProgress> _downloadChunk(
//       int startByte, int endByte, int chunkId) async {
//     final completer = Completer<File>();
//
//     final dir = (await getDownloadsDirectory())!.path;
//
//     // final dir = (await getApplicationCacheDirectory()).path;
//
//     final file = File(path.join(
//       dir,
//       path.basename(configs.savePath),
//       '${DateTime.now().millisecondsSinceEpoch}-$chunkId-$startByte-$endByte.chunk',
//     ));
//
//     if (!file.existsSync()) {
//       file.createSync(recursive: true);
//     }
//
//     final chunk = ChunkProgress()
//       ..id = chunkId
//       ..start = startByte
//       ..end = endByte
//       ..filePath = file.path
//       ..future = completer.future
//       ..value = 0;
//
//     HttpClient().getUrl(Uri.parse(configs.url)).then((response) {
//       response.headers.add('range', 'bytes=$startByte-$endByte');
//
//       response.close().then((request) {
//         final totalLen = endByte - startByte + 1;
//
//         var progress = 0;
//
//         final stream = request.asBroadcastStream();
//
//         final subscription = stream.listen((event) {
//           progress += event.length;
//
//           chunk.value = progress / totalLen;
//         });
//
//         stream.toList().then((value) async {
//           final bytes = value.expand((element) => element).toList();
//
//           await file.writeAsBytes(bytes);
//
//           subscription.cancel();
//
//           if (!completer.isCompleted) {
//             completer.complete(file);
//           }
//         });
//       });
//     });
//
//     return chunk;
//   }
// }

/// Testing Links:
///
/// 1 GB: https://testfile-org.mavensx.com/Japan in 8K 60fps.mp4
/// 100 MB: https://jsoncompare.org/LearningContainer/SampleFiles/Video/MP4/Sample-Video-File-For-Testing.mp4

class FileDownload extends ChangeNotifier with DirectoryProvider, Downloader {
  //region ISAR configs
  /// isar document id.
  Id id = Isar.autoIncrement;

  /// URL from where file will be downloaded.
  late String url;

  /// Path where output file will be saved after download.
  late String savePath;

  /// Configuration of the chunks.
  late ChunkConfigs chunkConfig;

  /// Size of download file.
  late int size;

  /// Number of retries each chunk can make.
  late int retries;

  /// Seconds after retry should be make.
  late int retryDelay; // Retry delay in seconds.

  int saveChunkAfter =
      10000; // After 10 KB it will save the chunk in local file.

  List<ChunkDownload> chunks = [];

  String? cacheSaveDirectory;
  //endregion

  @ignore
  FileDownloadState _state = FileDownloadState.ideal;

  @ignore
  FileDownloadState get state => _state;

  set state(FileDownloadState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  @ignore
  bool _fromDatabase = true;

  @ignore
  String get fileName => url.split("?").first.split("#").first.split("/").last;

  @ignore
  Future? _futures;

  /// NOTE: Avoid using this constructor. This is only for isar database usage.
  @protected
  FileDownload() {
    state = FileDownloadState.queued;
  }

  FileDownload.fromSettings({
    required this.url,
    required this.savePath,
    required this.chunkConfig,
    required this.size,
    this.retries = 10,
    this.retryDelay = 10,
    this.saveChunkAfter = 10000,
  }) : _fromDatabase = false;

  /// Breaks the request in small chunks.
  @override
  Future<void> init() async {
    if (size == 0) {
      state = FileDownloadState.error;
      return;
    }

    if (!_fromDatabase) {
      final totalBytes = size;

      final matrix = chunkConfig.calculateChunkMatrix(totalBytes);

      final futures = <Future>[];
      for (int i = 0; i < matrix.count; i++) {
        final startByte = i * matrix.size;
        final endByte = (i == matrix.count - 1)
            ? totalBytes - 1
            : startByte + matrix.size - 1;

        final chunk = ChunkDownload.fromSettings(
          start: startByte,
          end: endByte,
          chunkId: '$i',
          parent: this,
        );

        futures.add(chunk.init());

        chunks.add(chunk);
      }

      await futures;
    }
  }

  /// Starts the download process.
  ///
  /// This handles the part where it, breaks the request in multiple parts,
  ///
  /// And initiates the download process for all the chunks.
  ///
  @override
  Future<void> download() async {
    try {
      if (chunks.isEmpty) {
        state = FileDownloadState.error;
        return;
      }

      _futures = Future.wait(chunks.map((e) => e.download()));

      await _futures;
    } catch (e) {
      throw 'Something went wrong.';
    }
  }

  /// This handles the cleanup like, deleting unnecessary / merged files.
  @override
  Future<void> clean() async {
    if (_futures == null) {
      return;
    }

    await _futures!;
    state = FileDownloadState.cleaning;

    final op = File(path.join(
      savePath,
      fileName,
    ));

    // progress.value = 0;

    if (!op.existsSync()) {
      op.createSync(recursive: true);
    }

    final sink = op.openWrite();

    for (final chunk in chunks) {
      final stream = (await chunk.file).openRead().asBroadcastStream();

      // stream.listen((event) {
      // progress.value += event.length;
      // });

      await sink.addStream(stream);
    }

    await sink.close();

    (await directory).deleteSync();
  }

  @override
  Future<Directory> onFetchDirectory() async {
    if (cacheSaveDirectory != null) {
      return Directory(cacheSaveDirectory!);
    }

    // TODO: If possible get this directory from separate configs.
    final cache = (await getApplicationCacheDirectory()).path;

    // A directory for a single chunk.
    final chunkDir = Directory(path.join(
      cache,
      path.basename(fileName),
    ));

    cacheSaveDirectory = chunkDir.path;

    return chunkDir;
  }
}
