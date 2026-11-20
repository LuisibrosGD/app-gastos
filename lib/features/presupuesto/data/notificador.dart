import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../core/l10n/app_localizations.dart';

abstract interface class Notificador {
  Future<void> mostrar({required String titulo, required String cuerpo});
}

class NotificadorLocal implements Notificador {
  NotificadorLocal({required this.textos});

  static const _idCanal = 'presupuesto';
  static const _icono = 'ic_notificacion';

  final AppLocalizations Function() textos;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _inicializado = false;
  int _siguienteId = 0;

  Future<void> _inicializar() async {
    if (_inicializado) return;
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(_icono),
      ),
    );
    _inicializado = true;
  }

  Future<bool> pedirPermiso() async {
    await _inicializar();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return true;
    return await android.requestNotificationsPermission() ?? false;
  }

  @override
  Future<void> mostrar({
    required String titulo,
    required String cuerpo,
  }) async {
    await _inicializar();
    final detalle = AndroidNotificationDetails(
      _idCanal,
      textos().canalPresupuesto,
      importance: Importance.high,
      priority: Priority.high,
      icon: _icono,
    );
    await _plugin.show(
      id: _siguienteId++,
      title: titulo,
      body: cuerpo,
      notificationDetails: NotificationDetails(android: detalle),
    );
  }
}
