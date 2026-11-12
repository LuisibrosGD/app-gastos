# App Gastos — Especificación de producto (v1)

> **Qué** hace la app. El **cómo** técnico está en [ARQUITECTURA.md](ARQUITECTURA.md).
> Fuente de verdad del producto: si una tarea contradice este documento, manda este documento.

**Última actualización:** 2026-11-11

## 1. Propósito

App móvil de uso **personal** para controlar gastos e ingresos propios.

**Criterio de éxito de la v1:** la app está instalada en el teléfono Android del usuario y la usa a diario para registrar sus movimientos reales.

## 2. Decisiones de producto

| Tema | Decisión |
|---|---|
| Plataforma | Solo Android |
| Datos | 100 % locales en el teléfono. Sin cuentas, sin internet |
| Moneda | Una sola: Soles (PEN), formato `S/ 1,234.50` |
| Idiomas | Español (por defecto) e inglés |
| Seguridad | Bloqueo opcional con PIN o huella |
| Estilo visual | Minimalista, tema claro. Diseño hecho en Figma |

## 3. Alcance

**Incluido en la v1:**
1. Registrar, editar y borrar movimientos (gasto o ingreso).
2. Categorías personalizables (crear, editar, archivar) con nombre, ícono y color.
3. Balance mensual (ingresos − gastos).
4. Resumen con gráfico circular de gastos por categoría y barras de ingresos vs. gastos de los últimos 6 meses.
5. Presupuesto mensual total y, opcionalmente, por categoría, con alertas al 80 % y al 100 %.
6. Movimientos recurrentes con frecuencia mensual o semanal.
7. Bloqueo con PIN y/o huella.
8. Interfaz en español e inglés.

**Fuera de alcance (v2 o posterior):** varias monedas, nube o login, exportar a Excel/CSV, copia de seguridad, foto de recibos, varias cuentas o métodos de pago, iOS, modo oscuro.

## 4. Pantallas

Navegación inferior con 4 pestañas: **Inicio · Movimientos · Resumen · Ajustes**.

| ID | Pantalla | Contenido y comportamiento |
|---|---|---|
| P01 | Bloqueo | Se muestra al abrir la app y al volver tras más de 60 s en segundo plano, solo si el bloqueo está activo. Intenta primero con huella si está disponible; el PIN es el respaldo. |
| P02 | Primera vez | Elegir idioma → crear las categorías por defecto → ofrecer configurar el PIN (se puede omitir). Solo en el primer arranque. |
| P03 | Inicio | Balance del mes actual, barra de progreso del presupuesto total (si existe), aviso de alerta activa, últimos 5 movimientos y botón flotante **+**. |
| P04 | Nuevo / Editar movimiento | Selector gasto/ingreso, monto, categoría (filtrada por tipo), fecha (por defecto hoy), nota opcional. En edición, botón **Borrar** con confirmación. |
| P05 | Movimientos | Lista agrupada por día del mes seleccionado, con selector de mes y filtros por tipo y categoría. Tocar un movimiento abre P04. |
| P06 | Resumen | Selector de mes, gráfico circular de gastos por categoría (leyenda y %), barras de ingresos vs. gastos de los últimos 6 meses. |
| P07 | Presupuesto | Monto total mensual y límites opcionales por categoría de gasto, con el progreso del mes actual. |
| P08 | Recurrentes | Lista de reglas (activas/inactivas) y formulario: tipo, monto, categoría, nota, frecuencia (mensual con día 1–31 o semanal con día de la semana), fecha de inicio, activo. |
| P09 | Categorías | Lista por tipo y formulario: nombre, ícono (set fijo), color (paleta fija). Si tiene movimientos, se archiva en lugar de borrarse. |
| P10 | Ajustes | Idioma, activar/desactivar bloqueo, cambiar PIN, usar huella; accesos a P07, P08 y P09. |

**Categorías por defecto:**
- Gasto: Comida, Transporte, Vivienda, Servicios, Salud, Entretenimiento, Compras, Educación, Otros.
- Ingreso: Sueldo, Extra, Otros.

## 5. Reglas de negocio

### R1. Movimientos
- Monto obligatorio, > 0, con 2 decimales como máximo.
- La categoría es obligatoria y su tipo debe coincidir con el del movimiento.
- Nota opcional, de 200 caracteres como máximo.
- La fecha no tiene hora.

### R2. Categorías
- Nombre obligatorio, de 30 caracteres como máximo.
- No se borra una categoría que tenga movimientos o reglas recurrentes: se archiva.
- Las categorías archivadas no aparecen en los selectores, pero sí en el historial y en el resumen.

### R3. Presupuesto
- Es un límite **mensual fijo** que se aplica igual todos los meses.
- Puede haber como máximo un presupuesto total y uno por cada categoría de gasto.
- Solo cuentan los **gastos** del mes calendario.

### R4. Alertas de presupuesto
- Después de crear, editar o generar un gasto, se revisa el presupuesto total y el de su categoría para el mes de ese gasto.
- Al cruzar el **80 %** o el **100 %** se envía una notificación local, **una sola vez** por presupuesto, mes y umbral.
- En Inicio se muestra un aviso mientras el gasto del mes actual sea ≥ 80 % de algún presupuesto.
- Si el usuario rechaza el permiso de notificaciones, solo se muestra el aviso en la app.

### R5. Recurrentes
- Se generan al abrir la app y al volver a primer plano.
- Se crean todas las ocurrencias pendientes hasta hoy. Si la app estuvo 3 meses sin abrirse, se crean los 3 movimientos.
- Nunca se duplican: ejecutar la generación dos veces seguidas no crea nada nuevo.
- Si el día mensual no existe en ese mes (por ejemplo, el 31 en febrero), se usa el último día del mes.
- Borrar una regla no borra los movimientos que ya generó.

### R6. Bloqueo
- El PIN tiene de 4 a 6 dígitos y nunca se guarda en texto plano.
- La huella solo se ofrece si el teléfono la soporta y tiene alguna registrada.
- Tras 5 PIN incorrectos seguidos, la entrada se bloquea durante 30 s.
- Desactivar el bloqueo o cambiar el PIN exige introducir antes el PIN actual.

### R7. Errores
- Los errores de validación se muestran junto a cada campo.
- Si falla el guardado, se avisa con un mensaje y el formulario conserva lo escrito.

## 6. Riesgos aceptados

- Los datos solo existen en el teléfono: si se pierde o se formatea, se pierden. La copia de seguridad queda para la v2.

## 7. Criterios de aceptación de la v1

- [ ] Todas las pantallas P01–P10 funcionan en el teléfono del usuario.
- [ ] Las reglas R1–R7 están cubiertas por tests o verificadas en el checklist manual.
- [ ] La app funciona sin conexión a internet.
- [ ] Los dos idiomas están completos, sin textos sin traducir.
- [ ] `flutter analyze` sin advertencias y `flutter test` en verde.
