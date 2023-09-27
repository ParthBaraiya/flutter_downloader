import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

mixin Downloader on ChangeNotifier, DirectoryProvider {
  int _progress = 0;

  int get progress => _progress;

  set progress(int newProgress) {
    if (_progress != newProgress) {
      _progress = newProgress;
      notifyListeners();
    }
  }

  Future<void> init() => Future.value();

  Future<void> download();

  Future<void> clean() => Future.value();
}

mixin DirectoryProvider {
  Completer<Directory>? _completer;

  Future<Directory> get directory async {
    if (_completer != null) {
      try {
        final dir = await _completer!.future;

        return dir;
      } catch (e) {
        // Suppress error.
      }
    }

    _completer = Completer<Directory>();

    onFetchDirectory().then((value) {
      if (!_completer!.isCompleted) {
        _completer!.complete(value);
      }
    }).catchError((error) {
      if (!_completer!.isCompleted) {
        _completer!.completeError(error);
      }
    });

    return await _completer!.future;
  }

  Future<Directory> onFetchDirectory();
}
