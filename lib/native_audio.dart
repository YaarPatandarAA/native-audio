import 'package:flutter/services.dart';

class NativeAudio {
  static const _channel = const MethodChannel('com.danielgauci.native_audio');

  static const _nativeMethodPlay = "play";
  static const _nativeMethodPlayArgUrl = "url";
  static const _nativeMethodPlayArgTitle = "title";
  static const _nativeMethodPlayArgArtist = "artist";
  static const _nativeMethodPlayArgAlbum = "album";
  static const _nativeMethodPlayArgImageUrl = "imageUrl";
  static const _nativeMethodResume = "resume";
  static const _nativeMethodPause = "pause";
  static const _nativeMethodPrevious = "previous";
  static const _nativeMethodNext = "next";
  static const _nativeMethodStop = "stop";
  static const _nativeMethodSeekTo = "seekTo";
  static const _nativeMethodSeekToArgTimeInMillis = "timeInMillis";
  static const _nativeMethodRelease = "release";
  static const _flutterMethodOnLoaded = "onLoaded";
  static const _flutterMethodOnResumed = "onResumed";
  static const _flutterMethodOnPaused = "onPaused";
  static const _flutterMethodOnPrevious = "onPrevious";
  static const _flutterMethodOnNext = "onNext";
  static const _flutterMethodOnStopped = "onStopped";
  static const _flutterMethodOnProgressChanged = "onProgressChanged";
  static const _flutterMethodOnCompleted = "onCompleted";

  Function(Duration) onLoaded;
  Function() onResumed;
  Function() onPaused;
  Function() onPrevious;
  Function() onNext;
  Function() onStopped;
  Function onCompleted;
  Function(Duration) onProgressChanged;

  NativeAudio();

  void play(String url, {String title, String artist, String album, String imageUrl}) {
    _registerMethodCallHandler();
    _invokeNativeMethod(
      _nativeMethodPlay,
      arguments: <String, dynamic>{
        _nativeMethodPlayArgUrl: url,
        _nativeMethodPlayArgTitle: title,
        _nativeMethodPlayArgArtist: artist,
        _nativeMethodPlayArgAlbum: album,
        _nativeMethodPlayArgImageUrl: imageUrl,
      },
    );
  }

  void resume() {
    _invokeNativeMethod(_nativeMethodResume);
  }

  void pause() {
    _invokeNativeMethod(_nativeMethodPause);
  }

  void previous() {
    _invokeNativeMethod(_nativeMethodPrevious);
  }

  void next() {
    _invokeNativeMethod(_nativeMethodNext);
  }

  void stop() {
    _invokeNativeMethod(_nativeMethodStop);
  }

  void seekTo(Duration time) {
    _invokeNativeMethod(
      _nativeMethodSeekTo,
      arguments: <String, dynamic>{_nativeMethodSeekToArgTimeInMillis: time.inMilliseconds},
    );
  }

  void release() {
    _invokeNativeMethod(_nativeMethodRelease);
  }

  void _registerMethodCallHandler() {
    // Listen to method calls from native
    _channel.setMethodCallHandler((methodCall) {
      switch (methodCall.method) {
        case _flutterMethodOnLoaded:
          int durationInMillis = methodCall.arguments;
          if (onLoaded != null) onLoaded(Duration(milliseconds: durationInMillis));
          break;

        case _flutterMethodOnResumed:
          if (onResumed != null) onResumed();
          break;

        case _flutterMethodOnPaused:
          if (onPaused != null) onPaused();
          break;

        case _flutterMethodOnPrevious:
          if (onPrevious != null) onPrevious();
          break;

        case _flutterMethodOnNext:
          if (onNext != null) onNext();
          break;

        case _flutterMethodOnStopped:
          if (onStopped != null) onStopped();
          break;

        case _flutterMethodOnCompleted:
          if (onCompleted != null) onCompleted();
          break;

        case _flutterMethodOnProgressChanged:
          int currentTimeInMillis = methodCall.arguments;
          if (onProgressChanged != null) onProgressChanged(Duration(milliseconds: currentTimeInMillis));
          break;
      }

      return;
    });
  }

  Future _invokeNativeMethod(String method, {Map<String, dynamic> arguments}) async {
    try {
      await _channel.invokeMethod(method, arguments);
    } on PlatformException catch (e) {
      print("Failed to call native method: " + e.message);
    }
  }
}
