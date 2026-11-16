# 017 — Build release y prueba en el teléfono

**Estado:** BLOQUEADA
**Tipo:** configuración
**Depende de:** 001–016
**Referencias:** SPEC §7 (criterios de aceptación de la v1)

## Objetivo
Un APK release instalado en el teléfono del usuario y el checklist manual de la v1 completado.

## Contexto
Es una app personal que no se publica en Play Store. El APK se firma con una clave propia generada localmente; la clave y sus contraseñas **nunca** se suben al repo.

## Alcance
**Se puede crear o modificar:**
- `android/app/build.gradle(.kts)` (configuración de firma que lee `android/key.properties`)
- `.gitignore` (añadir `android/key.properties`, `*.jks`, `*.keystore`)
- El ícono de la app en `android/app/src/main/res/mipmap-*` (desde Figma, color `primario`)
- `docs/tareas/017-release.md`: solo el Reporte y el checklist de abajo

**Fuera de alcance:** funciones nuevas. Si en el checklist aparece un error, **no lo arregles aquí**: anótalo en el reporte, pon la tarea en `BLOQUEADA` y Claude Code creará una tarea de corrección.

## Pasos
1. Exportar desde Figma un ícono de 1024×1024 y generar los `mipmap` (íconos adaptativos de Android).
2. Configurar la firma release leyendo `android/key.properties`. El usuario genera la clave con `keytool` (dejar las instrucciones en el reporte) y crea `key.properties` localmente.
3. Comprobar que `git status` **no** muestra `key.properties` ni `.jks`.
4. `flutter analyze`, `flutter test` y `flutter build apk --release`.
5. El usuario instala el APK en su teléfono (por USB desde Android Studio o copiando el archivo) y recorre el checklist. Command Code anota los resultados que le informe el usuario.

## Checklist manual (en el teléfono)
- [x] Primer arranque: onboarding en español, categorías creadas, PIN omitido.
- [x] Crear un gasto con "12,50": aparece en Inicio como S/ 12.50.
- [x] Editar el gasto y borrarlo.
- [x] Crear un ingreso: el balance de Inicio se actualiza.
- [x] P05: cambiar de mes y filtrar por categoría. **OK (ronda 2):** con el APK nuevo, el botón de categoría abre el selector al primer arranque, filtra y se puede limpiar el filtro.
- [x] P06: el gráfico circular y las barras muestran los datos.
- [x] P09: crear una categoría; intentar borrar una con movimientos → se archiva. **OK (ronda 2):** además se pueden ver las archivadas y restaurar una; el gasto sigue en el historial.
- [ ] P07: presupuesto total pequeño; superar el 80 % → una sola notificación y banner en Inicio. **FALLA (ronda 2):** el banner aparece al momento, pero no llega ninguna notificación, ni siquiera con un presupuesto de categoría nuevo (prueba decisiva). Notificaciones de la app permitidas y canal «Presupuesto» activo. El 80 % no se repite porque ya se envió este mes (correcto); el 100 % era nuevo y tampoco llegó. Causa probable en el reporte.
- [x] P08: regla con el día de hoy → al reabrir la app aparece una sola vez.
- [x] P10: cambiar a English → todo traducido; volver a Español.
- [x] Activar PIN y huella; salir más de 1 minuto → pide desbloqueo; 5 PIN mal → espera de 30 s. **OK (ronda 2):** teclado de 4 dígitos con números desordenados, tecla de huella visible, 5 fallos → espera de 30 s y luego entra.
- [x] Modo avión: todo sigue funcionando.
- [x] Cerrar la app por completo y reabrirla: los datos siguen ahí.
- [x] Solo vertical (tarea 020): Inicio, Movimientos, Categorías y Recurrentes no giran con el teléfono en horizontal.
- [x] Categorías (tarea 020): el final de la lista y el botón quedan por encima de la barra del teléfono, sin quedar tapados.
- [x] Recurrentes (tarea 020): con nombre y monto largos, el monto se encoge o se corta con «…» y no choca con el interruptor.

## Criterios de aceptación
- [x] `flutter build apk --release` genera el APK sin errores.
- [x] Ningún secreto de firma está en el repo.
- [x] Todo el checklist manual está marcado como OK, o los fallos están anotados y la tarea está en `BLOQUEADA`.
- [x] `flutter analyze` sin errores ni advertencias.
- [x] `flutter test` en verde.

---

## Reporte de implementación
*(Lo escribe Command Code. No borrar los títulos.)*

**Archivos creados o modificados:**
- `android/app/build.gradle.kts`: firma release condicional desde `android/key.properties`, con firma de depuración como respaldo si no existe.
- `.gitignore`: `android/key.properties`, `*.jks`, `*.keystore`.
- `android/app/src/main/res/mipmap-*/ic_launcher.png` (48, 72, 96, 144 y 192 px).
- `android/app/src/main/res/mipmap-*/ic_launcher_foreground.png` (108, 162, 216, 324 y 432 px), `mipmap-anydpi-v26/ic_launcher.xml` y `values/colors.xml` para el ícono adaptativo.
- Ícono generado en Figma (nodo `35:2` del archivo `app-gasto`) y exportado a 1024×1024.

