import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:downloader/models/download_configs.dart';
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

class FileDownload extends ValueNotifier<FileDownloadState> {
  /// isar document id.
  Id id = Isar.autoIncrement;

  late String url;
  late String savePath;
  late ChunkConfigs chunkConfig;
  late int size;
  late int retries;
  late int retryDelay; // Retry delay in seconds.

  /// NOTE: Avoid using this constructor. This is only for isar database usage.
  @protected
  FileDownload() : super(FileDownloadState.ideal);

  FileDownload.fromSettings({
    required this.url,
    required this.savePath,
    required this.chunkConfig,
    required this.size,
    this.retries = 10,
    this.retryDelay = 10,
  }) : super(FileDownloadState.ideal);

  /// Starts the download process.
  ///
  /// This handles the part where it, breaks the request in multiple parts,
  ///
  /// And initiates the download process for all the chunks.
  ///
  Future<void> download() async {
    try {
      if (size == 0) {
        value = FileDownloadState.error;
        return;
      }

      final totalBytes = size;

      final matrix = chunkConfig.calculateChunkMatrix(totalBytes);

      // for (int i = 0; i < chunks; i++) {
      //   final startByte = i * chunkSize;
      //
      //   futures.add(
      //     _downloadChunk(
      //       startByte,
      //       (i == chunks - 1) ? totalBytes - 1 : startByte + chunkSize - 1,
      //       i,
      //     ),
      //   );
      // }
      //
      // final results = await Future.wait(futures);

      final completer = Completer<File>();

      // final progress = DownloadProgress()
      //   ..chunks = results
      //   ..totalSize = totalBytes
      //   ..configs = configs
      //   ..future = completer.future;

      // Future.wait(results.where((e) => e.future != null).map((e) => e.future!))
      //     .then((value) async {
      //   final op = File(path.join(
      //     configs.savePath,
      //     configs.url.split("?").first.split("#").first.split("/").last,
      //   ));
      //
      //   progress.value = 0;
      //
      //   if (!op.existsSync()) {
      //     op.createSync(recursive: true);
      //   }
      //   final sink = op.openWrite();
      //
      //   for (final file in results) {
      //     final stream = File(file.filePath).openRead().asBroadcastStream();
      //
      //     stream.listen((event) {
      //       progress.value += event.length;
      //     });
      //
      //     await sink.addStream(stream);
      //   }
      //
      //   await sink.close();
      //
      //   results.forEach((element) {
      //     File(element.filePath).deleteSync();
      //   });
      //
      //   if (!completer.isCompleted) {
      //     completer.complete(op);
      //   }
      // });

      // return progress;
    } catch (e) {
      throw 'Something went wrong.';
    }
  }

  /// This handles the cleanup like, deleting unnecessary / merged files.
  Future<void> clean() {
    throw UnimplementedError();
  }
}

// Each download progress is stored in it's separate dir.
class ChunkDownload extends ChangeNotifier {
  late int start;
  late int end;
  late String chunkId;
  late String output;
  late int retries;
  late int retryDelay; // Retry delay in seconds.

  /// After how many bytes it should be saved in file.
  ///
  int saveAfter = 1000;

  ChunkDownloadState _state = ChunkDownloadState.ideal;

  ChunkDownloadState get state => _state;

  set state(ChunkDownloadState newState) {
    if (newState != _state) {
      _state = newState;
      notifyListeners();
    }
  }

  int _progress = 0;

  int get progress => _progress;

  set progress(int newProgress) {
    if (_progress != newProgress) {
      _progress = newProgress;
      notifyListeners();
    }
  }

  int get total => end - start + 1;

  // @ignore
  FileDownload? parent;

  String? _chunkDir;

  @protected
  ChunkDownload();

  ChunkDownload.fromSettings({
    required this.start,
    required this.end,
    required this.chunkId,
    required this.output,
    required this.parent,
    required this.retryDelay,
    required this.retries,
  });

  /// Starts download of a single chunk in the API.
  Future<void> download() async {
    if (parent == null) {
      throw 'No parent found.';
    }

    final file = await _getSaveFile();

    if (!file.existsSync()) {
      file.createSync();
    }

    var saved = file.lengthSync();

    /// If bytes stored in config is not equals to size of saved file, then there is something wrong with configs.
    ///
    /// If addition of start byte and downloaded bytes is > end byte that means
    /// there is something wrong while saving the configs.
    ///
    /// So, download entire chunk again.
    if (start + saved > end) {
      saved = 0;
      file.deleteSync();
      file.createSync();
    }

    progress = saved;

    // TODO: Update this to get start and end bytes from saved file.
    final response = await HttpClient().getUrl(Uri.parse(parent!.url));

    response.headers.add('range', 'bytes=${start + saved}-$end');

    final request = await response.close();

    List<List<int>> bytes = [];
    int bytesLen = 0;

    Completer? completer = null;

    request.listen((event) {
      progress += event.length; // Total downloaded length.

      bytes.add(event);
      bytesLen += event.length; // Length after last save.

      if (bytesLen > math.min(10000, total) &&
          (completer == null || completer!.isCompleted)) {
        completer = _save(bytes);

        bytes = <List<int>>[];
        bytesLen = 0;
      }
    });
  }

  Completer _save(List<List<int>> bytes) {
    Completer completer = Completer();

    _getSaveFile().then((file) {
      if (!file.existsSync()) {
        file.createSync();
      }

      final sink = file.openWrite(mode: FileMode.append);
      sink.add(bytes.expand((element) => element).toList());
      sink.close();
    });

    return completer;
  }

  Future<File> _getSaveFile() async {
    if (_chunkDir == null) {
      // TODO: If possible get this directory from saperate configs.
      final cache = (await getApplicationCacheDirectory()).path;

      // A directory for a single chunk.
      final chunkDir = Directory(path.join(
        cache,
        path.basename(parent!.savePath),
        '$chunkId-$start-$end-${DateTime.now().millisecondsSinceEpoch}.chunk',
      ));

      _chunkDir = chunkDir.path;
    }

    return File(path.join(_chunkDir!, dataFile));
  }

  static const dataFile = 'chunk.data';
}
