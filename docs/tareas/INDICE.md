# Plan de implementación — App Gastos v1

> **Para Command Code:** ejecuta las tareas **en orden y de una en una**, siguiendo [AGENTS.md](../../AGENTS.md) y el [protocolo](README.md). Al terminar cada una, déjala en `LISTA_PARA_AUDITORIA` y detente.

**Objetivo:** app Android de gastos personales, instalada en el teléfono del usuario y usada a diario.
**Arquitectura:** Flutter por features (`data → providers → ui`), Drift como única persistencia de dominio y Riverpod para el estado y las dependencias. Primero se hace el diseño en Figma, que define el tema en código.
**Stack:** Flutter, Drift, Riverpod, go_router, fl_chart, local_auth, flutter_local_notifications.
**Especificación:** [SPEC.md](../SPEC.md) (qué) + [ARQUITECTURA.md](../ARQUITECTURA.md) (cómo). Los dos documentos acompañan a cada tarea.

## Restricciones globales (aplican a TODAS las tareas)

- Solo Android, `minSdk 24`.
- Montos siempre en céntimos `int`. Formato de presentación `S/ 1,234.50`.
- Todo texto visible va en `app_es.arb` y `app_en.arb`, con las mismas claves en los dos.
- Colores, tamaños y espaciados solo desde `lib/core/theme`.
- Dependencias: solo las de ARQUITECTURA §1.
- Capas: `ui → providers → repository → Drift`. La UI nunca importa Drift.
- Funciona sin internet.
- `flutter analyze` sin advertencias y `flutter test` en verde al cerrar cada tarea.

## Puntos de atención (casos que la SPEC implica y que fallarían con facilidad)

| # | Caso | Comportamiento esperado | Lo prueba |
|---|---|---|---|
| A1 | Monto escrito como `12,50`, `12.5`, `0.999`, vacío o enorme | Se aceptan `,` y `.` como decimal; se rechazan más de 2 decimales, el texto no numérico y más de 99,999,999.99 | 003 |
| A2 | Editar un gasto cambiando su mes, su categoría o pasándolo a ingreso | Las alertas se revisan para el **nuevo** mes y la **nueva** categoría; un ingreso nunca dispara alertas; la categoría debe ser del tipo nuevo | 008, 011 |
| A3 | Regla mensual con día 31 en febrero de un año bisiesto, o con fecha de inicio futura | Se genera el 29-02-2028; con fecha de inicio futura no se genera nada | 013 |
| A4 | El usuario borra un movimiento que generó una regla recurrente | No se vuelve a crear en la siguiente generación | 013 |
| A5 | Teléfono sin huella, o huella eliminada después de activarla | Se cae al PIN sin errores; la opción de huella no aparece | 016 |

## Tareas

| Nº | Tarea | Tipo | Depende de | Estado |
|---|---|---|---|---|
| 001 | [Diseño: tokens y componentes en Figma](001-diseno-tokens-componentes.md) | diseño | — | APROBADA |
| 002 | [Diseño: pantallas P01–P10 en Figma](002-diseno-pantallas.md) | diseño | 001 | APROBADA |
| 003 | [Inicializar proyecto Flutter y utilidades base](003-init-proyecto.md) | configuración | — | APROBADA |
| 004 | [Tema desde los tokens de Figma](004-tema.md) | código | 001, 003 | APROBADA |
| 005 | [Base de datos: esquema v1](005-base-de-datos.md) | código | 003 | APROBADA |
| 006 | [Categorías: datos y pantalla P09](006-categorias.md) | código | 004, 005 | APROBADA |
| 007 | [Preferencias, idioma y onboarding P02](007-preferencias-onboarding.md) | código | 006 | APROBADA |
| 008 | [Movimientos: datos y controlador](008-movimientos-datos.md) | código | 006 | APROBADA |
| 009 | [Movimientos: pantallas P04 y P05](009-movimientos-ui.md) | código | 007, 008 | APROBADA |
| 010 | [Navegación, Inicio P03 y Ajustes P10](010-navegacion-inicio-ajustes.md) | código | 007, 009 | APROBADA |
| 011 | [Presupuesto: datos y alertas](011-presupuesto-datos-alertas.md) | código | 008 | APROBADA |
| 012 | [Presupuesto: pantalla P07 y avisos en Inicio](012-presupuesto-ui.md) | código | 010, 011 | APROBADA |
| 013 | [Recurrentes: lógica y generador](013-recurrentes-logica.md) | código | 011 | APROBADA |
| 014 | [Recurrentes: pantalla P08 y ciclo de vida](014-recurrentes-ui.md) | código | 010, 013 | APROBADA |
| 015 | [Resumen P06 con gráficos](015-resumen.md) | código | 010 | APROBADA |
| 016 | [Seguridad: PIN, huella y bloqueo P01](016-seguridad.md) | código | 014 | PENDIENTE |
| 017 | [Build release y prueba en el teléfono](017-release.md) | configuración | 001–016 | PENDIENTE |

Las tareas 001–002 (Figma) y 003 (init) son independientes y pueden hacerse en cualquier orden. La 004 necesita las dos ramas.
