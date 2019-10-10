# Native Audio

An audio plugin for Flutter which makes use of the native Android and iOS audio players, handling playback, notifications and external controls (such as bluetooth).

## Getting Started

This plugin works on both Android and iOS, however the following setup is required for each platform.

### Android

#### 1. Application

Create or modify the `Application` class as follows:

```kotlin
class Application : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
        NativeAudioPlugin.setPluginRegistrantCallback(this)
    }

    override fun registerWith(registry: PluginRegistry) {
        GeneratedPluginRegistrant.registerWith(registry)
    }
}
```

This must be reflected in the application's `AndroidManifest.xml`. E.g.:

```xml
    <application
        android:name=".Application"
        ...
```

**Note:** Not calling `NativeAudioPlugin.setPluginRegistrant` will result in an exception being
thrown when audio is played.

#### 2. Service & Permissions

Add the following lines to your `AndroidManifest.xml` to register the background service for
geofencing:

```xml
<receiver android:name="androidx.media.session.MediaButtonReceiver">
    <intent-filter>
        <action android:name="android.intent.action.MEDIA_BUTTON" />
    </intent-filter>
</receiver>

<service android:name="com.danielgauci.native_audio.AudioService">
    <intent-filter>
        <action android:name="android.intent.action.MEDIA_BUTTON" />
        <action android:name="android.media.browse.MediaBrowserService" />
    </intent-filter>
</service>
```

As well as the following lines to setup the permissions required:

```xml
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
```

### iOS

No setup is required for iOS 🍏