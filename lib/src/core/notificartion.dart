import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import '/src/models/notification_model.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: iOSInitializationSettings(),
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print(
      //     'Received message while in foreground: ${message.notification?.title}');
      _showNotification(message);
    });
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print('Message clicked! ${message.notification?.title}');
      _showNotification(message);
    });
  }

  // Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  // //  print('Handling a background message: ${message.messageId}');
  //   _showNotification(message);
  // }

  Future<void> _showNotification(RemoteMessage message) async {
    int notificationId = generateRandomId();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      playSound: true, // Enable sound
      // sound: RawResourceAndroidNotificationSound('notification_sound'), // Uncomment for custom sound
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> requestPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      // print('User declined or has not accepted permission');
    }
  }

  Future<void> enableAutoInit() async {
    if (Platform.isAndroid) {
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
    }
  }

  static Future<String> getAccessToken() async {
    // print('Fetching access token...');

    final Map<String, dynamic> serviceToken = {
      "type": "service_account",
      "project_id": "pet-intagram",
      "private_key_id": "8456263fe1304a725ec81d0653d5ac89c767ab68",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCv7PXLHt42dIfS\nq53oGdhR+Ew/ysUek+JHTQGmbf1bqYrZk/wUP5Kq06xkEy5cf7p8uZXCSifIwC1i\n8sP+TE4xDHqjsRSi8DBVmCX74ePGQz1GkpnfX++hz1/f/Umvzu14GwCFUxskUD/j\nVGS2DpvUhgOhPt25ygjIs2qrLdSF75A0ZqZdMRQq4aLr3thtLvOGGGWQycNfpehK\ne5w3cjE43RcLkDb7K51WhjTpAzbMiHbFtPXElJLeImZl0Mqi03AY+sWoOA+Lwcup\nKFng+e39Pcw5nzUaKOrgtMz0WdWrTdkeLO9aYJJak+qMwKiaxVl8+2XYimvPGgpA\nk1mhHfibAgMBAAECggEARudUmxRqT/1AXqafYlPETSkrJgzFzJCiwsTlFNxAoChh\nV1be4pRKuwHL+ZuHdG1gTnOHycIUbcMSp84bMwsy+m7CoOW2YQM4H89OA8ojgJ1J\n/X8JeC9Ux9zqEb8may6Vo/ISECoSBt03GprBamTR5mJK5TqOp5onVyiEpdA3VvEt\nKAfSLvEb+0JcisHS/0tWMyv1yO8yRGciDp5mcv4pZZY6y8tSJU8Nh6873VO6Btbb\nvJcQC7RiZsHSw28IWNwO9xBqkxfGIFyHuLn3X7V4kJoLfwh94gK0n3AKry9i3QUb\ntcm0s9E+j8KBtn+nYE1NsF3x4bG82vKD3NnaKZjXYQKBgQD2odC2P5mt50rgNq92\nEEYJPrh7C41nX3WIdzGgJ7mCcy5RBDkItv3Cujr2oZ12r1Wy96Y+836y17+fW0dq\nbd+dwe6Q1YmhVNyydLE958dg1GO5C/KvcKUacmrqlxMPNHB41rllWJRuTxi7nqpA\nXOYfxD0MsXqYtX3mbDaZ29jNuwKBgQC2m50wus1/BgbZw49FCx7bKf3ldlWhHQ/7\n5zEksP2YD7gBnqppVn/8Umd/90cNarsNn+fzGTWRI+kPZjSmfVGab3BUDi6erFYc\ngySpxoxq/pk0j9H5DiVum6GP1azBD9p8Uu6tHHwiaCfSlGJnStQVp/Du7UCtPcHu\nU3nPe1lioQKBgE2hz8WeLWydEmeTLxXVt4XvdTheAYuZc7CZ/EfyWSVjxh+AWceR\nej0SS78YTi1usWYdJ/pGwQngeZPaspcgsLPCuKpkXOcohDO0IZpf29Vx5VX5GdH5\nfi7d9yOSnFA77G9M/5yUDlzOjvV30xVhaJp1NdZKA1IQRuoCBAnYNt1DAoGBALZX\n2bUpM75dpEWbU9sb6anr2o5hhcwmGyntiFMdMX3AZHupln0tVQv+tT9BCwBIzZQj\nUxia2bSe6UDpTDXb+bp/AOnOZ5smd65s/hVSIDFPHmkwG/nYuGQkoEXilmkKjZ+L\nqK3QPdyVqP5MEZ8XR4SAeMP8wZK8koSLcp1OjMlBAoGAL5XAdeuUTI7k+hfrArJc\n2cgkoRKd56u223H8U1Gp2w9D8V6/w9HRp9wEXStsPjuWB9Hu3vL4oWsTbNmAD1uH\nsMevs1FfvFx4Du/a+wfeilqh3H5T1Lb5cu3VSGfHPUruM53sZfSOCslGqShn4LMa\n0XlXuldpAk12BDm+S5Mr6Ho=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-1dbip@pet-intagram.iam.gserviceaccount.com",
      "client_id": "106625663482992419943",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-1dbip%40pet-intagram.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging'
    ];

    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceToken), scopes);

      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
              auth.ServiceAccountCredentials.fromJson(serviceToken),
              scopes,
              client);

      client.close();
      // print(
      //     'Access token fetched successfully: ${credentials.accessToken.data}');
      return credentials.accessToken.data;
    } catch (e) {
      // print('Error fetching access token: $e');
      throw Exception('Failed to fetch access token');
    }
  }

  static Future<void> sendNotification(
    String deviceToken,
    BuildContext context,
    String title,
    String userMessage,
  ) async {
    // print('Preparing to send notification...');
    final String serverAccessTokenKey = await getAccessToken();
    // print('Server access token: $serverAccessTokenKey');

    String endpointFirebaseCloudMessaging =
        'https://fcm.googleapis.com/v1/projects/pet-intagram/messages:send';

    final MessageModel message = MessageModel(
      token: deviceToken,
      notification: NotificationModel(
        title: title,
        body: userMessage,
      ),
    );

    try {
      final http.Response response = await http.post(
        Uri.parse(endpointFirebaseCloudMessaging),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverAccessTokenKey'
        },
        body: jsonEncode({
          'message': message.toJson(),
        }),
      );

      if (response.statusCode == 200) {
        // print('Notification sent successfully: ${response.body}');
      } else {
        // print('Error sending notification: ${response.body}');
        throw Exception('Failed to send notification');
      }
    } catch (e) {
      // print('Exception occurred while sending notification: $e');
      throw Exception('Failed to send notification');
    }
  }
}

int generateRandomId() {
  final Random random = Random();
  return random.nextInt(1000000);
}
