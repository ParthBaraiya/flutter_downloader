import 'dart:math' as math;

import 'package:downloader/models/serializable.dart';
import 'package:isar/isar.dart';

part 'download_configs.g.dart';

@embedded
class DownloadConfigs extends Serializable {
  late String url;
  late String savePath;
  late ChunkConfigs chunkConfig;

  DownloadConfigs setChunkConfigs(ChunkConfigs configs) => DownloadConfigs()
    ..savePath = savePath
    ..url = url
    ..chunkConfig = configs;

  @override
  Map<String, dynamic> toJson() => {
        'savePath': savePath,
        'url': '$url',
        'chunkConfigs': chunkConfig.toJson(),
      };
}

@embedded
class ChunkConfigs extends Serializable {
  @enumerated
  late ChunkTypes type;
  late int value;

  ChunkConfigs();

  ChunkConfigs.init()
      : type = ChunkTypes.number,
        value = 10;

  ChunkMatrix calculateChunkMatrix(int size) {
    // TODO: Add validations before starting the matrix calculations.

    var chunks = 0;
    var chunkSize = 0;

    switch (type) {
      case ChunkTypes.number:
        chunks = value;
        chunkSize = (size / chunks).ceil();
        break;
      case ChunkTypes.size:
        chunkSize = math.min(size, value);
        chunks = (size / chunkSize).ceil();
        break;
    }

    if (chunks < 1 || chunkSize < 1) {
      throw 'Chunk count and Chunk size must be greater than 0.';
    }

    return ChunkMatrix(
      count: chunks,
      size: chunkSize,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'size': value,
        'type': type.index,
      };
}

class ChunkMatrix {
  /// Number of chunks required to download the file based on [ChunkConfigs].
  final int count;

  /// Size of each chunk based on [ChunkConfigs].
  final int size;

  const ChunkMatrix({
    required this.count,
    required this.size,
  });
}

enum ChunkTypes { number, size }
