import 'dart:io';

extension URLExtension on Uri {
  Future<int> getDownloadSize() async {
    final response = await HttpClient().getUrl(this);
    final httpClientRequest = await response.close();

    final bytes =
        int.tryParse('${httpClientRequest.headers.value('content-length')}') ??
            0;

    return bytes;
  }
}

const sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];

extension IntExtension on num {
  String get sizeString {
    var size = this;
    var count = 0;

    while (size >= 1024 && count <= sizes.length) {
      size = size / 1000;
      count++;
    }

    return '${size.toStringAsFixed(1)}${sizes[count]}';
  }
}
