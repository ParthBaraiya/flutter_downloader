/// {@template file_download_state_doc}
/// Transition between states takes place as given,
///
/// ideal -> queued -> downloading -> downloaded -> cleaning -> completed.
///
/// State can transit to error state from any states except completed.
///
/// State can transit to cancel state from any states except
/// completed, error and cleaning state.
///
/// Transition between states in progressive only. Means once a state is changed, it can not
/// go back to the previous state. E.g, If a FileDownload is in downloading state,
/// it can not go back to queued state.
/// {@endtemplate}

enum FileDownloadState {
  /// **This status is set when [FileDownloaderBase] object is created for new request.**
  ///
  ///
  /// {@macro file_download_state_doc}
  ideal, // Request is created.

  /// **This status is set when [FileDownloaderBase] object is added in download
  /// queue. i.e, a reference for this object will be stored in local database.**
  ///
  ///
  /// {@macro file_download_state_doc}
  queued, // Request is added in queue.

  /// **This status is set when [FileDownloaderBase] starts downloading the file.
  ///
  /// Even if a download is stopped in middle, it will continue the download
  /// where it left. All the download progress will be stored in local database.**
  ///
  ///
  /// {@macro file_download_state_doc}
  downloading, // Request is downloading.

  /// **This status is set when download is completed.**
  ///
  ///
  /// {@macro file_download_state_doc}
  downloaded, // Request if downloaded.

  /// **This status is set when app starts merging cache files in single output file.
  /// It also starts cleaning of cache.
  /// In this stage,All the chunk files will be merged in a single download file and
  /// will be stored at the destination.
  ///
  /// If possible, user should avoid closing the app,
  /// when this process is running.**
  ///
  ///
  /// {@macro file_download_state_doc}
  cleaning, // Request is cleaning.

  /// **This status is set when file is downloaded and stored in given space.**
  ///
  ///
  /// {@macro file_download_state_doc}
  completed, // Request is completed.

  /// **This status is set when there is some error while downloading the file or
  /// storing the file.**
  ///
  ///
  /// {@macro file_download_state_doc}
  error, // There is some error in request.

  /// **This status is set when user cancels the request.**
  ///
  ///
  /// {@macro file_download_state_doc}
  cancelled,
}

enum ChunkDownloadState {
  ideal,
  downloading,
  downloaded,
  completed,
  error,
}
