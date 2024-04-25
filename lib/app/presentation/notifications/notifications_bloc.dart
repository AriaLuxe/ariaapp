import 'dart:io';

import 'package:ariapp/app/domain/entities/push_message.dart';
import 'package:ariapp/firebase_options.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'notifications_event.dart';

part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationStatusChanged>(_notificationStatusChanged);
    on<NotificationRecived>(_onPushMessageRecived);

    // Verificar estado de las notificaciones
    _intialStatusCheck();
    // Listener para notificaciones en foreground
    _onForegroundMessage();
  }

  static Future<void> initializeFirebaseNotification() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _notificationStatusChanged(
      NotificationStatusChanged event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(
      status: event.status,
    ));
    //
    getFCMToken();
  }

  void _onPushMessageRecived(
      NotificationRecived event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(
      notifications: [event.notification, ...state.notifications],
    ));
    //
    getFCMToken();
  }

  void _intialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    settings.authorizationStatus;
    add(NotificationStatusChanged(status: settings.authorizationStatus));
  }

  Future<String> getFCMToken() async {
    if (state.status != AuthorizationStatus.authorized) return '';
    final token = await messaging.getToken();
    return token!;
  }

  void _handlerRemoteMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification == null) return;
    print('Message also contained a notification: ${message.notification}');
    final notification = PushMessage(
      messageId:
          message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
          ? message.notification!.android?.imageUrl
          : message.notification!.apple?.imageUrl,
    );
    add(NotificationRecived(notification: notification));
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(_handlerRemoteMessage);
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    add(NotificationStatusChanged(status: settings.authorizationStatus));
    settings.authorizationStatus;
  }
}
