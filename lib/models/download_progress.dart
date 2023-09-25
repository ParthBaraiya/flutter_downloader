import 'dart:io';

import 'package:downloader/models/download_configs.dart';
import 'package:downloader/models/serializable.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'download_progress.g.dart';

@collection
class DownloadProgress extends ValueNotifier<int> implements Serializable {
  Id id = Isar.autoIncrement;

  late DownloadConfigs configs;
  late int totalSize;
  late List<ChunkProgress> chunks;
  late DateTime timestamp;

  @ignore
  Future<File>? future;

  DownloadProgress() : super(0);

  @override
  Map<String, dynamic> toJson() => {
        'downloadConfigs': configs.toJson(),
        'size': totalSize,
        'chunks': chunks.map((e) => e.toJson()).toList(),
      };
}

@embedded
class ChunkProgress extends ValueNotifier<double> implements Serializable {
  late int id;
  late int start;
  late int end;
  late String filePath;

  @ignore
  Future<File>? future;

  ChunkProgress() : super(1);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'start': start,
        'end': end,
        'file': filePath,
      };
}
