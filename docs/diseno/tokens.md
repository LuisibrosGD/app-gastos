# App Gastos — Tokens de diseño

> Exportado desde el archivo de Figma **App Gastos**, página `Sistema de diseño`.
> Fuente de verdad visual: [Figma](https://www.figma.com/design/jqNwN5MXEEiVNXAA0JQ0fg/app-gasto).
> Estos valores son los que la tarea 004 traslada a `lib/core/theme`.
> Lienzo de referencia: Android **360 × 800 dp**. Fuente: **Roboto**. Tema claro.

Los colores existen dos veces en Figma, con los mismos valores: como **estilos de pintura** (`Color/<token>`) y como **variables** de la colección `Color`. Radios y espaciados son **variables FLOAT** de la colección `Dimensión`.

## 1. Colores

| Token | Hex | Uso previsto |
|---|---|---|
| `primario` | `#4054B2` | Acción principal, pestaña activa, foco |
| `primarioSuave` | `#E8EBFA` | Fondos de chip y de pista de progreso |
| `fondo` | `#F7F8FA` | Fondo de pantalla |
| `superficie` | `#FFFFFF` | Tarjetas, campos y barras |
| `borde` | `#E3E6EB` | Bordes y divisores |
| `textoPrincipal` | `#1C2430` | Texto principal |
| `textoSecundario` | `#5A6577` | Texto de apoyo |
| `ingreso` | `#2E7D57` | Montos de ingreso |
| `gasto` | `#C2414F` | Montos de gasto y estado «excedido» |
| `alerta` | `#B26A00` | Umbral del 80 % |
| `error` | `#B3261E` | Errores de validación |

### Colores de categoría

| Token | Hex | Contraste sobre `superficie` |
|---|---|---|
| `categoria01` | `#C2410C` | 5.18:1 |
| `categoria02` | `#B45309` | 5.02:1 |
| `categoria03` | `#4D7C0F` | 4.99:1 |
| `categoria04` | `#15803D` | 5.02:1 |
| `categoria05` | `#0F766E` | 5.47:1 |
| `categoria06` | `#0E7490` | 5.36:1 |
| `categoria07` | `#1D4ED8` | 6.70:1 |
| `categoria08` | `#4338CA` | 7.90:1 |
| `categoria09` | `#7E22CE` | 6.98:1 |
| `categoria10` | `#A21CAF` | 6.32:1 |
| `categoria11` | `#BE185D` | 6.04:1 |
| `categoria12` | `#B91C1C` | 6.47:1 |

Los 12 colores superan el mínimo de 3:1 exigido. No están asignados a categorías concretas: la asignación por defecto se decide al crear las categorías (tarea 006).

### Contrastes de texto

| Combinación | Ratio medido | Mínimo |
|---|---|---|
| `textoPrincipal` sobre `fondo` | 14.70:1 | 4.5:1 |
| `textoSecundario` sobre `fondo` | 5.55:1 | 4.5:1 |
| `textoPrincipal` sobre `superficie` | 15.62:1 | 4.5:1 |
| `textoSecundario` sobre `superficie` | 5.89:1 | 4.5:1 |

## 2. Tipografía

Familia única: **Roboto**. Tamaños e interlineados en dp.

| Token | Peso | Tamaño | Interlineado | Uso |
|---|---|---|---|---|
| `titulo` | SemiBold (600) | 22 | 28 | Título de pantalla y valores de campo |
| `subtitulo` | Medium (500) | 18 | 24 | Título de sección |
| `cuerpo` | Regular (400) | 16 | 24 | Texto y etiquetas de acción |
| `etiqueta` | Medium (500) | 14 | 20 | Etiquetas y metadatos |
| `pequeno` | Regular (400) | 12 | 16 | Texto de apoyo |
| `montoGrande` | Bold (700) | 32 | 40 | Balance principal |

Estilos de texto en Figma: `Texto/titulo`, `Texto/subtitulo`, `Texto/cuerpo`, `Texto/etiqueta`, `Texto/pequeno`, `Texto/montoGrande`.

## 3. Radios

| Token | Valor | Uso |
|---|---|---|
| `radioS` | 8 dp | Barras, indicadores |
| `radioM` | 12 dp | Botones y campos |
| `radioL` | 20 dp | Tarjetas, chips y FAB |

## 4. Espaciados

Escala de 4. En Figma son variables FLOAT de la colección `Dimensión`.

| Token | Valor |
|---|---|
| `espacio4` | 4 dp |
| `espacio8` | 8 dp |
| `espacio12` | 12 dp |
| `espacio16` | 16 dp |
| `espacio24` | 24 dp |
| `espacio32` | 32 dp |

Margen lateral de pantalla: `espacio16` (360 − 2 × 16 = **328 dp** de contenido).

## 5. Componentes

Todos viven en la página `Componentes` del archivo de Figma y usan los estilos y variables anteriores. La captura completa es [componentes.png](componentes.png).

| Componente | Variantes / estados | Medidas y tokens principales |
|---|---|---|
| Botón primario | Normal, Presionado, Deshabilitado | 328 × 52 · `radioM` · `primario` · texto `cuerpo` blanco |
| Botón secundario | Normal, Deshabilitado | 328 × 52 · `radioM` · `superficie` + `borde` · texto `primario` |
| Campo de texto | Normal, Foco, Error | 328 × 56 · `radioM` · borde `borde` / `primario` / `error` (2 dp en foco y error) |
| Campo de monto | Normal, Foco | 328 × 64 · prefijo `S/` en `subtitulo` + valor en `titulo` |
| Item de movimiento | Gasto, Ingreso | 328 × 64 · ícono 40 (color de categoría) · nota `pequeno` · monto en `gasto` / `ingreso` |
| Chip de categoría | Normal, Seleccionado | alto 36 · `radioL` · `primarioSuave` / `primario` |
| Tarjeta de balance | — | 328 · `radioL` · `superficie` + `borde` · saldo en `montoGrande` |
| Barra de presupuesto | Normal, Alerta (≥ 80 %), Excedido (≥ 100 %) | pista 8 dp `radioS` · relleno `primario` / `alerta` / `gasto` |
| Banner de alerta | — | 328 · `radioM` · acento de 4 dp en `alerta` |
| Barra de navegación inferior | Pestaña activa / inactiva | 360 × 80 · 4 pestañas · activa `primario`, inactiva `textoSecundario` |
| Botón flotante + | — | 56 × 56 · `radioL` · `primario` |
| Teclado PIN | — | 328 · teclas 101 × 64 · `radioM` · tecla `superficie` + `borde` |

### Derivaciones de estado

- Botón primario **Presionado**: `primario` con opacidad de nodo 85 %.
- Botón deshabilitado: fondo `superficie` + `borde`, texto `textoSecundario` y opacidad 55 % en el secundario.
- Barra de presupuesto: `primario` por debajo del 80 %, `alerta` desde el 80 %, `gasto` desde el 100 %.

## 6. Nombres en Figma

- Estilos de pintura: `Color/<token>`.
- Estilos de texto: `Texto/<token>`.
- Variables: colección `Color` (`<token>`) y colección `Dimensión` (`radioS`, `radioM`, `radioL`, `espacio4` … `espacio32`).
- Componentes: `Botón primario`, `Botón secundario`, `Campo de texto`, `Campo de monto`, `Item de movimiento`, `Chip de categoría`, `Tarjeta de balance`, `Barra de presupuesto`, `Banner de alerta`, `Barra de navegación`, `Botón flotante`, `Teclado PIN`.
