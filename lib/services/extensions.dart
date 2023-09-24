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
