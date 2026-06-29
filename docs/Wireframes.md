# Wireframes

**ID:** 20270302
**Fecha:** Martes 16 de julio
**Área:** [[MOC — Proyectos]]
**Tags:** #programacion #pasteleria #wireframes #ui

---

## La Idea

Los wireframes describen la estructura de cada pantalla del sistema adaptada al flujo real: catálogo por categoría → pedido personalizado con lógica de precio según tipo → abono → confirmación del admin → producción → pago final → entrega. El diseño refleja la identidad artesanal de La Casa de Mandi y es completamente responsive.

---

## Por Qué Importa

Los wireframes son el puente entre los requisitos funcionales y el código. Permiten validar el flujo antes de desarrollar y documentar qué muestra cada pantalla, qué campos contiene y qué acciones están disponibles según el estado y el rol del usuario.

---

## Conexiones

- Se relaciona con [[Mapa del Sitio]]
- Se relaciona con [[Requisitos Funcionales]]
- Se relaciona con [[Reglas de Desarrollo]]
- Deriva de [[Proyecto Semestral La Casa de Mandi]]

---

## Fuente

- **Origen:** Diseño propio — proyecto semestral Programación 2
- **Autor:** 
- **Fecha de la fuente:** 

---

## Notas Adicionales

> **IMPORTANTE:** NO copiar diseños externos ni plantillas descargadas. Mantener identidad visual de La Casa de Mandi: paleta propia, estilo artesanal/cálido, navegación sencilla y adaptada a móvil.

---

## Zona Pública

### Página Inicio
- Header: Logo + Menú (Inicio, Catálogo, Sobre Nosotros, Contacto, Login)
- Banner principal con imagen y frase del negocio
- Sección de productos destacados (tarjetas: imagen, nombre, precio base desde...)
- Llamada a la acción: botón "Ver catálogo"
- Footer: WhatsApp de contacto, redes sociales

### Catálogo
- Tabs o secciones: **Dulces** | **Postres**
- Tarjetas de producto: imagen, nombre, descripción breve, precio base desde...
- Botón "Ver detalles" en cada tarjeta

### Detalle del Producto
- Imagen grande del producto
- Nombre y descripción
- Selector de variante: tamaño (dropdown)
- Precio base de la variante seleccionada (se actualiza al cambiar selección)
- Nota visual para dulces: "El precio final será confirmado por el administrador según tu diseño"
- Botón "Hacer pedido" → redirige a Login si no hay sesión activa
- Solo se muestran variantes con `disponible = true`; si todas las variantes de un producto están inactivas, el producto no aparece en el catálogo

---

## Zona Cliente

### Login
- Título: "Iniciar sesión"
- Campo: Correo electrónico o número de WhatsApp
- Campo: Contraseña
- Botón "Iniciar sesión"
- Enlace "¿No tienes cuenta? Regístrate"
- Enlace "Olvidé mi contraseña"
- El sistema detecta el rol y redirige: cliente → Panel Cliente / admin → Panel Admin

### Registro (solo clientes)
- Campo: Nombre completo
- Campo: Teléfono
- Campo: Número de WhatsApp
- Campo: Correo electrónico
- Campo: Contraseña
- Campo: Confirmar contraseña
- Botón "Registrarse"
- Validación: correo y WhatsApp deben ser únicos en el sistema

---

### Formulario de Nuevo Pedido *(requiere login de cliente)*
- Producto y variante pre-cargados si viene del catálogo (editable)
- Selector de variante: tamaño (Solo para dulces)
- Campo: cantidad
- **Para postres:** precio subtotal calculado automáticamente en tiempo real (cantidad × precio_base)
- **Para dulces:** se muestra el precio base referencial con nota "El precio será ajustado por el administrador"
- Campo: descripción del diseño personalizado (textarea — obligatorio para dulces)
- Campo: fecha de entrega (datepicker)
  - Fechas con cupo lleno aparecen deshabilitadas
  - El cliente no ve el conteo, solo disponible/no disponible
- Resumen del pedido antes de confirmar
- Botón "Enviar pedido"

---

### Panel del Cliente — Mis Pedidos
- Lista de pedidos:
  - Número de pedido, fecha, producto(s), estado con badge de color, precio total
  - Badge de color por estado:
    - Pendiente = gris
    - Aceptado = azul
    - En producción = naranja
    - Listo = verde claro
    - Entregado = verde oscuro
    - Rechazado = rojo
    - Cancelado = rojo claro
