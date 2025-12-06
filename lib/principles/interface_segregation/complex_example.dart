/// COMPLEX REAL-WORLD EXAMPLE: Multi-Media Processing System
///
/// Demonstrates Interface Segregation Principle with complex media
/// processing, editing, and publishing workflows.

// ============================================================================
// SEGREGATED INTERFACES - Each interface has a single, focused responsibility
// ============================================================================

/// Basic media file operations
abstract class IMediaFile {
  String getFilePath();
  String getFileName();
  int getFileSize();
  DateTime getCreatedDate();
  DateTime getModifiedDate();
}

/// Readable media interface
abstract class IReadableMedia {
  Future<String> readContent();
  Future<Map<String, dynamic>> getMetadata();
  bool isReadable();
}

/// Writable media interface
abstract class IWritableMedia {
  Future<void> writeContent(String content);
  Future<void> updateMetadata(Map<String, dynamic> metadata);
  bool isWritable();
}

/// Editable media interface
abstract class IEditableMedia {
  Future<void> applyFilter(String filterName);
  Future<void> crop({
    required int x,
    required int y,
    required int width,
    required int height,
  });
  Future<void> resize({required int width, required int height});
  Future<void> rotate(double degrees);
}

/// Compressible media interface
abstract class ICompressibleMedia {
  Future<void> compress({required int quality, String? algorithm});
  Future<int> getCompressedSize({required int quality});
  List<String> getSupportedCompressionAlgorithms();
}

/// Convertible media interface
abstract class IConvertibleMedia {
  Future<void> convertTo(String targetFormat);
  List<String> getSupportedFormats();
  bool canConvertTo(String format);
}

/// Publishable media interface
abstract class IPublishableMedia {
  Future<String> publishTo(String platform, Map<String, dynamic> options);
  List<String> getSupportedPlatforms();
  Future<void> schedulePublish(DateTime publishDate, String platform);
}

/// Streamable media interface
abstract class IStreamableMedia {
  Future<void> startStream(String streamUrl);
  Future<void> stopStream();
  bool isStreaming();
  Stream<String> getStreamData();
}

/// Shareable media interface
abstract class IShareableMedia {
  Future<String> generateShareLink({Duration? expiration});
  Future<void> shareToSocialMedia(
    String platform,
    Map<String, dynamic> options,
  );
  List<String> getSupportedSocialPlatforms();
}

// ============================================================================
// CONCRETE IMPLEMENTATIONS - Only implement needed interfaces
// ============================================================================

/// Text file - only readable and writable
class TextFile implements IMediaFile, IReadableMedia, IWritableMedia {
  final String _filePath;
  String _content;
  final DateTime _createdDate;
  DateTime _modifiedDate;

  TextFile({required String filePath, String content = ''})
    : _filePath = filePath,
      _content = content,
      _createdDate = DateTime.now(),
      _modifiedDate = DateTime.now();

  @override
  String getFilePath() => _filePath;

  @override
  String getFileName() => _filePath.split('/').last;

  @override
  int getFileSize() => _content.length;

  @override
  DateTime getCreatedDate() => _createdDate;

  @override
  DateTime getModifiedDate() => _modifiedDate;

  @override
  Future<String> readContent() async {
    return _content;
  }

  @override
  Future<Map<String, dynamic>> getMetadata() async {
    return {
      'type': 'text',
      'size': getFileSize(),
      'created': _createdDate.toIso8601String(),
      'modified': _modifiedDate.toIso8601String(),
    };
  }

  @override
  bool isReadable() => true;

  @override
  Future<void> writeContent(String content) async {
    _content = content;
    _modifiedDate = DateTime.now();
  }

  @override
  Future<void> updateMetadata(Map<String, dynamic> metadata) async {
    // Text files have limited metadata
  }

  @override
  bool isWritable() => true;
}

