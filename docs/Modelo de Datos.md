# Modelo de Datos

**ID:** 20261704
**Fecha:** Martes 16 de julio
**Área:** [[MOC — Proyectos]]
**Tags:** #programacion #pasteleria #basededatos #modelodatos

---

## La Idea

El sistema se compone de entidades que reflejan la operación real del negocio: clientes y administradores con login, un catálogo de dos categorías (dulces y postres) con variantes de tamaño y precio propio, pedidos personalizados donde el precio se calcula según la variante elegida (automático para postres, ajustable por el admin para tortas/pasteles), pagos fraccionados con confirmación del admin, control de disponibilidad por producto y por variante, y un límite de 5 entregas por día gestionado internamente.

---

## Por Qué Importa

Un modelo bien normalizado evita redundancia y facilita el mantenimiento. Este modelo separa correctamente el producto base de sus variantes, maneja dos lógicas de precio distintas, y protege el flujo de producción exigiendo que el admin confirme cada pago antes de cambiar el estado del pedido.

---

## Conexiones

- Se relaciona con [[Requisitos Funcionales]]
- Se relaciona con [[Reglas de Desarrollo]]
- Se relaciona con [[Script Base de Datos]]
- Apoya la idea de [[Vision del Proyecto]]
- Deriva de [[Proyecto Semestral La Casa de Mandi]]

---

## Fuente

- **Origen:** Diagrama ER — proyecto semestral Programación 2
- **Autor:** 
- **Fecha de la fuente:** 

---

## Notas Adicionales

### Entidades y atributos

#### Categoria
| Campo | Tipo | Nota |
|-------|------|------|
| id_categoria | PK | |
| nombre | VARCHAR | Solo dos valores: "Dulces" / "Postres" |

> Las categorías son fijas. "Dulces" agrupa productos personalizados como tortas y pasteles (precio ajustable). "Postres" agrupa productos estándar cuyo precio se calcula automáticamente por cantidad.

---

#### Producto
| Campo | Tipo | Nota |
|-------|------|------|
| id_producto | PK | |
| id_categoria | FK → Categoria | |
| nombre | VARCHAR | Ej: Torta, Cupcake, Cheesecake |
| descripcion | TEXT | Descripción general del producto |
| imagen | VARCHAR | URL/ruta de la imagen |
| disponible | BOOLEAN | Default TRUE — el admin lo desactiva cuando el producto completo no se ofrece por temporada |

> `disponible` a nivel de Producto oculta el producto entero del catálogo. `disponible` a nivel de Producto_Variante permite ocultar solo una presentación específica (ej: el tamaño grande) sin afectar el resto.

---

#### Producto_Variante
| Campo | Tipo | Nota |
|-------|------|------|
| id_variante | PK | |
| id_producto | FK → Producto | |
| tamaño | VARCHAR | Ej: '6"', '8"', '10"' para dulces. Para postres: valor fijo "Porción individual" |
| precio_base | DECIMAL(10,2) | Precio de esta variante específica |
| disponible | BOOLEAN | Default TRUE — el admin la desactiva cuando no puede ofrecerla por temporada o producto |

> Cada tamaño tiene su propio precio base. Así "Tres Leches 6\"" y "Tres Leches 8\"" son variantes distintas con precios distintos. **Los postres (rebanadas individuales) tienen una sola variante por producto**, sin selector de tamaño visible en el catálogo — se modela igual por consistencia de base de datos, pero la interfaz no muestra el dropdown de tamaño para esta categoría. Cuando una variante no está disponible, el admin la desactiva y deja de poder seleccionarse — no se elimina, solo se oculta.

---

#### Cliente
| Campo | Tipo | Nota |
|-------|------|------|
| id_cliente | INT PK AUTO_INCREMENT | |
| nombre | VARCHAR(100) | |
| telefono | VARCHAR(20) | |
| whatsapp | VARCHAR(20) | UNIQUE — puede diferir del teléfono principal |
| correo | VARCHAR(150) | UNIQUE — usado para login por correo |
| password | VARCHAR(255) | Hash bcrypt |
| fecha_registro | DATETIME | Default CURRENT_TIMESTAMP |

> El login acepta correo **o** número de WhatsApp como identificador. Ambos tienen restricción UNIQUE en la base de datos.

---

#### Administrador
| Campo | Tipo | Nota |
|-------|------|------|
| id_admin | INT PK AUTO_INCREMENT | |
| nombre | VARCHAR(100) | |
| correo | VARCHAR(150) | UNIQUE — para login |
| password | VARCHAR(255) | Hash bcrypt |

---

#### Pedido
| Campo | Tipo | Nota |
|-------|------|------|
| id_pedido | INT PK AUTO_INCREMENT | |
| id_cliente | INT FK → Cliente | |
| fecha_pedido | DATETIME | Default CURRENT_TIMESTAMP |
| fecha_entrega | DATE | Fecha deseada de entrega |
| descripcion_diseno | TEXT | Indicaciones personalizadas — obligatorio en dulces, opcional en postres |
| estado | ENUM('Pendiente','Aceptado','Rechazado','En produccion','Listo','Entregado','Cancelado') | Default 'Pendiente' |
| precio_total | DECIMAL(10,2) | Calculado automáticamente (postres) o ajustado por el admin (dulces) |
| precio_confirmado | BOOLEAN | Default FALSE — pasa a TRUE cuando el admin fija el precio final en dulces |

