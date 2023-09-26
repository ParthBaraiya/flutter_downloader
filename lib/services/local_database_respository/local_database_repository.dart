import 'dart:async';
import 'dart:io';

import 'package:downloader/models/download_progress.dart';
import 'package:downloader/services/download_utility.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class LocalDatabaseRepository extends LocalDatabaseRepositoryInterface {
  Completer<Isar>? _completer;

  final String folder;

  LocalDatabaseRepository({
    required this.folder,
  });

  @override
  Future<void> init() async {
    if (_completer?.isCompleted ?? false) {
      await _completer!.future;
    }
    _completer = Completer<Isar>();

    try {
      final dir = Directory(
          path.join((await getApplicationDocumentsDirectory()).path, folder));

      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }

      final isar = await Isar.open(
        [DownloadProgressSchema],
        directory: dir.path,
      );

      if (!(_completer?.isCompleted ?? true)) {
        _completer?.complete(isar);
      }
    } catch (e) {
      _completer = null;
    }
  }

  @override
  Future<void> deleteDownload() {
    // TODO: implement deleteDownload
    throw UnimplementedError();
  }

  @override
  Future<void> fetchDownloads({DateTime? date}) {
    // TODO: implement fetchDownloads
    throw UnimplementedError();
  }

  @override
  Future<void> saveDownload(DownloadProgress progress) async {
    await _ensureInitialized();
  }

  @override
  Future<void> updateDownload(FileDownload progress) async {}

  Future<void> _ensureInitialized() async {
    if (_completer == null) {
      await init();
    }

    if (_completer == null) {
      throw 'Something went wrong.';
    }
  }
}

abstract class LocalDatabaseRepositoryInterface {
  Future<void> init();

  Future<void> saveDownload(DownloadProgress progress);

  Future<void> updateDownload(FileDownload progress);

  Future<void> deleteDownload();

  Future<void> fetchDownloads({DateTime? date});
}