/// Image file - readable, writable, editable, compressible, convertible
class ImageFile
    implements
        IMediaFile,
        IReadableMedia,
        IWritableMedia,
        IEditableMedia,
        ICompressibleMedia,
        IConvertibleMedia {
  final String _filePath;
  final String _format;
  int _width;
  int _height;
  final DateTime _createdDate;
  DateTime _modifiedDate;
  Map<String, dynamic> _metadata = {};

  ImageFile({
    required String filePath,
    required String format,
    required int width,
    required int height,
  }) : _filePath = filePath,
       _format = format,
       _width = width,
       _height = height,
       _createdDate = DateTime.now(),
       _modifiedDate = DateTime.now();

  @override
  String getFilePath() => _filePath;

  @override
  String getFileName() => _filePath.split('/').last;

  @override
  int getFileSize() => _width * _height * 3; // Approximate

  @override
  DateTime getCreatedDate() => _createdDate;

  @override
  DateTime getModifiedDate() => _modifiedDate;

  @override
  Future<String> readContent() async {
    return 'Image data for $_filePath';
  }

  @override
  Future<Map<String, dynamic>> getMetadata() async {
    return {
      'type': 'image',
      'format': _format,
      'width': _width,
      'height': _height,
      'size': getFileSize(),
      ..._metadata,
    };
  }

  @override
  bool isReadable() => true;

  @override
  Future<void> writeContent(String content) async {
    // Image writing logic
    _modifiedDate = DateTime.now();
  }

  @override
  Future<void> updateMetadata(Map<String, dynamic> metadata) async {
    _metadata.addAll(metadata);
    _modifiedDate = DateTime.now();
  }

  @override
  bool isWritable() => true;

  @override
  Future<void> applyFilter(String filterName) async {
    print('Applying filter: $filterName to $_filePath');
    _modifiedDate = DateTime.now();
  }

  @override
  Future<void> crop({
    required int x,
    required int y,
    required int width,
    required int height,
  }) async {
    _width = width;
    _height = height;
    print('Cropped image to ${width}x$height');
    _modifiedDate = DateTime.now();
  }

  @override
  Future<void> resize({required int width, required int height}) async {
    _width = width;
    _height = height;
    print('Resized image to ${width}x$height');
    _modifiedDate = DateTime.now();
  }

  @override
  Future<void> rotate(double degrees) async {
    print('Rotated image by $degrees degrees');
    _modifiedDate = DateTime.now();
  }

  @override
  Future<void> compress({required int quality, String? algorithm}) async {
    print(
      'Compressing image with quality $quality using ${algorithm ?? 'default'}',
    );
    _modifiedDate = DateTime.now();
  }

  @override
  Future<int> getCompressedSize({required int quality}) async {
    final compressionRatio = quality / 100;
    return (getFileSize() * compressionRatio).round();
  }

  @override
  List<String> getSupportedCompressionAlgorithms() {
    return ['JPEG', 'PNG', 'WebP', 'HEIC'];
  }

  @override
  Future<void> convertTo(String targetFormat) async {
    print('Converting image from $_format to $targetFormat');
    _modifiedDate = DateTime.now();
  }

  @override
  List<String> getSupportedFormats() {
    return ['JPEG', 'PNG', 'GIF', 'BMP', 'WebP', 'TIFF'];
  }

  @override
  bool canConvertTo(String format) {
    return getSupportedFormats().contains(format.toUpperCase());
  }
}

