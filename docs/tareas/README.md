# Tareas — protocolo Claude Code ↔ Command Code

Esta carpeta es el **único canal de comunicación** entre los dos agentes.

- **Claude Code** (planificador y auditor) crea las tareas y las audita.
- **Command Code** (ejecutor) las implementa e informa de lo que hizo.
- **El usuario** le indica a Command Code qué tarea ejecutar y le avisa a Claude Code cuándo auditar.

## Archivos

- Un archivo por tarea: `NNN-nombre-corto.md` (por ejemplo `003-tema-desde-figma.md`).
- La numeración es secuencial y define el orden de ejecución.
- [`_PLANTILLA.md`](_PLANTILLA.md) es el formato obligatorio.
- [`INDICE.md`](INDICE.md) lista todas las tareas y su estado.

## Estados

| Estado | Quién lo pone | Significado |
|---|---|---|
| `PENDIENTE` | Claude Code | Lista para que Command Code la tome |
| `EN_PROGRESO` | Command Code | La está implementando |
| `LISTA_PARA_AUDITORIA` | Command Code | Terminada; el reporte está escrito |
| `CAMBIOS_SOLICITADOS` | Claude Code | La auditoría encontró problemas; ver la sección Auditoría |
| `APROBADA` | Claude Code | Auditada y commiteada |
| `BLOQUEADA` | Cualquiera | No se puede continuar; el motivo se explica en el reporte o en la auditoría |

## Ciclo

```
Claude crea (PENDIENTE)
  → Command Code implementa (EN_PROGRESO → LISTA_PARA_AUDITORIA, escribe el Reporte)
    → Claude audita
        ├─ OK        → APROBADA + commit
        └─ problemas → CAMBIOS_SOLICITADOS
                         → Command Code corrige (añade "Reporte – ronda N")
                           → vuelve a LISTA_PARA_AUDITORIA
```

## Quién edita qué dentro de un archivo de tarea

| Sección | Claude Code | Command Code |
|---|---|---|
| Encabezado (estado) | Sí | Solo los estados `EN_PROGRESO`, `LISTA_PARA_AUDITORIA` y `BLOQUEADA` |
| Objetivo, Contexto, Alcance, Pasos, Criterios | Sí | **No** |
| Reporte de implementación | No | Sí |
| Auditoría | Sí | No |

Si Command Code cree que el brief está mal o es imposible de cumplir, no lo reescribe: pone `BLOQUEADA` y lo explica en su reporte.
