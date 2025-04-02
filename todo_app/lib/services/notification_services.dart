import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotifyHelper {
  // Singleton Pattern để đảm bảo chỉ có một instance của NotifyHelper
  static final NotifyHelper _instance = NotifyHelper._internal();
  factory NotifyHelper() => _instance;
  NotifyHelper._internal();

  // Khởi tạo plugin thông báo
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Phương thức khởi tạo thông báo
  Future<void> initializeNotification() async {
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("app_icon");

    final InitializationSettings initializationSettings =
        InitializationSettings(
          iOS: initializationSettingsIOS,
          android: initializationSettingsAndroid,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  // Yêu cầu quyền thông báo trên iOS
  void requestIOSPermissions() {
    NotifyHelper().flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: false, badge: false, sound: false);
  }

  // Hiển thị thông báo
  Future<void> displayNotification({
    required String title,
    required String body,
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id', // ID kênh
      'your_channel_name', // Tên kênh
      channelDescription: 'your channel description', // Mô tả
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Sử dụng singleton NotifyHelper để lấy instance của flutterLocalNotificationsPlugin
    await NotifyHelper().flutterLocalNotificationsPlugin.show(
      0, // ID thông báo
      'You change your theme',
      'You changed your theme back !',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}

// Xử lý khi nhận phản hồi từ thông báo
void onDidReceiveNotificationResponse(NotificationResponse response) {
  Get.dialog(
    AlertDialog(
      title: Text("Notification Clicked"),
      content: Text("Welcome to Flutter!"),
      actions: [TextButton(onPressed: () => Get.back(), child: Text("OK"))],
    ),
  );
}
