import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:eqmonitor/app.dart';
import 'package:eqmonitor/core/fcm/channels.dart';
import 'package:eqmonitor/core/provider/custom_provider_observer.dart';
import 'package:eqmonitor/core/provider/device_info.dart';
import 'package:eqmonitor/core/provider/log/talker.dart';
import 'package:eqmonitor/core/provider/package_info.dart';
import 'package:eqmonitor/core/provider/shared_preferences.dart';
import 'package:eqmonitor/feature/home/features/kmoni_observation_points/provider/kmoni_observation_points_provider.dart';
import 'package:eqmonitor/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);

  final talker = TalkerFlutter.init();
  FlutterError.onError = (error) {
    talker.handle(error.exception, error.stack, 'Uncaught fatal exception');
    FirebaseCrashlytics.instance.recordFlutterError(error);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    talker.handle(error, stack, 'Uncaught async exception');
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };
  final deviceInfo = DeviceInfoPlugin();

  final results = await (
    SharedPreferences.getInstance(),
    loadKmoniObservationPoints(),
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
    PackageInfo.fromPlatform(),
    // ignore: prefer_void_to_null
    (Platform.isAndroid ? deviceInfo.androidInfo : Future<Null>.value()),
    // ignore: prefer_void_to_null
    (Platform.isIOS ? deviceInfo.iosInfo : Future<Null>.value()),
    FlutterLocalNotificationsPlugin().initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('drawable/ic_launcher'),
      ),
    ),
    _registerNotificationChannelIfNeeded(),
  ).wait;
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(results.$1),
        kmoniObservationPointsProvider.overrideWithValue(results.$2),
        talkerProvider.overrideWithValue(talker),
        packageInfoProvider.overrideWithValue(results.$4),
        if (results.$5 != null)
          androidDeviceInfoProvider.overrideWithValue(results.$5!),
        if (results.$6 != null)
          iosDeviceInfoProvider.overrideWithValue(results.$6!),
      ],
      observers: [
        if (kDebugMode)
          CustomProviderObserver(
            talker,
          ),
      ],
      child: const App(),
    ),
  );
}

Future<void> _registerNotificationChannelIfNeeded() async {
  final androidNotificationPlugin = FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  if (androidNotificationPlugin == null) {
    return;
  }
  for (final group in notificationChannelGroups) {
    await androidNotificationPlugin.createNotificationChannelGroup(group);
  }
  for (final channel in notificationChannels) {
    await androidNotificationPlugin.createNotificationChannel(channel);
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    print('onBackgroundMessage: ${message.toMap()}');

    final flutterTts = FlutterTts();
    print('*** flutterTts: $flutterTts ***');
    await flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.ambient,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
      ],
      IosTextToSpeechAudioMode.voicePrompt,
    );
    await flutterTts.setSharedInstance(true);

    final ttsMessage = message.notification?.body ?? '通知が届きました';

    final tts = FlutterTts();
    await tts.reset();
    tts.setErrorHandler((error) {
      print('TTS ERROR: $error');
    });
    tts.setStartHandler(() {
      print('START');
    });
    tts.setProgressHandler((text, start, end, word) {
      print('PROGRESS: $text, $start, $end, $word');
    });
    print('START');
    final _ = await tts.speak(ttsMessage);
  } catch (e, stack) {
    print('onBackgroundMessage: $e\n$stack');

    await FlutterLocalNotificationsPlugin().show(
      1,
      '通知が届きました',
      e.toString(),
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          interruptionLevel: InterruptionLevel.critical,
        ),
      ),
    );
  }
}
