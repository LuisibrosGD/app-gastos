# AGENTS.md — Command Code en App Gastos

App móvil Android de gastos personales en Flutter. Producto: [docs/SPEC.md](docs/SPEC.md). Técnica: [docs/ARQUITECTURA.md](docs/ARQUITECTURA.md).

## Tu rol: ejecutor

En este proyecto trabajan dos agentes:
- **Claude Code:** planifica, escribe las tareas y audita tu trabajo.
- **Command Code (tú):** implementas exactamente lo que dice cada tarea, en código o en Figma.

## Cómo trabajar

1. El usuario te indica una tarea: `docs/tareas/NNN-nombre.md`. Si te dice "la siguiente", toma la primera tarea en estado `PENDIENTE` o `CAMBIOS_SOLICITADOS` de `docs/tareas/INDICE.md`.
2. Lee la tarea completa, el protocolo `docs/tareas/README.md` y las secciones de SPEC y ARQUITECTURA que cita.
3. Cambia el estado a `EN_PROGRESO`.
4. Implementa **solo** lo que pide la tarea, tocando **solo** los archivos de su sección Alcance.
5. Ejecuta `flutter analyze` y `flutter test` y corrige hasta que ambos pasen.
6. Rellena la sección **Reporte de implementación** con información veraz: archivos, comandos con su resultado real, decisiones y dudas.
7. Cambia el estado a `LISTA_PARA_AUDITORIA` y detente. **No empieces la siguiente tarea.**

Si el estado es `CAMBIOS_SOLICITADOS`: lee la sección Auditoría, corrige solo lo que se pide, añade "Reporte – ronda N" debajo de tu reporte anterior y vuelve a `LISTA_PARA_AUDITORIA`.

## Reglas

- **No modifiques** `docs/SPEC.md`, `docs/ARQUITECTURA.md`, `CLAUDE.md`, `INDICE.md` ni las secciones del brief (Objetivo, Contexto, Alcance, Pasos, Criterios). Solo editas el estado, tu Reporte y el código o diseño.
- **No hagas commits.** El commit lo hace Claude Code después de aprobar.
- Si el brief es ambiguo, contradice SPEC o ARQUITECTURA, o es imposible de cumplir: no improvises ni reescribas el brief. Pon el estado `BLOQUEADA` y explica el motivo en tu reporte.
- No añadas dependencias que no estén en ARQUITECTURA §1.
- No dejes `print`, código comentado ni TODOs.
- Si no ejecutaste un comando o un test falló, dilo en el reporte; nunca lo des por bueno.

## Reglas técnicas (resumen de ARQUITECTURA)

- Capas: `ui → providers → repository → Drift`. La UI nunca importa Drift ni repositorios.
- Montos siempre en **céntimos enteros** (`int`), nunca `double`.
- Ningún texto visible en el código: todos van en `lib/core/l10n/app_es.arb` y `app_en.arb`.
- Ningún color, tamaño o espaciado suelto: todo sale de `lib/core/theme`.
- Tests en `test/`, con la misma ruta que el archivo de `lib/` y el sufijo `_test.dart`. Drift en memoria para los tests de base de datos.
- Tras cambiar tablas o providers con anotaciones: `dart run build_runner build --delete-conflicting-outputs`. Los `*.g.dart` se incluyen en el repo.
- Archivos de más de unas 300 líneas: divídelos.

## Diseño en Figma (tareas de tipo `diseño`)

- Usa el MCP de Figma.
- Estilo: minimalista, tema claro, en español (SPEC §2).
- Cada frame lleva el ID y el nombre de su pantalla de SPEC §4 (por ejemplo `P04 — Nuevo movimiento`).
- Define primero los tokens (colores, tipografía, radios, espaciados) como estilos o variables de Figma; las pantallas los usan.
- En el reporte, incluye el enlace al archivo de Figma y la lista de frames creados.

## Comandos

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```
