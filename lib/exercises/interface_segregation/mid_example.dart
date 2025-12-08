/// EXERCISE: Mid - Interface Segregation Principle
///
/// TASK: Refactor this code to follow Interface Segregation Principle.
/// Currently, MediaPlayer interface forces all classes to implement methods
/// they don't need (e.g., video players don't need audio-only methods).
///
/// HINT: Split into focused interfaces:
/// - AudioPlayer (play, pause, stop audio)
/// - VideoPlayer (play, pause, stop video)
/// - MediaPlayer (common operations)
/// Or use composition to combine capabilities.

abstract class MediaPlayer {
  // Audio methods
  void playAudio();
  void pauseAudio();
  void stopAudio();
  void adjustVolume(int level);

  // Video methods
  void playVideo();
  void pauseVideo();
  void stopVideo();
  void adjustBrightness(int level);

  // Common methods
  void loadMedia(String source);
  void unloadMedia();
}

/// AudioPlayer is forced to implement video methods it doesn't need
class AudioPlayer implements MediaPlayer {
  String? _currentSource;

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

  // Forced to implement video methods even though audio player doesn't support video
  @override
  void playVideo() {
    throw Exception('Audio player cannot play video!');
  }

  @override
  void pauseVideo() {
    throw Exception('Audio player cannot pause video!');
  }

  @override
  void stopVideo() {
    throw Exception('Audio player cannot stop video!');
  }

  @override
  void adjustBrightness(int level) {
    throw Exception('Audio player cannot adjust brightness!');
  }

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
}

/// VideoPlayer is forced to implement audio-only methods
class VideoPlayer implements MediaPlayer {
  String? _currentSource;

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

  // Forced to implement audio-only methods
  @override
  void playAudio() {
    throw Exception('Video player cannot play audio-only!');
  }

  @override
  void pauseAudio() {
    throw Exception('Video player cannot pause audio-only!');
  }

  @override
  void stopAudio() {
    throw Exception('Video player cannot stop audio-only!');
  }

  @override
  void adjustVolume(int level) {
    print('Adjusting volume to $level');
  }

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
}
