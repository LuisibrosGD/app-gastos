# 017 — Build release y prueba en el teléfono

**Estado:** PENDIENTE
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
- [ ] Primer arranque: onboarding en español, categorías creadas, PIN omitido.
- [ ] Crear un gasto con "12,50": aparece en Inicio como S/ 12.50.
- [ ] Editar el gasto y borrarlo.
- [ ] Crear un ingreso: el balance de Inicio se actualiza.
- [ ] P05: cambiar de mes y filtrar por categoría.
- [ ] P06: el gráfico circular y las barras muestran los datos.
- [ ] P09: crear una categoría; intentar borrar una con movimientos → se archiva.
- [ ] P07: presupuesto total pequeño; superar el 80 % → una sola notificación y banner en Inicio.
- [ ] P08: regla con el día de hoy → al reabrir la app aparece una sola vez.
- [ ] P10: cambiar a English → todo traducido; volver a Español.
- [ ] Activar PIN y huella; salir más de 1 minuto → pide desbloqueo; 5 PIN mal → espera de 30 s.
- [ ] Modo avión: todo sigue funcionando.
- [ ] Cerrar la app por completo y reabrirla: los datos siguen ahí.

## Criterios de aceptación
- [ ] `flutter build apk --release` genera el APK sin errores.
- [ ] Ningún secreto de firma está en el repo.
- [ ] Todo el checklist manual está marcado como OK, o los fallos están anotados y la tarea está en `BLOQUEADA`.
- [ ] `flutter analyze` sin errores ni advertencias.
- [ ] `flutter test` en verde.

---

## Reporte de implementación
*(Lo escribe Command Code. No borrar los títulos.)*

**Archivos creados o modificados:**
-

**Comandos ejecutados y resultado:**
- `flutter analyze` →
- `flutter test` →
- `flutter build apk --release` →

**Resultado del checklist manual:**
-

**Decisiones tomadas / desvíos del brief:**
-

**Dudas o problemas pendientes:**
-

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — fecha — resultado:**
-
