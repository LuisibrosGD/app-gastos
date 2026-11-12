# App Gastos — Especificación de diseño (v1)

**Fecha:** 2026-11-11
**Estado:** Aprobado en conversación, pendiente de revisión escrita

## 1. Propósito

App móvil de uso **personal** para controlar gastos e ingresos propios.
**Criterio de éxito de la v1:** la app está instalada en el teléfono Android del usuario y la usa a diario para registrar sus movimientos reales.

## 2. Restricciones y decisiones

| Tema | Decisión |
|---|---|
| Plataforma | Solo Android |
| Stack | Flutter + Drift (SQLite) + Riverpod + go_router |
| Datos | 100 % locales en el teléfono. Sin backend, sin cuentas, sin internet |
| Moneda | Una sola: Soles (PEN), formato `S/ 1,234.50` |
| Idiomas | Español (por defecto) e inglés, con archivos ARB (`flutter_localizations`) |
| Seguridad | Bloqueo opcional con PIN o huella (`local_auth`) |
| Estilo visual | Minimalista, tema claro |
| Diseño | Generado desde cero en Figma por Command Code (MCP de Figma) |
| Gráficos | `fl_chart` |
| Notificaciones | `flutter_local_notifications` (solo locales) |

### Roles de las herramientas
- **Claude Code:** planifica (especificación, plan, briefs de tareas) y audita (diff, análisis estático, tests, revisión de diseño). No edita código de la app.
- **Command Code:** genera el diseño en Figma e implementa el código según los briefs de tarea.
- **Usuario:** aprueba cada etapa, pasa las tareas a Command Code, hace los commits y prueba en su teléfono.

## 3. Alcance de la v1

**Incluido:**
1. Registrar, editar y borrar movimientos (gasto o ingreso).
2. Categorías personalizables (crear, editar, archivar) con nombre, ícono y color.
3. Balance mensual (ingresos − gastos).
4. Resumen con gráfico circular de gastos por categoría y barras de ingresos vs. gastos de los últimos 6 meses.
5. Presupuesto mensual total y, opcionalmente, presupuesto por categoría, con alertas al 80 % y al 100 %.
6. Movimientos recurrentes con frecuencia mensual o semanal.
7. Bloqueo con PIN y/o huella.
8. Interfaz en español e inglés.

**Fuera de alcance (v2 o posterior):** varias monedas, sincronización en la nube o login, exportar a Excel/CSV, copia de seguridad, foto de recibos, varias cuentas o métodos de pago, iOS, modo oscuro.

## 4. Pantallas

Navegación inferior con 4 pestañas: **Inicio · Movimientos · Resumen · Ajustes**.

| Pantalla | Contenido y comportamiento |
|---|---|
| Bloqueo | Se muestra al abrir la app y al volver tras más de 60 s en segundo plano, solo si el bloqueo está activo. Intenta primero con huella si está disponible y ofrece el PIN como respaldo. |
| Primera vez (onboarding) | Elegir idioma → crear las categorías por defecto → ofrecer configurar el PIN (se puede omitir). Solo aparece en el primer arranque. |
| Inicio | Balance del mes actual, barra de progreso del presupuesto total (si existe), aviso de alerta activa, últimos 5 movimientos y botón flotante **+**. |
| Nuevo / Editar movimiento | Selector gasto/ingreso, monto, categoría (filtrada por tipo), fecha (por defecto hoy) y nota opcional. En modo edición incluye **Borrar**, con confirmación. |
| Movimientos | Lista agrupada por día del mes seleccionado, con selector de mes y filtros por tipo y categoría. Al tocar un movimiento se abre la edición. |
| Resumen | Selector de mes, gráfico circular de gastos por categoría con leyenda y porcentajes, y gráfico de barras de ingresos vs. gastos de los últimos 6 meses. |
| Presupuesto | Monto total mensual y límites opcionales por categoría de gasto, con el progreso del mes actual. |
| Recurrentes | Lista de reglas (activas e inactivas) y formulario: tipo, monto, categoría, nota, frecuencia (mensual con día 1–31, o semanal con día de la semana), fecha de inicio y activo. |
| Categorías | Lista de categorías por tipo y formulario: nombre, ícono (de un set fijo) y color (de una paleta fija). Archivar en lugar de borrar si tiene movimientos. |
| Ajustes | Idioma, activar/desactivar bloqueo, cambiar PIN, usar huella, y accesos a Presupuesto, Recurrentes y Categorías. |

