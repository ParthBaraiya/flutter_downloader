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

  @override
  Map<String, dynamic> toJson() => {
        'size': value,
        'type': type.index,
      };
}

enum ChunkTypes { number, size }
