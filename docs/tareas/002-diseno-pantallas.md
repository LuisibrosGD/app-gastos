# 002 — Diseño: pantallas P01–P10 en Figma

**Estado:** APROBADA
**Tipo:** diseño
**Depende de:** 001
**Referencias:** SPEC §4, §5 (R4, R6, R7) · ARQUITECTURA §6

## Objetivo
Las 10 pantallas de la v1 diseñadas en Figma con los componentes de 001, y exportadas como PNG a `docs/diseno/`.

## Contexto
- El contenido de cada pantalla está en SPEC §4. No añadir funciones que no estén ahí (nada de exportar, nube, cuentas, etc.).
- Textos en español, con datos de ejemplo realistas en soles (S/ 12.50, "Almuerzo", "Taxi"…).
- Los frames deben llamarse con el ID de SPEC, porque las tareas de código los referencian así.
- **Correcciones de la auditoría de 001** (aplicarlas también a los componentes de la página `Componentes` y volver a exportar `docs/diseno/componentes.png`):
  1. `alerta` no se usa para texto: el título del banner y los porcentajes van en `textoPrincipal`; `alerta` solo en la barra, el acento y los íconos.
  2. El avatar del item de movimiento muestra un **ícono** de categoría, no una letra.
  3. El ícono de la pestaña Ajustes es un engranaje (o equivalente reconocible).
  4. El ejemplo del campo con error tiene un mensaje coherente con su contenido.
  5. El hueco entre el avatar y el texto del item de movimiento es `espacio12`.

## Alcance
**Se puede crear o modificar:**
- El archivo de Figma "App Gastos" (página "Pantallas").
- `docs/diseno/P01.png` … `docs/diseno/P10.png` y los PNG de estados listados abajo.
- La página `Componentes` y `docs/diseno/componentes.png` (solo para las correcciones de 001).

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
- [x] Existen los PNG de P01–P10 y de todos los estados del paso 3.
- [x] Cada pantalla contiene todos los elementos que lista SPEC §4 y ninguno fuera de alcance.
- [x] La navegación inferior aparece en P03, P05, P06 y P10, con la pestaña activa marcada.
- [x] Los montos de gasto e ingreso usan los colores `gasto` e `ingreso`.
- [x] Solo se usan tokens y componentes de 001.

---

## Reporte de implementación
*(Lo escribe Command Code. No borrar los títulos.)*

**Enlace al archivo de Figma:** https://www.figma.com/design/jqNwN5MXEEiVNXAA0JQ0fg/app-gasto
Página `Pantallas` en el mismo archivo. Página `Componentes`: https://www.figma.com/design/jqNwN5MXEEiVNXAA0JQ0fg/app-gasto?node-id=6-146

**Archivos creados o modificados:**
- `docs/diseno/P01.png`, `P01b.png`, `P02a.png`, `P02b.png`, `P02c.png`, `P03.png`, `P03b.png`, `P03c.png`, `P04.png`, `P04b.png`, `P04c.png`, `P05.png`, `P05b.png`, `P06.png`, `P06b.png`, `P07.png`, `P08.png`, `P08b.png`, `P09.png`, `P09b.png`, `P10.png` (21 archivos, 360×800 px).
- `docs/diseno/componentes.png` (reexportado tras las correcciones).
- `docs/tareas/002-diseno-pantallas.md` (estado y este reporte).
- Figma, página `Pantallas`: 21 frames de 360×800 con los nombres `Pxx — Nombre`.
- Figma, página `Componentes`: correcciones de la auditoría de 001 aplicadas.

