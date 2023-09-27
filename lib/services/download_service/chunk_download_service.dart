import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:downloader/services/download_service/download_utility.dart';
import 'package:downloader/services/download_service/downloader_interface.dart';
import 'package:downloader/values/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as path;

/// Data to store in database.
///
/// Download folder path
/// Start byte
/// End byte
/// Chunk Id
/// Save after
///
class ChunkDownload extends ChangeNotifier with DirectoryProvider, Downloader {
  /// Fields to store in database
  late int start;
  late int end;
  late String chunkId;

  @ignore
  int _progress = 0;

  @ignore
  int get progress => _progress;

  set progress(int newProgress) {
    if (_progress != newProgress) {
      _progress = newProgress;
      notifyListeners();
    }
  }

  @ignore
  ChunkDownloadState _state = ChunkDownloadState.ideal;

  @ignore
  ChunkDownloadState get state => _state;

  set state(ChunkDownloadState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  @ignore
  int get total => end - start + 1;

  @ignore
  late FileDownload parent;

  @ignore
  Future<File> get file => _getSaveFile();

  @ignore
  Future<Directory> get fileRoot => _getSaveFile().then(
        (value) => Directory(path.dirname(path.dirname(value.path))),
      );

  @protected
  ChunkDownload();

  ChunkDownload.fromSettings({
    required this.start,
    required this.end,
    required this.chunkId,
    required this.parent,
  });

  /// Starts download of a single chunk in the API.
  @override
  Future<void> download() async {
    if (state == ChunkDownloadState.completed) {
      throw 'No parent found.';
    }

    try {
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
      if (start + saved > end || state == ChunkDownloadState.error) {
        saved = 0;
        file.deleteSync();
        file.createSync();
      }

      progress = saved;

      // TODO: Update this to get start and end bytes from saved file.
      final response = await HttpClient().getUrl(Uri.parse(parent.url));

      response.headers.add('range', 'bytes=${start + saved}-$end');

      final request = await response.close();

      state = ChunkDownloadState.downloading;
      List<List<int>> bytes = [];
      int bytesLen = 0;

      Completer? completer = null;

      request.listen((event) {
        progress += event.length; // Total downloaded length.

        bytes.add(event);
        bytesLen += event.length; // Length after last save.

        if (bytesLen > math.min(parent.saveChunkAfter, total) &&
            (completer == null || completer!.isCompleted)) {
          completer = _save(bytes);

          bytes = <List<int>>[];
          bytesLen = 0;
        }
      });

      await request.last;

      state = ChunkDownloadState.completed;
    } catch (e) {
      state = ChunkDownloadState.error;
    }
  }

  @override
  Future<Directory> onFetchDirectory() async {
    // A directory for a single chunk.
    final chunkDir = Directory(path.join(
      (await parent.directory).path,
      '$chunkId-$start-$end-${DateTime.now().millisecondsSinceEpoch}.chunk',
    ));

    return chunkDir;
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
    return File(path.join((await directory).path, dataFile));
  }

  static const dataFile = 'chunk.data';
}
