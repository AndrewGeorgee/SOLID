abstract class MediaLoader {
  void loadMedia(String source);
  void unloadMedia();
}

abstract class AudioControls {
  void playAudio();
  void pauseAudio();
  void stopAudio();
  void adjustVolume(int level);
}

abstract class VideoControls {
  void playVideo();
  void pauseVideo();
  void stopVideo();
  void adjustBrightness(int level);
}

class AudioPlayer implements MediaLoader, AudioControls {
  String? _currentSource;

  @override
  void loadMedia(String source) {
    _currentSource = source;
    print('Loading audio: $source');
  }

  @override
  void unloadMedia() {
    _currentSource = null;
    print('Unloading audio');
  }

  @override
  void playAudio() {
    print('Playing audio: $_currentSource');
  }

  @override
  void pauseAudio() {
    print('Pausing audio');
  }

  @override
  void stopAudio() {
    print('Stopping audio');
  }

  @override
  void adjustVolume(int level) {
    print('Adjusting volume to $level');
  }
}

class VideoPlayer implements MediaLoader, VideoControls {
  String? _currentSource;

  @override
  void loadMedia(String source) {
    _currentSource = source;
    print('Loading video: $source');
  }

  @override
  void unloadMedia() {
    _currentSource = null;
    print('Unloading video');
  }

  @override
  void playVideo() {
    print('Playing video: $_currentSource');
  }

  @override
  void pauseVideo() {
    print('Pausing video');
  }

  @override
  void stopVideo() {
    print('Stopping video');
  }

  @override
  void adjustBrightness(int level) {
    print('Adjusting brightness to $level');
  }
}

/// Combines both capabilities without forcing either player to implement unused methods.
class MediaCenter implements MediaLoader, AudioControls, VideoControls {
  String? _currentSource;

  @override
  void loadMedia(String source) {
    _currentSource = source;
    print('Loading media: $source');
  }

  @override
  void unloadMedia() {
    _currentSource = null;
    print('Unloading media');
  }

  @override
  void playAudio() {
    print('Playing audio: $_currentSource');
  }

  @override
  void pauseAudio() {
    print('Pausing audio');
  }

  @override
  void stopAudio() {
    print('Stopping audio');
  }

  @override
  void adjustVolume(int level) {
    print('Adjusting volume to $level');
  }

  @override
  void playVideo() {
    print('Playing video: $_currentSource');
  }

  @override
  void pauseVideo() {
    print('Pausing video');
  }

  @override
  void stopVideo() {
    print('Stopping video');
  }

  @override
  void adjustBrightness(int level) {
    print('Adjusting brightness to $level');
  }
}
