# Requisitos Funcionales

**ID:** 20270305
**Fecha:** Martes 16 de julio
**Área:** [[MOC — Proyectos]]
**Tags:** #programacion #pasteleria #requisitos

---

## La Idea

El sistema cubre siete módulos funcionales: autenticación con login por correo o WhatsApp, catálogo de dos categorías (dulces y postres) con variantes de tamaño y control de disponibilidad por temporada, pedidos personalizados con dos lógicas de precio (automática para postres, ajustable por el admin para dulces), pagos fraccionados con confirmación manual del admin, panel de administración para gestionar el ciclo completo, control de capacidad de entregas (límite 5 por día), y reportes de actividad.

---

## Por Qué Importa

Definir los requisitos funcionales antes de codificar evita retrabajos y garantiza que el sistema cubra las necesidades reales del negocio. Cada RF mapea directamente a pantallas del mapa del sitio y entidades del modelo de datos.

---

## Conexiones

- Se relaciona con [[Mapa del Sitio]]
- Se relaciona con [[Modelo de Datos]]
- Se relaciona con [[Wireframes]]
- Apoya la idea de [[Vision del Proyecto]]
- Deriva de [[Proyecto Semestral La Casa de Mandi]]

---

## Fuente

- **Origen:** Análisis de requerimientos del proyecto semestral
- **Autor:** 
- **Fecha de la fuente:** 

---

## Notas Adicionales

### RF01 — Autenticación y Usuarios

**Clientes:**
- Registro con: nombre, teléfono, WhatsApp, correo y contraseña
- Login con **correo** o **número de WhatsApp** + contraseña
- Recuperación de contraseña (por correo)
- Ver y editar perfil (nombre, teléfono, WhatsApp)
- Cancelar un pedido propio solo si está en estado **Pendiente**

**Administrador:**
- Login con correo y contraseña
- Acceso exclusivo al panel de administración
- No tiene registro público; el admin existe por configuración inicial del sistema

---

### RF02 — Catálogo de Productos

- El catálogo tiene exactamente **dos categorías fijas**: Dulces y Postres
- Ver productos por categoría
- Ver detalle de cada producto: nombre, descripción, imagen, variantes disponibles (tamaño + precio base)
- Los productos **no manejan stock**; son producción bajo pedido
- Un producto puede tener múltiples variantes de tamaño, cada una con su propio precio
- Solo se muestran productos y variantes marcados como disponibles; un producto o tamaño fuera de temporada no aparece en el catálogo ni puede pedirse, pero no se elimina del sistema

---

### RF03 — Pedidos

**Creación del pedido (cliente):**
- Seleccionar uno o más productos del catálogo con su variante específica (tamaño)
- Especificar cantidad por variante
- Agregar descripción del diseño personalizado (texto libre)
- Seleccionar fecha de entrega de entre las fechas disponibles
  - El sistema bloquea automáticamente fechas con 5 pedidos confirmados o más
  - El cliente solo ve "disponible" o "no disponible", sin ver los números
- El pedido se registra en estado **Pendiente**

**Seguimiento (cliente):**
- Consultar historial de pedidos propios
- Ver estado actual de cada pedido con indicador visual por color
- Cancelar pedido si está en estado **Pendiente**

**Lógica de precio según categoría:**
- **Postres:** precio calculado automáticamente = suma de (cantidad × precio_base de cada variante). No requiere intervención del admin.
- **Dulces (tortas/pasteles):** el precio base es referencial. El admin puede ajustar el precio por variante al revisar el pedido, según las personalizaciones solicitadas. El precio queda confirmado cuando el admin acepta el pedido.

---

### RF04 — Pagos (en dos partes)

**Abono (cliente registra, admin confirma):**
- El cliente registra el abono una vez que el pedido está en estado **Aceptado**
- Campos: monto, porcentaje del total, fecha de pago, método de pago, referencia
- Métodos disponibles: **Yappy**, **Tarjeta**, **Transferencia bancaria**
- Referencia según método:
  - Yappy → número de confirmación
  - Tarjeta → últimos 4 dígitos
  - Transferencia → número de transferencia
- El pedido **no cambia de estado automáticamente** al registrar el abono
- El admin verifica el pago y lo marca como confirmado → el sistema cambia el estado a **En producción**

**Pago Final (cliente registra, admin confirma):**
- El cliente registra el pago final cuando el pedido está en estado **Listo**
- Mismos campos y métodos que el abono
- El admin verifica y lo marca como confirmado → el sistema cambia automáticamente el estado a **Entregado**

---

### RF05 — Panel de Administración

**Gestión de Pedidos:**
- Ver todos los pedidos con filtro por estado
- Ver detalle completo: cliente, variantes pedidas, diseño, fecha entrega, precio total
- Cambiar estado del pedido (manual en todos los casos excepto Entregado):
  - Pendiente → Aceptado (y fijar precio en pedidos de dulces si aplica)
  - Pendiente → Rechazado
  - Aceptado → (esperar abono del cliente)
  - Confirmar abono → sistema pasa a En producción
  - En producción → Listo
  - Listo → (esperar pago final del cliente)
  - Confirmar pago final → sistema pasa a Entregado

**Gestión de Productos:**
- CRUD completo de productos (nombre, descripción, categoría, imagen)
- CRUD de variantes por producto (tamaño, precio base)
- Activar / desactivar productos completos (oculta todas sus variantes del catálogo)
- Activar / desactivar variantes individuales (oculta solo esa presentación, sin afectar el resto del producto) — útil cuando un tamaño no está disponible por temporada

**Gestión de Clientes:**
- Ver listado de clientes registrados
- Ver historial de pedidos por cliente

**Gestión de Capacidad:**
- Ver ocupación de fechas de entrega
- Configurar el límite diario (por defecto: 5)

---

### RF06 — Reportes

- Pedidos por estado (cuántos en cada etapa actualmente)
- Historial de pedidos por rango de fechas o por cliente
- Ingresos totales (suma de pagos finales confirmados en un período)
- Productos y variantes más solicitados

---

### RF07 — Validaciones del sistema

- No permitir seleccionar fecha de entrega bloqueada (≥ 5 pedidos confirmados)
- No permitir registrar abono si el pedido no está en estado Aceptado
- No permitir registrar pago final si el pedido no está en estado Listo
- No permitir al cliente cancelar si el pedido ya fue Aceptado o superior
- El campo `whatsapp` debe ser único entre todos los clientes registrados
- El campo `correo` debe ser único entre todos los clientes registrados

---

### RF08 — Página de Inicio (pública)

- Header con navegación: Inicio, Catálogo, Sobre Nosotros, Contacto, botón "Acceder"
- Sin icono de carrito (el sistema no maneja carrito de compras)
- Hero principal con frase del negocio y dos botones: "Ordenar Ahora" (redirige a Catálogo o Login) y "Ver Catálogo"
- Sección "Dulces y Postres Destacados": 3 productos reales del catálogo (no placeholders), tomados de la tabla `Producto`/`Producto_Variante`
- Sección "Noticias y Novedades": bloque de contenido editorial con 3 artículos/historias del negocio (requisito solicitado por el profesor) — contenido estático, no requiere tabla en base de datos por ahora
- Sección "¿Cómo hacer tu pedido?": proceso visual de 4 pasos — Elige → Confirma → Abona → Disfruta (requisito solicitado por el profesor), refleja de forma simplificada el flujo real de estados del pedido
- Footer con datos de contacto, redes sociales y enlaces legales

---

*← [[­HOME]] | [[MOC — Proyectos]]*