/// Video file - readable, editable, compressible, convertible, publishable, streamable
class VideoFile
    implements
        IMediaFile,
        IReadableMedia,
        IEditableMedia,
        ICompressibleMedia,
        IConvertibleMedia,
        IPublishableMedia,
        IStreamableMedia {
  final String _filePath;
  final String _format;
  final Duration _duration;
  int _width;
  int _height;
  final DateTime _createdDate;
  DateTime _modifiedDate;
  bool _isStreaming = false;

  VideoFile({
    required String filePath,
    required String format,
    required Duration duration,
    required int width,
    required int height,
  }) : _filePath = filePath,
       _format = format,
       _duration = duration,
       _width = width,
       _height = height,
       _createdDate = DateTime.now(),
       _modifiedDate = DateTime.now();

  @override
  String getFilePath() => _filePath;

  @override
  String getFileName() => _filePath.split('/').last;

  @override
  int getFileSize() => _duration.inSeconds * _width * _height * 2; // Approximate

  @override
  DateTime getCreatedDate() => _createdDate;

  @override
  DateTime getModifiedDate() => _modifiedDate;

  @override
  Future<String> readContent() async {
    return 'Video data for $_filePath';
  }

  @override
  Future<Map<String, dynamic>> getMetadata() async {
    return {
      'type': 'video',
      'format': _format,
      'duration': _duration.inSeconds,
      'width': _width,
      'height': _height,
      'size': getFileSize(),
    };
  }

  @override
  bool isReadable() => true;

  @override
  Future<void> applyFilter(String filterName) async {
    print('Applying filter: $filterName to video');
    _modifiedDate = DateTime.now();
  }

  @override
  Future<void> crop({
    required int x,
    required int y,
    required int width,
    required int height,
  }) async {
    _width = width;
    _height = height;
    print('Cropped video to ${width}x$height');
    _modifiedDate = DateTime.now();
  }

  @override
  Future<void> resize({required int width, required int height}) async {
    _width = width;
    _height = height;
    print('Resized video to ${width}x$height');
    _modifiedDate = DateTime.now();
  }

  @override
  Future<void> rotate(double degrees) async {
    print('Rotated video by $degrees degrees');
    _modifiedDate = DateTime.now();
  }

  @override
  Future<void> compress({required int quality, String? algorithm}) async {
    print('Compressing video with quality $quality');
    _modifiedDate = DateTime.now();
  }

  @override
  Future<int> getCompressedSize({required int quality}) async {
    final compressionRatio = quality / 100;
    return (getFileSize() * compressionRatio).round();
  }

  @override
  List<String> getSupportedCompressionAlgorithms() {
    return ['H.264', 'H.265', 'VP9', 'AV1'];
  }

  @override
  Future<void> convertTo(String targetFormat) async {
    print('Converting video from $_format to $targetFormat');
    _modifiedDate = DateTime.now();
  }

  @override
  List<String> getSupportedFormats() {
    return ['MP4', 'AVI', 'MKV', 'MOV', 'WebM'];
  }

  @override
  bool canConvertTo(String format) {
    return getSupportedFormats().contains(format.toUpperCase());
  }

  @override
  Future<String> publishTo(
    String platform,
    Map<String, dynamic> options,
  ) async {
    print('Publishing video to $platform');
    return 'https://$platform.com/video/${getFileName()}';
  }

  @override
  List<String> getSupportedPlatforms() {
    return ['YouTube', 'Vimeo', 'Twitch', 'Facebook'];
  }

  @override
  Future<void> schedulePublish(DateTime publishDate, String platform) async {
    print('Scheduled publish to $platform on ${publishDate.toIso8601String()}');
  }

  @override
  Future<void> startStream(String streamUrl) async {
    _isStreaming = true;
    print('Started streaming to $streamUrl');
  }

  @override
  Future<void> stopStream() async {
    _isStreaming = false;
    print('Stopped streaming');
  }

  @override
  bool isStreaming() => _isStreaming;

  @override
  Stream<String> getStreamData() async* {
    while (_isStreaming) {
      yield 'Video stream data chunk';
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}

/// Social media post - publishable and shareable
class SocialMediaPost
    implements IMediaFile, IPublishableMedia, IShareableMedia {
  final String _filePath;
  final String _content;
  final List<String> _tags;
  final DateTime _createdDate;
  DateTime _modifiedDate;

  SocialMediaPost({
    required String filePath,
    required String content,
    List<String> tags = const [],
  }) : _filePath = filePath,
       _content = content,
       _tags = tags,
       _createdDate = DateTime.now(),
       _modifiedDate = DateTime.now();

  @override
  String getFilePath() => _filePath;

  @override
  String getFileName() => _filePath.split('/').last;

  @override
  int getFileSize() => _content.length;

  @override
  DateTime getCreatedDate() => _createdDate;

  @override
  DateTime getModifiedDate() => _modifiedDate;

  @override
  Future<String> publishTo(
    String platform,
    Map<String, dynamic> options,
  ) async {
    print('Publishing post to $platform');
    print('Content: $_content');
    print('Tags: ${_tags.join(', ')}');
    return 'https://$platform.com/post/${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  List<String> getSupportedPlatforms() {
    return ['Twitter', 'Facebook', 'Instagram', 'LinkedIn', 'TikTok'];
  }

  @override
  Future<void> schedulePublish(DateTime publishDate, String platform) async {
    print('Scheduled post to $platform on ${publishDate.toIso8601String()}');
  }

  @override
  Future<String> generateShareLink({Duration? expiration}) async {
    final link = 'https://share.example.com/${getFileName()}';
    print('Generated share link: $link');
    if (expiration != null) {
      print('Link expires in ${expiration.inDays} days');
    }
    return link;
  }

  @override
  Future<void> shareToSocialMedia(
    String platform,
    Map<String, dynamic> options,
  ) async {
    await publishTo(platform, options);
    print('Shared to $platform');
  }

  @override
  List<String> getSupportedSocialPlatforms() {
    return getSupportedPlatforms();
  }
}

// ============================================================================
// SERVICES - Work with specific interfaces, not concrete classes
// ============================================================================

/// Image processing service - only needs editing and compression interfaces
class ImageProcessingService {
  Future<void> processImage(IEditableMedia image, List<String> filters) async {
    for (final filter in filters) {
      await image.applyFilter(filter);
    }
  }

  Future<void> optimizeImage(
    ICompressibleMedia image,
    int targetQuality,
  ) async {
    await image.compress(quality: targetQuality);
  }

  Future<void> batchResize(
    List<IEditableMedia> images,
    int width,
    int height,
  ) async {
    for (final image in images) {
      await image.resize(width: width, height: height);
    }
  }
}

/// Publishing service - only needs publishing interface
class PublishingService {
  Future<List<String>> publishToMultiplePlatforms(
    List<IPublishableMedia> media,
    List<String> platforms,
  ) async {
    final publishedUrls = <String>[];

    for (final item in media) {
      for (final platform in platforms) {
        if (item.getSupportedPlatforms().contains(platform)) {
          final url = await item.publishTo(platform, {});
          publishedUrls.add(url);
        }
      }
    }

    return publishedUrls;
  }

  Future<void> scheduleBatchPublish(
    List<IPublishableMedia> media,
    DateTime publishDate,
    String platform,
  ) async {
    for (final item in media) {
      await item.schedulePublish(publishDate, platform);
    }
  }
}

/// Streaming service - only needs streaming interface
class StreamingService {
  Future<void> startMultiStream(
    List<IStreamableMedia> media,
    String baseUrl,
  ) async {
    for (int i = 0; i < media.length; i++) {
      await media[i].startStream('$baseUrl/stream$i');
    }
  }

  Future<void> stopAllStreams(List<IStreamableMedia> media) async {
    for (final item in media) {
      if (item.isStreaming()) {
        await item.stopStream();
      }
    }
  }
}

/// Conversion service - only needs conversion interface
class MediaConversionService {
  Future<void> batchConvert(
    List<IConvertibleMedia> media,
    String targetFormat,
  ) async {
    for (final item in media) {
      if (item.canConvertTo(targetFormat)) {
        await item.convertTo(targetFormat);
      }
    }
  }

  List<String> getCommonFormats(List<IConvertibleMedia> media) {
    if (media.isEmpty) return [];

    var commonFormats = Set<String>.from(media.first.getSupportedFormats());
    for (final item in media.skip(1)) {
      commonFormats = commonFormats.intersection(
        Set.from(item.getSupportedFormats()),
      );
    }

    return commonFormats.toList();
  }
}
