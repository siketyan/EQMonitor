import AVFAudio
import Flutter
import UIKit
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // This is required to make any communication available in the action isolate.
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    // cf. https://github.com/dlutton/flutter_tts/issues/344
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(
        AVAudioSession.Category.playback, mode: AVAudioSession.Mode.voicePrompt,
        options: [
          AVAudioSession.CategoryOptions.mixWithOthers, AVAudioSession.CategoryOptions.duckOthers,
        ])
    } catch {
      print("Setting category to AVAudioSessionCategoryPlayback failed.")
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
