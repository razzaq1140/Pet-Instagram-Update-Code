import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'firebase_options.dart';
import 'src/core/notificartion.dart';
import 'src/features/buyer_and_seller/buyer/pages/controller/product_controller.dart';
import 'src/features/buyer_and_seller/seller/controller/seller_product_controller.dart';
import 'src/features/feed_and_recipe/controller/recipe_controller.dart';
import 'src/features/buyer_and_seller/seller/controller/seller_controller.dart';
import 'src/features/follower/controller/followers_controller.dart';
import 'src/features/profile/controller/other_profile_controller.dart';
import 'src/common/constants/global_variables.dart';
import 'src/features/_user_data/controllers/user_controller.dart';
import 'src/common/utils/shared_preferences_helper.dart';
import 'src/features/auth/pages/sign_in_page/controller/sign_in_controller.dart';
import 'src/features/auth/pages/sign_up_page/controller/sign_up_controller.dart';
import 'src/features/chat/group_chat/controller/group_chat_controller.dart';
import 'src/features/chat/group_chat/controller/group_messages_controller.dart';
import 'src/features/chat/individual_chat/controller/chat_room_controller.dart';
import 'src/features/home/controller/home_story_controller.dart';
import 'src/features/profile/controller/profile_controller.dart';
import 'src/features/settings/controller/settings_controller.dart';
import 'package:provider/provider.dart';
import 'src/features/home/controller/home_controller.dart';
import 'src/features/chat/individual_chat/controller/chat_message_controller.dart';
import 'src/router/routes.dart';
import 'src/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SharedPrefHelper.getInitialValue();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();
  final NotificationService notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.requestPermission();
  await notificationService.enableAutoInit();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ur'),
        Locale('ar'),
        Locale('nl'),
        Locale('fil'),
        Locale('el'),
        Locale('ja'),
        Locale('ru'),
        Locale('es'),
        Locale('tr'),
        Locale('de'),
        Locale('fa'),
        Locale('fr'),
        Locale('it'),
        Locale('ko'),
        Locale('pt'),
        Locale('sw'),
        Locale('zh'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      useOnlyLangCode: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeController()),
          ChangeNotifierProvider(create: (_) => HomeStoryController()),
          ChangeNotifierProvider(create: (_) => UserController()),
          ChangeNotifierProvider(create: (_) => ProfileController()),
          ChangeNotifierProvider(create: (_) => SignUpController()),
          ChangeNotifierProvider(create: (_) => SignInController()),
          ChangeNotifierProvider(create: (_) => SettingsController()),
          ChangeNotifierProvider(create: (_) => SellerProductController()),
          ChangeNotifierProvider(create: (_) => SellerController()),
          ChangeNotifierProvider(create: (_) => FollowersController()),
          ChangeNotifierProvider(create: (_) => RecipeController()),
          ChangeNotifierProvider(create: (_) => OtherProfileController()),
          ChangeNotifierProvider(create: (_) => ProductController()),
          ChangeNotifierProvider(create: (_) => ChatRoomController()),
          ChangeNotifierProvider(create: (_) => ChatMessagesController()),
          ChangeNotifierProvider(create: (_) => GroupChatController()),
          ChangeNotifierProvider(create: (_) => GroupMessagesController()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  int notificationId = generateRandomId();
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('notification_sound'),
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await FlutterLocalNotificationsPlugin().show(
    notificationId,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
    payload: 'item x',
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      overlayWidgetBuilder: (progress) => const Center(
        child:
            CircularProgressIndicator(color: Color.fromRGBO(42, 205, 195, 1)),
      ),
      child: MaterialApp.router(
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: scaffoldMessengerKey,
        theme: AppTheme.instance.lightTheme,
        routerConfig: MyAppRouter.router,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode &&
                supportedLocale.countryCode == locale?.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
      ),
    );
  }
}