**Categorías por defecto:**
- Gasto: Comida, Transporte, Vivienda, Servicios, Salud, Entretenimiento, Compras, Educación, Otros.
- Ingreso: Sueldo, Extra, Otros.

## 5. Modelo de datos (Drift / SQLite)

Todos los montos son **enteros en céntimos** (S/ 12.50 → `1250`). Las fechas de los movimientos se guardan como fecha sin hora.

**categorias**
| Campo | Tipo | Notas |
|---|---|---|
| id | int PK autoincremental | |
| nombre | text | no vacío, ≤ 30 caracteres |
| icono | text | clave de un set fijo de íconos |
| color | int | valor ARGB de una paleta fija |
| tipo | enum `gasto` / `ingreso` | |
| archivada | bool | por defecto `false` |

**movimientos**
| Campo | Tipo | Notas |
|---|---|---|
| id | int PK | |
| tipo | enum `gasto` / `ingreso` | debe coincidir con el tipo de la categoría |
| monto_centimos | int | > 0 |
| fecha | date | |
| categoria_id | FK → categorias | obligatorio |
| nota | text, nullable | ≤ 200 caracteres |
| recurrente_id | FK → recurrentes, nullable | se rellena si lo generó una regla |
| creado_en | datetime | |

**presupuestos**
| Campo | Tipo | Notas |
|---|---|---|
| id | int PK | |
| categoria_id | FK, nullable, único | `null` = presupuesto total (como máximo uno) |
| monto_centimos | int | > 0 |

El presupuesto se aplica a **todos** los meses (es un límite mensual fijo, no uno por mes).

**recurrentes**
| Campo | Tipo | Notas |
|---|---|---|
| id | int PK | |
| tipo | enum | |
| monto_centimos | int | > 0 |
| categoria_id | FK | |
| nota | text, nullable | |
| frecuencia | enum `mensual` / `semanal` | |
| dia | int | mensual: 1–31; semanal: 1 (lunes) a 7 (domingo) |
| fecha_inicio | date | |
| ultima_generacion | date, nullable | última fecha para la que se generó un movimiento |
| activo | bool | |

**alertas_enviadas** (evita repetir notificaciones)
| Campo | Tipo | Notas |
|---|---|---|
| presupuesto_id | FK | |
| mes | text `YYYY-MM` | |
| umbral | int (80 o 100) | |
| PK compuesta | (presupuesto_id, mes, umbral) | |

**Fuera de la base de datos:**
- `shared_preferences`: idioma, onboarding completado, bloqueo activado, usar huella.
- `flutter_secure_storage`: hash del PIN (con sal), nunca el PIN en texto plano.

## 6. Arquitectura

```
lib/
  main.dart
  app.dart                 → MaterialApp.router, tema, localización
  core/
    database/              → AppDatabase (Drift), migraciones
    router/                → go_router y guarda de bloqueo
    theme/                 → colores y tipografía (desde Figma)
    l10n/                  → app_es.arb, app_en.arb
    utils/                 → formato de moneda y de fechas
  features/
    movimientos/ categorias/ presupuesto/ recurrentes/
    resumen/ seguridad/ ajustes/ onboarding/ inicio/
      data/        → tablas Drift y repositorio
      providers/   → providers de Riverpod
      ui/          → pantallas y widgets
test/                      → reflejo de lib/
```

**Reglas:**
- La UI solo habla con providers; los providers solo hablan con repositorios; solo los repositorios tocan Drift.
- Ninguna feature importa la carpeta `ui/` de otra feature.
- Ningún texto visible queda escrito directamente en el código: todo va en los ARB.
- Un archivo de más de unas 300 líneas es señal de que hay que dividirlo.