- Botón "Ver detalle" por pedido

### Detalle del Pedido — Vista Cliente
- Datos del pedido: producto(s), variante(s), cantidad, descripción del diseño, fecha de entrega
- Precio total (con indicador si está pendiente de confirmación en dulces)
- Estado actual con badge + línea de tiempo de estados
- Sección Pagos:
  - Abono: estado (pendiente / registrado / confirmado), monto, método, referencia
  - Pago Final: estado (pendiente / registrado / confirmado), monto, método, referencia
- Acciones visibles según estado:
  - Estado = Pendiente → botón "Cancelar pedido"
  - Estado = Aceptado + sin abono registrado → botón "Registrar abono"
  - Estado = Listo + sin pago final registrado → botón "Registrar pago final"

### Formulario de Abono
- Monto del abono
- Porcentaje que representa del total (calculado automáticamente o editable (minimo 50%))
- Fecha en que se realizó el pago
- Método de pago: selector **Yappy** / **Efectivo** / **Transferencia bancaria**
- Campo referencia (etiqueta dinámica según método):
  - Yappy → "Número de confirmación Yappy"
  - Tarjeta → "Últimos 4 dígitos de la tarjeta"
  - Transferencia → "Número de transferencia bancaria"
- Nota informativa: "El admin verificará tu pago antes de iniciar la producción"
- Botón "Confirmar abono"

### Formulario de Pago Final
- Monto del pago final
- Fecha en que se realizó el pago
- Método de pago: selector **Yappy** / **Tarjeta** / **Transferencia bancaria**
- Campo referencia (misma lógica dinámica que el abono)
- Nota informativa: "El admin verificará tu pago para marcar el pedido como entregado"
- Botón "Confirmar pago final"

---

## Zona Administración

### Dashboard Admin
- Cards con contadores por estado (Pendientes, En producción, Listos, etc.)
- Alerta destacada: pedidos con abono o pago final pendiente de confirmar
- Lista de pedidos recientes con estado
- Resumen de ingresos del mes (suma de pagos finales confirmados)

### Lista de Pedidos Admin
- Tabla con: N° pedido, cliente, fecha pedido, fecha entrega, estado (badge), precio total, acción
- Filtro por estado
- Botón "Ver detalle" por fila

### Detalle del Pedido — Vista Admin
- Datos completos del pedido y del cliente (nombre, teléfono, WhatsApp)
- Variantes pedidas con cantidad y precio unitario
  - **Para dulces:** campo editable de precio por variante (disponible solo si estado = Pendiente)
- Precio total (calculado o ajustado)
- Descripción del diseño
- Fecha de entrega
- Selector de estado + botón "Actualizar estado" (manual en todos los pasos excepto Entregado)
- Sección Abono:
  - Si registrado: monto, método, referencia, fecha → botón "Confirmar abono recibido"
  - Si confirmado: muestra fecha de confirmación
- Sección Pago Final:
  - Si registrado: monto, método, referencia, fecha → botón "Confirmar pago final recibido"
  - Si confirmado: muestra fecha de confirmación → estado cambia a Entregado automáticamente

### Gestión de Productos Admin
- Tabla: imagen, nombre, categoría, N° variantes activas, estado (activo/inactivo)
- Botón "Nuevo producto"
- Botón "Editar" y "Desactivar" por fila — desactivar oculta el producto completo del catálogo (por temporada o falta de disponibilidad)
- Vista de variantes por producto: tamaño, precio base, activo/inactivo
  - Botón "Agregar variante"
  - Botón "Editar" y "Desactivar" por variante — desactivar oculta solo esa presentación específica, sin afectar las demás del mismo producto
  - Toggle rápido de disponibilidad directamente en la tabla, sin entrar a editar

### Gestión de Capacidad de Entregas Admin
- Vista de calendario mensual
- Cada día muestra: N° pedidos confirmados / límite (Ej: "3 / 5")
- Días llenos marcados visualmente
- Campo para cambiar el límite diario global (default 5)

### Gestión de Clientes Admin
- Tabla: nombre, correo, WhatsApp, fecha registro, N° pedidos
- Botón "Ver historial" por cliente
- Vista de historial: lista de pedidos del cliente con estado y montos

### Reportes Admin
- Pedidos por estado (gráfico de barras o tabla)
- Ingresos por período (rango de fechas seleccionable)
- Variantes más solicitadas (ranking)

---

*← [[­HOME]] | [[MOC — Proyectos]]*
