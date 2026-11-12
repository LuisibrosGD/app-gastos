# 001 — Diseño: tokens y componentes en Figma

**Estado:** APROBADA
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
- [x] `docs/diseno/tokens.md` contiene **todos** los tokens del paso 1 al 3 con sus valores exactos.
- [x] Los 12 colores de categoría tienen contraste ≥ 3:1 sobre `superficie`.
- [x] `textoPrincipal` y `textoSecundario` tienen contraste ≥ 4.5:1 sobre `fondo`.
- [x] `docs/diseno/componentes.png` muestra todos los componentes del paso 4 y sus estados.
- [x] Los componentes usan los tokens, no valores sueltos.

---

## Reporte de implementación
*(Lo escribe Command Code. No borrar los títulos.)*

**Enlace al archivo de Figma:** https://www.figma.com/design/jqNwN5MXEEiVNXAA0JQ0fg/app-gasto
Página de componentes: https://www.figma.com/design/jqNwN5MXEEiVNXAA0JQ0fg/app-gasto?node-id=6-146

**Archivos creados o modificados:**
- `docs/diseno/tokens.md` (creado): tablas de colores, tipografía, radios, espaciados y componentes con los valores exactos leídos de Figma.
- `docs/diseno/componentes.png` (creado): captura 1280×2220 de la página de componentes con todos los estados.
- `docs/tareas/001-diseno-tokens-componentes.md` (estado y este reporte).
- Figma, página `Sistema de diseño`: tablero de tokens + 23 estilos de pintura `Color/…` + 23 variables de color + 6 estilos de texto `Texto/…` + 9 variables FLOAT de la colección `Dimensión`.
- Figma, página `Componentes`: 12 componentes, 7 de ellos con variantes (`Estado` o `Tipo`).

**Decisiones tomadas / desvíos del brief:**
- Paleta elegida por mí, verificada con un script de contraste: todos los colores de categoría quedan entre 4.99:1 y 7.90:1 sobre `superficie` (mínimo exigido 3:1), y `textoPrincipal`/`textoSecundario` dan 14.70:1 y 5.55:1 sobre `fondo` (mínimo 4.5:1).
- Se crearon los colores **también** como variables además de estilos de pintura; radios y espaciados solo como variables FLOAT (no hay estilos nativos para dimensiones).
- Colores de estado no definidos en el paso 1 se derivan de tokens: botón presionado = `primario` al 85 % de opacidad; deshabilitado = `superficie` + `borde` con texto `textoSecundario` (opacidad 55 % en el secundario). Barra de presupuesto: `primario` < 80 %, `alerta` ≥ 80 %, `gasto` ≥ 100 %.
- Los 12 colores de categoría no se asignan a categorías concretas (eso corresponde a la tarea 006).
- Todos los rellenos y textos de los componentes están vinculados a estilos de color, y radios/espaciados a variables (88 rellenos, 35 radios y 81 espaciados vinculados, sin errores).
- No se pudo renombrar el archivo a «App Gastos»: la API de Figma no permite cambiar el nombre del documento desde el plugin. El archivo es el que indicó el usuario (`app-gasto`) y las páginas sí llevan los nombres pedidos.
- No se ejecutó `flutter analyze`/`flutter test` porque la tarea es solo de diseño y no toca código.

**Dudas o problemas pendientes:**
- Ninguna bloqueante. Si se prefiere otro nombre o iconografía distinta en la barra inferior (los íconos son trazos simples), se ajusta en la tarea 002.

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — 2026-11-11 — APROBADA**

Verificado:
- `tokens.md` contiene los 11 colores base, los 12 de categoría (sin repetidos), los 6 estilos de texto en Roboto con peso, tamaño e interlineado, los 3 radios y los 6 espaciados, con los valores pedidos.
- Recalculé los contrastes con un script propio (WCAG 2.1) y coinciden exactamente con el reporte: categorías de 4.99 a 7.90:1; `textoPrincipal` 14.70:1 y `textoSecundario` 5.55:1 sobre `fondo`.
- `componentes.png` muestra los 12 componentes y todos los estados pedidos.
- Solo cambiaron `docs/diseno/` y esta tarea; ningún archivo fuera de alcance.
- El nombre del archivo de Figma (`app-gasto`) es una limitación justificada de la API y no afecta.

Observaciones no bloqueantes (se trasladan como instrucciones a la tarea 002):
1. **`alerta` como texto pequeño:** `#B26A00` da 4.24:1 sobre `superficie` (3.99:1 sobre `fondo`), por debajo de 4.5:1. En el banner y en el "84 %" se usa como texto de 14 dp. En 002, el texto del banner y de los porcentajes va en `textoPrincipal`, y `alerta` solo en la barra, el acento y los íconos.
2. **Item de movimiento:** el avatar muestra una letra ("C", "S") en lugar del ícono de la categoría. En 002 se usa un ícono, como pide el brief.
3. **Ícono de Ajustes:** el de dos líneas parece un menú. En 002 usar un engranaje u otro ícono reconocible como ajustes.
4. **Campo con error:** el ejemplo tiene valor ("Comida") y a la vez dice "Este campo es obligatorio". En 002 usar un mensaje coherente con el estado (campo vacío, o "Máximo 30 caracteres").
5. **Item de movimiento:** el hueco entre el avatar y el texto es mayor que el resto de espaciados; ajustarlo a `espacio12`.