## 7. Lógica de negocio

### 7.1 Generación de recurrentes
- Se ejecuta al iniciar la app y al volver a primer plano.
- Para cada regla activa, calcula todas las fechas de ocurrencia en el rango (`ultima_generacion` o `fecha_inicio`, hoy], crea un movimiento por cada una y actualiza `ultima_generacion`, todo en una sola transacción.
- Si el día mensual no existe en ese mes (por ejemplo, día 31 en febrero), se usa el último día del mes.
- Es idempotente: ejecutarla dos veces seguidas no crea duplicados.

### 7.2 Alertas de presupuesto
- Después de crear, editar o generar un **gasto**, se calcula el gasto del mes de ese movimiento para el presupuesto total y para el de su categoría (si existe).
- Si el gasto cruza el 80 % o el 100 % y no existe una fila en `alertas_enviadas` para ese presupuesto, mes y umbral: se envía una notificación local y se inserta la fila.
- En Inicio se muestra un aviso mientras el gasto del mes actual sea ≥ 80 % de algún presupuesto.
- Si el usuario rechaza el permiso de notificaciones, solo se muestra el aviso en la app.

### 7.3 Bloqueo
- El PIN tiene 4–6 dígitos y se guarda como hash con sal.
- La huella solo se ofrece si el dispositivo la soporta y tiene alguna registrada.
- Tras 5 PIN incorrectos seguidos, se bloquea la entrada durante 30 s.
- Desactivar el bloqueo o cambiar el PIN exige introducir antes el PIN actual.

### 7.4 Formato
- Moneda con `intl`: `S/ 1,234.50` en ambos idiomas.
- Fechas según el idioma activo.

## 8. Errores y validaciones

- Formulario de movimiento: monto obligatorio y > 0 (máximo 2 decimales), categoría obligatoria, nota ≤ 200 caracteres. Los errores se muestran junto a cada campo.
- Si falla una escritura en la base, aparece un SnackBar con el error y el formulario conserva lo escrito.
- No se puede borrar una categoría con movimientos o reglas recurrentes: solo se archiva. Las categorías archivadas no aparecen en los selectores, pero sí en el historial.
- Borrar una regla recurrente no borra los movimientos que ya generó.
- **Riesgo aceptado:** los datos solo existen en el teléfono; si se pierde, se pierden los datos. La copia de seguridad queda para la v2.

## 9. Pruebas

- **Unitarias (Drift en memoria):** generación de recurrentes (meses cortos, varias ocurrencias atrasadas, idempotencia), cálculo de presupuesto y umbrales, sin alertas duplicadas, totales del resumen, hash y verificación del PIN.
- **Widget:** validaciones del formulario de movimiento y flujo de bloqueo con PIN.
- **Manual en dispositivo:** checklist de las pantallas en el teléfono del usuario antes de dar la v1 por terminada.

**Checklist de auditoría por tarea (Claude Code):**
1. `flutter analyze` sin errores ni advertencias.
2. `flutter test` en verde.
3. Se cumplen los criterios de aceptación del brief.
4. No se modificaron archivos fuera del alcance de la tarea.
5. Se respetan las reglas de la sección 6.

## 10. Flujo de trabajo

1. **Fase de diseño:** Command Code genera en Figma la guía de estilo (colores, tipografía, componentes) y las pantallas de la sección 4. El usuario comparte capturas o el enlace, y Claude Code las audita contra esta especificación.
2. **Reglas del agente:** un archivo de reglas para Command Code (stack, arquitectura, convenciones, comandos de verificación, "no salirse de la tarea"). Antes de crearlo hay que confirmar qué archivo lee Command Code (existe `.commandcode/` en el proyecto).
3. **Ciclo por tarea:** Claude Code escribe `docs/tasks/NNN-<nombre>.md` → el usuario se lo pasa a Command Code → Command Code implementa → Claude Code audita → si se aprueba, se hace commit; si no, las correcciones se anotan en el mismo brief.
4. **Requisitos previos:** Flutter SDK, Android SDK o Android Studio, y un teléfono Android con depuración USB activada.