**Comandos ejecutados y resultado:**
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (140 tests)
- `flutter build apk --release` → `app-release.apk` (61.7 MB), sin errores.
- `flutter build apk --release --split-per-abi` → `app-armeabi-v7a-release.apk` (19.6 MB), `app-arm64-v8a-release.apk` (21.9 MB), `app-x86_64-release.apk` (23.2 MB).
- `git status --short` → no aparecen `key.properties`, `.jks` ni `.keystore`.
- `flutter devices` → solo Windows, Chrome y Edge; no hay teléfono ni emulador Android conectado.

**Resultado del checklist manual:**
- Ejecutado por el usuario en su teléfono con el APK arm64.
- OK: onboarding, gasto «12,50», editar/borrar, ingreso y balance, P06, P08, P10, PIN/huella con espera de 30 s, modo avión y persistencia tras cerrar la app.
- **Fallo P05:** en Movimientos, el botón de filtro por categoría no abre el selector; no pasa nada hasta reiniciar la app, y entonces sí funciona.
- **Fallo P09:** al borrar una categoría con movimientos se archiva correctamente y el gasto permanece en el historial, pero no existe ninguna vista para consultar las categorías archivadas.
- **Observación P07:** el banner del 80 % apareció; la notificación llegó una sola vez, pero con unos 5 minutos de retraso (al usar por primera vez una regla recurrente).

**Decisiones tomadas / desvíos del brief:**
- El ícono se creó en Figma con la API de generación vectorial (billetera blanca y monedas sobre fondo `#4054B2`) y se exportó a 1024×1024. Se generaron los mipmap clásicos y un ícono adaptativo (`anydpi-v26`) con fondo de color y foreground rasterizado.
- La firma release se activa sola cuando existe `android/key.properties`; sin ese archivo se firma con la clave de depuración para que el APK se pueda instalar y probar. El `storeFile` se resuelve respecto a `android/`.
- Instrucciones para la clave del usuario (ejecutar en `android/`):
  ```
  keytool -genkeypair -v -keystore app-gastos.jks -alias app-gastos ^
    -keyalg RSA -keysize 2048 -validity 10000
  ```
  Después crear `android/key.properties`:
  ```
  storePassword=...
  keyPassword=...
  keyAlias=app-gastos
  storeFile=app-gastos.jks
  ```
  y volver a ejecutar `flutter build apk --release`.
