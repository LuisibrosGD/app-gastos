# 002 — Diseño: pantallas P01–P10 en Figma

**Estado:** PENDIENTE
**Tipo:** diseño
**Depende de:** 001
**Referencias:** SPEC §4, §5 (R4, R6, R7) · ARQUITECTURA §6

## Objetivo
Las 10 pantallas de la v1 diseñadas en Figma con los componentes de 001, y exportadas como PNG a `docs/diseno/`.

## Contexto
- El contenido de cada pantalla está en SPEC §4. No añadir funciones que no estén ahí (nada de exportar, nube, cuentas, etc.).
- Textos en español, con datos de ejemplo realistas en soles (S/ 12.50, "Almuerzo", "Taxi"…).
- Los frames deben llamarse con el ID de SPEC, porque las tareas de código los referencian así.

## Alcance
**Se puede crear o modificar:**
- El archivo de Figma "App Gastos" (página "Pantallas").
- `docs/diseno/P01.png` … `docs/diseno/P10.png` y los PNG de estados listados abajo.

**Fuera de alcance:** cambiar los tokens de 001 (si hace falta, ponla en `BLOQUEADA` y explícalo) y cualquier código.

## Pasos
1. Crear un frame de 360×800 por pantalla, llamado `Pxx — Nombre` (por ejemplo `P04 — Nuevo movimiento`).
2. Diseñar P01–P10 según SPEC §4, usando solo los componentes y tokens de 001.
3. Diseñar estos estados extra como frames aparte:
   - `P01b` PIN incorrecto con espera de 30 s (R6).
   - `P02a/b/c` los pasos del onboarding: idioma → categorías creadas → PIN opcional.
   - `P03b` Inicio vacío (sin movimientos) y `P03c` Inicio con banner de alerta de presupuesto.
   - `P04b` formulario con errores de validación (R7) y `P04c` modo edición con botón Borrar.
   - `P05b` lista vacía.
   - `P06b` resumen sin datos.
   - `P09b` formulario de categoría (selector de ícono y color).
   - `P08b` formulario de regla recurrente.
4. Exportar cada frame a `docs/diseno/<ID>.png` (por ejemplo `docs/diseno/P04b.png`).

## Criterios de aceptación
- [ ] Existen los PNG de P01–P10 y de todos los estados del paso 3.
- [ ] Cada pantalla contiene todos los elementos que lista SPEC §4 y ninguno fuera de alcance.
- [ ] La navegación inferior aparece en P03, P05, P06 y P10, con la pestaña activa marcada.
- [ ] Los montos de gasto e ingreso usan los colores `gasto` e `ingreso`.
- [ ] Solo se usan tokens y componentes de 001.

---

## Reporte de implementación
*(Lo escribe Command Code. No borrar los títulos.)*

**Enlace al archivo de Figma:**

**Archivos creados o modificados:**
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
