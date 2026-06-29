# Script Base de Datos (MySQL)

**ID:** 20270306
**Fecha:** Martes 16 de julio
**Área:** [[MOC — Proyectos]]
**Tags:** #programacion #pasteleria #basededatos #mysql #seed

---

## La Idea

Script SQL completo y ejecutable en MySQL/phpMyAdmin que crea las 10 tablas del modelo de datos, carga el catálogo real de "La Casa de Mandi" (7 dulces con 3 tamaños cada uno, 3 postres con porción única) y agrega 8 pedidos de ejemplo que cubren los 7 estados posibles del flujo, junto con sus pagos. Pensado para no requerir actualización posterior — el catálogo y los seeds reflejan los productos y precios reales del negocio.

---

## Por Qué Importa

Sin datos de prueba realistas es imposible verificar que el dashboard admin, el login con redirección por rol, y el flujo de estados funcionen correctamente antes de conectar el sistema con clientes reales. Este script permite levantar la base de datos completa de un solo `SOURCE` y empezar a probar la aplicación PHP de inmediato.

---

## Conexiones

- Se relaciona con [[Modelo de Datos]]
- Se relaciona con [[Requisitos Funcionales]]
- Deriva de [[Proyecto Semestral La Casa de Mandi]]

---

## Fuente

- **Origen:** Catálogo real proporcionado por la Product Owner del negocio
- **Autor:** 
- **Fecha de la fuente:** Martes 16 de julio

---

## Notas Adicionales

### Cómo ejecutar el script

```bash
mysql -u root -p < la_casa_de_mandi.sql
```

O desde phpMyAdmin: pestaña **Importar** → seleccionar el archivo → Continuar. El script crea la base de datos `la_casa_de_mandi` si no existe, así que se puede correr directamente sin pasos previos.

---

### Catálogo cargado (datos reales del negocio)

**Categoría Dulces** — 7 productos, cada uno con 3 variantes de tamaño (6", 8", 10"):

| Producto | 6" | 8" | 10" |
|---|---|---|---|
| Delicia Tres Leches Frutal | B/. 35.00 | B/. 45.00 | B/. 55.00 |
| Cheesecake Tropical de Maracuyá | B/. 18.00 | B/. 25.00 | B/. 35.00 |
| Fresas & Crema | B/. 15.00 | B/. 25.00 | B/. 40.00 |
| Chocoflan de Fresas | B/. 15.00 | B/. 28.00 | B/. 40.00 |
| Melocotón & Crema | B/. 15.00 | B/. 25.00 | B/. 40.00 |
| Cheesecake Frutos del Bosque | B/. 18.00 | B/. 25.00 | B/. 35.00 |
| Dulce Tentación de Leche | B/. 25.00 | B/. 35.00 | B/. 45.00 |

**Categoría Postres** — 3 productos, cada uno con una sola variante ("Porción individual") a B/. 3.00:
- Cheesecake Tropical de Maracuyá (porción)
- Cheesecake Caramelo de Maracuyá
- Cheesecake Frutos del Bosque (porción)

> Nota de implementación: los postres se modelan con una fila en `Producto_Variante` igual que los dulces, para mantener una sola estructura de tablas en todo el sistema. La diferencia es que en la interfaz no se muestra el dropdown de tamaño para esta categoría — el front simplemente no renderiza ese selector si el producto pertenece a la categoría Postres.

---

### Pedidos de ejemplo (seed) y qué prueban

| # | Cliente | Categoría | Estado | Qué valida |
|---|---|---|---|---|
| 1 | Ana Pérez | Dulce | Pendiente | Pedido recién creado, sin precio confirmado por el admin |
| 2 | Carlos Gómez | Dulce | Aceptado | Admin ya ajustó el precio (de $25 a $30), esperando abono del cliente |
| 3 | María Rodríguez | Dulce | En producción | Abono registrado y confirmado por el admin (Yappy) |
| 4 | Luis Fernández | Dulce | Listo | Producto terminado, abono pagado por transferencia, esperando pago final |
| 5 | Daniela Castillo | Postre | Entregado | Ciclo completo: abono en efectivo + pago final por Yappy, ambos confirmados |
| 6 | Ana Pérez | Postre | Pendiente | Pedido simple sin descripción de diseño (opcional en postres) |
| 7 | Carlos Gómez | Dulce | Rechazado | Admin no pudo atender el pedido |
| 8 | María Rodríguez | Dulce | Cancelado | Cliente canceló antes de que el admin lo aceptara |

Estos 8 pedidos permiten probar visualmente en el dashboard admin los badges de cada estado, el flujo de confirmación de pagos, y la diferencia de comportamiento entre Dulces y Postres sin necesidad de crear pedidos manualmente durante el desarrollo.

---

### Cuentas de prueba incluidas en el seed

**Clientes** (todos con password real `cliente123`):
- ana.perez@gmail.com / WhatsApp 6000-0001
- carlos.gomez@gmail.com / WhatsApp 6000-0002
- maria.rodriguez@gmail.com / WhatsApp 6000-0003
- luis.fernandez@gmail.com / WhatsApp 6000-0004
- daniela.castillo@gmail.com / WhatsApp 6000-0005

> Estos sí son hashes bcrypt **reales**, generados con `password_hash('cliente123', PASSWORD_BCRYPT)` en PHP y verificados con `password_verify()` antes de incluirlos. Puedes iniciar sesión con cualquiera de estos correos (o el WhatsApp correspondiente) y la contraseña `cliente123` apenas conectes el login al login real.

**Administrador:** no se siembra ninguna cuenta de admin en este script. La tabla `Administrador` existe en la estructura, pero se deja vacía a propósito — la cuenta de administración se crea por fuera del seed, directamente cuando se monte el ambiente real (o con un script aparte si se necesita una para pruebas locales).

**Registro de nuevos clientes:** cuando alguien complete el formulario de registro desde el sitio público, el backend debe correr `password_hash($password_ingresada, PASSWORD_BCRYPT)` y guardar ese resultado en la columna `password` de `Cliente` — igual que se hizo aquí para los clientes de prueba. Así cualquier cuenta nueva, creada desde el login real, queda guardada de la misma forma que las del seed.

---

### Decisiones tomadas en el script

- Se usó `ENUM` para `estado` y `metodo_pago` en lugar de tablas de referencia separadas, porque ambos son catálogos cerrados y pequeños que no van a crecer — mantiene el script simple para las 2 semanas de desarrollo.
- Los postres llevan el sufijo "(porción)" en el nombre cuando coincide con un sabor que ya existe en Dulces (ej: "Cheesecake Tropical de Maracuyá"), para que no se confundan visualmente en reportes o listados del admin.
- `Capacidad_Entrega` se sembró con 6 días a partir de la fecha actual y se actualizó manualmente según los pedidos en estado ≥ Aceptado, para reflejar cómo se vería la tabla en uso real.
- No se generó un volumen masivo de pedidos (cientos) porque el propósito del seed es probar el flujo completo y cada estado visualmente, no medir rendimiento — eso no aplica para un negocio de este tamaño.

---

*← [[­HOME]] | [[MOC — Proyectos]]*