---

#### Pedido_Variante *(tabla intermedia — reemplaza a Pedido_Producto)*
| Campo | Tipo | Nota |
|-------|------|------|
| id_pedido_variante | INT PK AUTO_INCREMENT | |
| id_pedido | INT FK → Pedido | |
| id_variante | INT FK → Producto_Variante | |
| cantidad | INT | |
| precio_unitario | DECIMAL(10,2) | Copiado del precio_base al crear; el admin puede ajustarlo en dulces |

> Para **postres**: `precio_unitario` se toma directamente del `precio_base` de la variante y el total se calcula automáticamente (cantidad × precio_unitario). Para **dulces**: el admin revisa el pedido y puede ajustar `precio_unitario` antes de aceptarlo, según las personalizaciones solicitadas.

---

#### Abono
| Campo | Tipo | Nota |
|-------|------|------|
| id_abono | INT PK AUTO_INCREMENT | |
| id_pedido | INT FK → Pedido (1:1, UNIQUE) | |
| monto | DECIMAL(10,2) | |
| porcentaje | DECIMAL(5,2) | % del total que representa el abono (mínimo 50%) |
| fecha_pago | DATE | Fecha en que el cliente dice haber pagado |
| metodo_pago | ENUM('Yappy','Efectivo','Transferencia') | |
| referencia | VARCHAR(100) | N° confirmación Yappy o N° transferencia; vacío si es efectivo |
| confirmado | BOOLEAN | Default FALSE — el admin lo cambia a TRUE al verificar |
| fecha_confirmacion | DATE | Cuándo el admin confirmó la recepción del pago |

> El estado del pedido **no cambia automáticamente** al registrar el abono. Cambia a "En producción" solo cuando el admin pone `confirmado = TRUE`.

---

#### Pago_Final
| Campo | Tipo | Nota |
|-------|------|------|
| id_pago_final | INT PK AUTO_INCREMENT | |
| id_pedido | INT FK → Pedido (1:1, UNIQUE) | |
| monto | DECIMAL(10,2) | |
| fecha_pago | DATE | Fecha en que el cliente dice haber pagado |
| metodo_pago | ENUM('Yappy','Efectivo','Transferencia') | |
| referencia | VARCHAR(100) | N° confirmación Yappy o N° transferencia; vacío si es efectivo |
| confirmado | BOOLEAN | Default FALSE — el admin lo cambia a TRUE al verificar |
| fecha_confirmacion | DATE | Cuándo el admin confirmó la recepción del pago |

> Al confirmar el pago final, el sistema cambia automáticamente el estado del pedido a **Entregado**.

---

#### Capacidad_Entrega
| Campo | Tipo | Nota |
|-------|------|------|
| id_capacidad | INT PK AUTO_INCREMENT | |
| fecha | DATE | UNIQUE |
| pedidos_confirmados | INT | Default 0 — contador de pedidos con estado ≥ Aceptado para esa fecha |
| limite_diario | INT | Default 5 — configurable por el admin |

> El sistema valida contra esta tabla antes de permitir que un cliente seleccione una fecha de entrega. Si `pedidos_confirmados >= limite_diario`, esa fecha aparece bloqueada en el datepicker del cliente. El cliente no ve los números, solo ve fechas disponibles o no disponibles.

---

### Relaciones

| Relación | Cardinalidad | Descripción |
|----------|-------------|-------------|
| Categoria → Producto | 1:N | Una categoría tiene muchos productos |
| Producto → Producto_Variante | 1:N | Un producto tiene varias combinaciones de tamaño/sabor |
| Cliente → Pedido | 1:N | Un cliente puede tener muchos pedidos |
| Pedido → Pedido_Variante | 1:N | Un pedido puede incluir varias variantes |
| Producto_Variante → Pedido_Variante | 1:N | Una variante puede estar en muchos pedidos |
| Pedido → Abono | 1:1 | Cada pedido tiene un único abono |
| Pedido → Pago_Final | 1:1 | Cada pedido tiene un único pago final |
| Capacidad_Entrega → (validación) | — | Se consulta al elegir fecha, no es FK directa |

---

### Flujo de estados del Pedido

```
Pendiente → Aceptado → En producción → Listo → Entregado
     ↘           ↘
  Cancelado    Rechazado
```

| Estado | Quién lo activa | Descripción |
|--------|----------------|-------------|
| Pendiente | Sistema (automático) | El cliente envió el pedido; el admin aún no lo revisó |
| Aceptado | Admin (manual) | El admin aprobó el pedido y fijó el precio; el cliente debe abonar |
| Rechazado | Admin (manual) | El admin no puede atender el pedido |
| En producción | Admin (manual, al confirmar abono) | El admin verificó el abono y comienza la producción |
| Listo | Admin (manual) | El producto está terminado; el cliente debe hacer el pago final |
| Entregado | Sistema (automático, al confirmar pago final) | El admin verificó el pago final; ciclo completo |
| Cancelado | Cliente (manual, solo si estado = Pendiente) | El cliente cancela antes de que el admin acepte |

---

*← [[­HOME]] | [[MOC — Proyectos]]*