- APK recomendado para instalar: `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (21.9 MB). Instalación por USB: `adb install -r build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`.

**Dudas o problemas pendientes:**
- La tarea queda `BLOQUEADA` por dos fallos del checklist que, según el brief, no se corrigen aquí:
  1. P05: el filtro por categoría no responde hasta reiniciar la app.
  2. P09: no hay forma de ver las categorías archivadas.
- Revisar también el retraso de ~5 minutos de la notificación del presupuesto (P07); puede ser la entrega del sistema, pero conviene confirmarlo en la tarea de corrección.
- El APK actual usa la firma de depuración porque el usuario todavía no ha creado su clave. Al generarla y crear `key.properties`, el siguiente build usará la firma propia.

---

## Reporte – ronda 2 (2026-11-15)

**Motivo:** repetir en el teléfono P05, P09, P07 y el bloqueo con un APK nuevo después de las tareas 018–021, y comprobar en el teléfono lo de la tarea 020 (solo vertical, margen inferior y fila de recurrentes). No se tocó código.

**APK y comprobaciones:**
- `flutter analyze` → `No issues found!`
- `flutter test` → `All tests passed!` (159 tests)
- `flutter build apk --release --split-per-abi` → `app-armeabi-v7a-release.apk` (19.6 MB), `app-arm64-v8a-release.apk` (21.9 MB), `app-x86_64-release.apk` (23.2 MB), sin errores.
- APK instalado: `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`, encima del anterior y sin perder los datos.
- `android/key.properties` sigue sin existir: el APK se firma con la clave de depuración, igual que el anterior, por eso la actualización conservó los datos.
- `git status --short` → solo aparecen `docs/tareas/017-release.md` y `.commandcode/taste/taste.md` (este último no es de la tarea). `git check-ignore` confirma que `android/key.properties` y `*.jks` siguen ignorados.

**Resultado informado por el usuario:**
- P05 **OK**: el filtro abre al primer arranque y filtra.
- P09 **OK**: se ven las archivadas y se restauran.
- Bloqueo **OK**: PIN de 4 dígitos con números desordenados, tecla de huella, 5 fallos → espera de 30 s y luego entra.
- Solo vertical **OK** en Inicio, Movimientos, Categorías y Recurrentes.
- Categorías **OK**: el final de la lista no queda bajo la barra del teléfono.
- Recurrentes **OK**: con nombre y monto largos, el monto no choca con el interruptor.
- P07 **FALLA**: el banner sale al momento, pero no llega ninguna notificación.

**Análisis de la falla P07:**
- El aviso del 80 % no volvió a saltar este mes porque ya se había enviado en la prueba anterior; es el comportamiento correcto.
- El gasto pasó del 100 %, umbral que era nuevo, y tampoco notificó. Tampoco notificó un presupuesto de categoría nuevo por encima del 80 %, así que el fallo no depende del umbral ni del presupuesto.
- Las notificaciones de la app están permitidas y el canal «Presupuesto» activo.
- Causa probable: `NotificadorLocal` usa `@mipmap/ic_launcher` como ícono (`notificador.dart:24`) y no fija un `smallIcon` propio (`notificador.dart:46`). Desde esta tarea, en API 26+ ese mipmap resuelve a `mipmap-anydpi-v26/ic_launcher.xml`, que es un `<adaptive-icon>` y no sirve como ícono pequeño de notificación; al publicarla, `show` falla.
- El error queda invisible: `MovimientosController.guardar` envuelve `revisar` en `catch (_) {}` (`movimientos_providers.dart:56-62`) y `AlertasService` solo guarda la fila de `alertasEnviadas` después de `mostrar` (`alertas_service.dart:44-61`). Con la excepción no hay notificación, no hay fila y no hay rastro.
- No se corrige aquí por el Alcance del brief.

**Sugerencia para la tarea de corrección (no aplicada):**
- Añadir un drawable dedicado para la notificación (por ejemplo `res/drawable/ic_notificacion.xml`, monocromo) y usarlo en `AndroidInitializationSettings` y en `AndroidNotificationDetails(smallIcon:)`.
- Dejar de silenciar el fallo en `guardar`, para que un error de notificación no pase desapercibido.
- Verificar después el 80 % y el 100 % con un presupuesto nuevo: un aviso por umbral, sin duplicados.

**Estado:** `BLOQUEADA` por el fallo de P07, como pide el brief.

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — 2026-11-15 — BLOQUEADA (sigue así hasta cerrar 018–021)**

Verificado: `flutter analyze` sin problemas y `flutter test` 140 en verde. La firma lee `android/key.properties` y, si no existe, usa la de depuración. `key.properties`, `*.jks` y `*.keystore` están ignorados por git (`git check-ignore` lo confirma). El ícono adaptativo es correcto. Solo se tocaron archivos del Alcance. La configuración y el ícono se guardan ya en un commit parcial para que no se mezclen con las correcciones.

Fallos del checklist y tareas que los corrigen:
- P05, el filtro por categoría no abre: tarea 018. Causa probable: `movimientos_screen.dart:33-38` espera `categoriasPorTipoProvider(...).future` con `ref.read`. En Riverpod 3 un provider que nadie escucha queda en pausa, así que ese `future` puede no terminar nunca.
- P09, no se ven las archivadas: tarea 019. `categorias_screen.dart` usa el provider que las excluye, aunque la fila ya sabe mostrar «Archivada».
- Mejoras pedidas por el usuario: tareas 020 (solo vertical, margen inferior y fila de recurrentes) y 021 (teclado de PIN).
- Retraso de la notificación (P07): `notificador.dart` la muestra al instante con prioridad alta. Lo más probable es que el gasto recurrente se generara al reabrir la app, unos minutos después de crear la regla (R5), o que el sistema de ahorro de batería la retrasara. No se crea tarea. El usuario lo confirmará creando a mano un gasto que supere el 80 %.

Al cerrar 018–021: nuevo APK y repetir P05, P09, P07 y el bloqueo.

**Ronda 2 — 2026-11-16 — BLOQUEADA (esperando 022)**

Verificado: el diff solo toca el checklist y el reporte de esta tarea; no se cambió código desde el commit b6d3a39, donde `flutter analyze` salió limpio y `flutter test` dio 159 en verde. Correctos en el teléfono: P05, P09, bloqueo (4 dígitos desordenados, huella, 5 fallos → 30 s), solo vertical, final de Categorías y fila de Recurrentes. El análisis de que el 80 % no se repite en el mismo mes es correcto (R4, una alerta por umbral y mes).

P07 falla y la corrige la tarea 022. Hay dos causas posibles y la 022 cubre las dos:
- **Causa más probable (nueva):** `movimiento_form_screen.dart:127-129` llama a `guardar` con `ref.read(movimientosControllerProvider.notifier)` y nadie escucha ese provider. `MovimientosController` es `@riverpod` (se destruye solo cuando nadie lo usa). Tras el `await repositorio.crear(...)`, el `ref` puede estar ya destruido, y entonces `ref.read(alertasServiceProvider)` (`movimientos_providers.dart:58-60`) lanza una excepción que el `catch (_) {}` de la línea 61 oculta. Encaja con lo que se vio: en la ronda 1 sí llegó una notificación, pero desde el generador de recurrentes, que usa providers `keepAlive`. Ningún gasto creado a mano ha notificado nunca.
- **Causa posible (la del reporte):** usar como ícono pequeño `@mipmap/ic_launcher`, que ahora es adaptativo. Como en la ronda 1 llegó una notificación con ese mismo ícono, es menos probable, pero un drawable monocromo es lo que pide Android y se añade igual.
- En los dos casos el `catch (_) {}` impidió verlo. La 022 deja de silenciarlo.