**Decisiones tomadas / desvíos del brief:**
- Correcciones de 001 aplicadas: títulos del banner y porcentajes de la barra en `textoPrincipal` (el `alerta` queda solo en acento y relleno de la barra); avatares con ícono de categoría; engranaje relleno en Ajustes; campo con error vacío y mensaje coherente; hueco avatar‑texto de 12.
- Íconos: set propio de trazos simples por categoría (comida, transporte, vivienda, servicios, salud, entretenimiento, compras, educación, otros) y de ingreso/extra. Son la base del set fijo que pedirá SPEC §3; no se añadió ningún token.
- **Desvío consciente:** las filas de movimiento de las pantallas se componen localmente con los mismos tokens y medidas que `Item de movimiento` (40 + 12 de hueco, 64 de alto). La API de Figma no permite quitar ni sustituir nodos dentro de una instancia, y cada fila necesita su propio ícono/color de categoría; el componente sigue siendo la referencia canónica.
- `P03` muestra 5 movimientos; `P03c` muestra 3 para que el banner de alerta y la lista queden legibles sobre el FAB.
- `P08` entra al formulario desde la acción «Nueva» del encabezado (se evitó duplicar el acceso con otro botón).
- `P09b` incluye el selector Gasto/Ingreso además de nombre, ícono y color, porque la categoría es tipada en SPEC §4 y R2.
- `P04c` coloca «Borrar» en el encabezado en color `gasto`; el diálogo de confirmación es comportamiento, no se dibuja como frame.
- El donut de P06 usa `arcData` nativo sobre elipses; las barras de 6 meses son rectángulos de `ingreso`/`gasto`. Todo con tokens.
- Los montos siempre con formato `S/ 1,234.50` y en céntimos visuales; gasto en `gasto`, ingreso en `ingreso`.
- No se ejecutó `flutter analyze`/`flutter test` porque la tarea no toca código.

**Dudas o problemas pendientes:**
- Ninguna bloqueante. Si se prefiere que las filas de movimiento sean instancias del componente aunque compartan el mismo ícono, o que P03c muestre 5 movimientos con scroll, se ajusta sin cambiar el sistema.

### Reporte – ronda 1

Cambios aplicados:
1. **P05 / P05b**: añadido el filtro «Categoría: Todas ▾» como píldora bajo Todos/Gastos/Ingresos. Reexportados ambos PNG.
2. **P03c**: «Presupuesto total» pasó a `textoPrincipal`; `alerta` queda solo en el relleno. Reexportado.
3. **P03 / P03b / P03c**: retirada la píldora con flecha; el mes queda como texto plano «Noviembre 2025» en `textoSecundario` a la derecha. Reexportados los tres.
4. **P04b**: el ejemplo pasa a `0.999` con el mensaje «Usa como máximo 2 decimales». Reexportado.
5. **P06**: valor central en `cuerpo` y hueco del donut ampliado a `innerRadius 0.68`; ya no toca el anillo. Reexportado.
6. **P01b**: teclado atenuado al 55 % con teclas en `textoSecundario`, puntos vacíos y mensaje «Demasiados intentos. Espera 30 s». Reexportado.

Además, por indicación del usuario: los frames de la página `Pantallas` se reacomodaron en una rejilla 4×6 con 400×900 de paso, sin superposiciones (P01/P03 y P01b/P03b ya no comparten posición).

Archivos reexportados: `P01b.png`, `P03.png`, `P03b.png`, `P03c.png`, `P04b.png`, `P05.png`, `P05b.png`, `P06.png`.

### Reporte – ronda 2

- Estado actualizado a `LISTA_PARA_AUDITORIA` (queda corregido el descuido de protocolo de la entrega anterior).
- **P06**: los puntos de la leyenda se recrearon rellenos —los nodos anteriores se rasterizaban como anillos pese a tener relleno sólido—, incluidos los de «Ingresos / Gastos». Reexportado `P06.png`. En código (tarea 015) irán rellenos, igual que ahora.
- Corregida una cifra del reporte: los PNG se exportan a **360×800 px**; la entrega anterior decía 720×1600 por error.
- No se modificó ningún otro frame ni PNG.

---

## Auditoría
*(La escribe Claude Code.)*

**Ronda 1 — 2026-11-12 — CAMBIOS_SOLICITADOS**

Verificado:
- Están los 21 PNG (P01–P10 + los 11 estados) y `componentes.png` reexportado. Solo cambiaron `docs/diseno/` y esta tarea.
- Las 5 correcciones de 001 están aplicadas en `componentes.png`: banner y porcentajes en `textoPrincipal`, avatar con ícono, engranaje, campo con error vacío y coherente, hueco de 12.
- La navegación inferior aparece en P03, P05, P06 y P10 con la pestaña activa marcada. Los montos usan `gasto` / `ingreso` (4.75:1 y 4.72:1 sobre `fondo`).
- Se acepta el desvío de las filas de movimiento compuestas con los mismos tokens (limitación de la API de Figma). También se aceptan Borrar en el encabezado de P04c, el tipo en P09b y «Nueva» en el encabezado de P08.

