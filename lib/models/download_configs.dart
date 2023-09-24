import 'dart:io';

import 'package:downloader/models/serializable.dart';
import 'package:downloader/services/extensions.dart';
import 'package:flutter/foundation.dart';

class DownloadConfigs extends Serializable {
  final Uri url;
  final String savePath;
  final ChunkConfigs chunkConfig;

  const DownloadConfigs({
    required this.savePath,
    required this.url,
    this.chunkConfig = const ChunkConfigs.init(),
  });

  DownloadConfigs setChunkConfigs(ChunkConfigs configs) => DownloadConfigs(
        savePath: savePath,
        url: url,
        chunkConfig: configs,
      );

  Future<int> getBytes() => url.getDownloadSize();

  @override
  Map<String, dynamic> toJson() => {
        'savePath': savePath,
        'url': '$url',
        'chunkConfigs': chunkConfig.toJson(),
      };
}

enum ChunkTypes { number, size }

class ChunkConfigs extends Serializable {
  final ChunkTypes type;
  final int value;

  const ChunkConfigs({
    required this.value,
    required this.type,
  }) : assert(value > 0);

  const ChunkConfigs.init()
      : type = ChunkTypes.number,
        value = 10;

  @override
  Map<String, dynamic> toJson() => {
        'size': value,
        'type': type.index,
      };
}

class DownloadProgress extends ValueNotifier<int> implements Serializable {
  final DownloadConfigs configs;
  final int totalSize;
  final List<ChunkProgress> chunks;
  final Future<File>? future;

  DownloadProgress({
    required this.chunks,
    required this.configs,
    required this.totalSize,
    required this.future,
  }) : super(-1);

  @override
  Map<String, dynamic> toJson() => {
        'downloadConfigs': configs.toJson(),
        'size': totalSize,
        'chunks': chunks.map((e) => e.toJson()).toList(),
      };
}

class ChunkProgress extends ValueNotifier<double> implements Serializable {
  final int id;
  final int start;
  final int end;
  final String filePath;
  final Future<File>? future;

  ChunkProgress({
    required this.id,
    required this.start,
    required this.end,
    required this.filePath,
    this.future,
  }) : super(0);

  ChunkProgress.completed({
    required this.id,
    required this.start,
    required this.end,
    required this.filePath,
    this.future,
  }) : super(1);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'start': start,
        'end': end,
        'file': filePath,
      };
}
