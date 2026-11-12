# 001 — Diseño: tokens y componentes en Figma

**Estado:** PENDIENTE
**Tipo:** diseño
**Depende de:** ninguna
**Referencias:** SPEC §2, §4 · ARQUITECTURA §6

## Objetivo
Un archivo de Figma "App Gastos" con el sistema de diseño (tokens y componentes base), exportado a `docs/diseno/tokens.md`.

## Contexto
- Estilo: minimalista, tema claro, sensación de calma y orden. Es una app personal, no corporativa.
- Lienzo base: Android 360×800 dp.
- Fuente: **Roboto** (no usar otra; la app no incluirá fuentes extra).
- Claude Code no tiene acceso a Figma: lo que no se exporte a `docs/diseno/` no se puede auditar.

## Alcance
**Se puede crear:**
- El archivo de Figma "App Gastos" (página "Sistema de diseño").
- `docs/diseno/tokens.md`
- `docs/diseno/componentes.png`

**Fuera de alcance:** pantallas (tarea 002) y cualquier código.

## Pasos
1. Crear variables o estilos de color:
   - `primario`, `primarioSuave`, `fondo`, `superficie`, `borde`, `textoPrincipal`, `textoSecundario`.
   - `ingreso` (verde), `gasto` (rojo), `alerta` (ámbar, para el 80 %), `error`.
   - `categoria01` … `categoria12`: 12 colores distinguibles entre sí y con contraste suficiente sobre `superficie`.
2. Crear estilos de texto en Roboto: `titulo` (22), `subtitulo` (18), `cuerpo` (16), `etiqueta` (14), `pequeno` (12) y `montoGrande` (32, para el balance). Indicar el peso y el interlineado de cada uno.
3. Definir radios (`radioS 8`, `radioM 12`, `radioL 20`) y espaciados en escala de 4 (`4, 8, 12, 16, 24, 32`).
4. Crear componentes:
   - Botón primario y secundario.
   - Campo de texto (normal, con foco y con error).
   - Campo de monto con prefijo `S/`.
   - Item de movimiento (ícono de categoría, nombre, nota, monto en color de ingreso o gasto).
   - Chip de categoría.
   - Tarjeta de balance.
   - Barra de progreso de presupuesto (normal, ≥ 80 %, ≥ 100 %).
   - Banner de alerta.
   - Barra de navegación inferior (4 pestañas: Inicio, Movimientos, Resumen, Ajustes).
   - Botón flotante **+**.
   - Teclado de PIN.
5. Exportar `docs/diseno/tokens.md` con tablas de: nombre del token → valor hexadecimal (colores), tamaño/peso/interlineado (texto) y valores numéricos (radios y espaciados).
6. Exportar la página de componentes como `docs/diseno/componentes.png`.

## Criterios de aceptación
- [ ] `docs/diseno/tokens.md` contiene **todos** los tokens del paso 1 al 3 con sus valores exactos.
- [ ] Los 12 colores de categoría tienen contraste ≥ 3:1 sobre `superficie`.
- [ ] `textoPrincipal` y `textoSecundario` tienen contraste ≥ 4.5:1 sobre `fondo`.
- [ ] `docs/diseno/componentes.png` muestra todos los componentes del paso 4 y sus estados.
- [ ] Los componentes usan los tokens, no valores sueltos.

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