Cambios obligatorios (solo hay que reexportar los PNG afectados):
1. **P05 / P05b — falta el filtro por categoría** (SPEC P05: «filtros por tipo y categoría»). Añadir un control para elegir categoría (por ejemplo, un chip «Categoría ▾» después de Todos/Gastos/Ingresos) y mostrarlo en los dos frames.
2. **P03c — «Presupuesto total» está en `alerta` como texto.** Esto incumple la corrección 1 (3.99:1 sobre `fondo`). La etiqueta va en `textoPrincipal`, igual que en P07; `alerta` solo en el relleno de la barra.
3. **P03 / P03b / P03c — Inicio no tiene selector de mes.** SPEC P03 dice «balance del mes actual», y la píldora «Noviembre 2025 >» sugiere navegar entre meses, que es una función que no existe en Inicio. Quitarla o dejar el mes como texto sin flecha.
4. **P04b — el ejemplo de error es incorrecto.** `0.99` es un monto válido según R1, pero se muestra como error. Usar un valor que sí incumpla la regla (`0.999`, o el campo vacío con «Ingresa un monto»).
5. **P06 — el monto central del donut se sale del hueco** y se superpone al anillo. Reducir el texto (por ejemplo, `subtitulo`) o agrandar el hueco para que `S/ 1,765.50` quepa dentro con margen.
6. **P01b — durante la espera de 30 s el teclado se ve activo.** R6 bloquea la entrada: mostrar el teclado deshabilitado (estilo deshabilitado de 001), los puntos vacíos y la cuenta atrás en el mensaje (por ejemplo, «Demasiados intentos. Espera 30 s»).

Observaciones no bloqueantes (no hace falta tocarlas en esta tarea):
- En P04 y P04c todos los puntos de los chips son del mismo color; en P04b, cada uno tiene el color de su categoría, que es lo correcto. Si se reexporta P04, unificar.
- Fechas de ejemplo: la cabecera dice «Noviembre 2025» y P08b dice «1 nov 2025». Da igual, pero conviene usar un año coherente en todos los frames.
- P05b ofrece «Registrar el primero» con el texto «cambia los filtros»: está bien, pero el botón puede omitirse cuando hay filtros activos.
- El selector de íconos de P09b muestra 8. El set fijo final (que cubra las 12 categorías por defecto, incluidas Otros y las de ingreso) se define en la tarea 006.

**Ronda 2 — 2026-11-12 — APROBADA**

Verificado en los 8 PNG reexportados:
1. P05 / P05b: está el filtro «Categoría: Todas» bajo los filtros por tipo. ✔
2. P03c: «Presupuesto total» va en `textoPrincipal` y `alerta` solo en la barra y el acento. ✔
3. P03 / P03b / P03c: el mes es texto plano, sin flecha ni píldora. ✔
4. P04b: `0.999` con «Usa como máximo 2 decimales», coherente con R1. ✔
5. P06: el monto central cabe en el hueco del donut sin tocar el anillo. ✔
6. P01b: el teclado está deshabilitado, los puntos vacíos y el mensaje es «Demasiados intentos. Espera 30 s». ✔

Notas menores (no requieren otra ronda):
- La cabecera de esta tarea seguía en `CAMBIOS_SOLICITADOS` al entregar la ronda 1. Al reentregar hay que cambiarla a `LISTA_PARA_AUDITORIA` (protocolo).
- En P06 los puntos de la leyenda pasaron a ser anillos huecos; en código (tarea 015) se usan puntos rellenos con el color de la categoría.
- Siguen vigentes las observaciones no bloqueantes de la ronda 1 (color de los puntos de los chips en P04/P04c, año de ejemplo, set de íconos de P09b → 006).

**Ronda 3 — 2026-11-12 — APROBADA**

Revisión de los retoques enviados después de la ronda 2:
- `P06.png` reexportado a 360×800: todos los puntos de la leyenda están rellenos, también los de «Ingresos / Gastos». Ningún otro elemento del frame cambió. ✔
- Las medidas del reporte ya están corregidas a 360×800 px, que es lo que mide de verdad (lo comprobé con PIL). ✔
- `git diff` muestra que solo cambiaron `P06.png`, esta tarea y `.commandcode/taste/taste.md`, que es un archivo interno de Command Code. ✔
- Esta vez el estado se entregó en `LISTA_PARA_AUDITORIA`, como pide el protocolo. ✔
