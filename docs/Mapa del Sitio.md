# Mapa del Sitio

**ID:** 20261602
**Fecha:** Martes 16 de julio
**Área:** [[MOC — Proyectos]]
**Tags:** #programacion #pasteleria #arquitectura #mapadelsitio

---

## La Idea

El sitio se organiza en tres zonas: pública (sin login), zona de cliente (login por correo o WhatsApp), y zona de administración (login por correo). No existe carrito; el flujo va directo de catálogo a formulario de pedido personalizado. El sistema valida capacidad de entrega internamente antes de permitir seleccionar una fecha.

---

## Por Qué Importa

El mapa del sitio define la arquitectura de navegación antes de diseñar cualquier pantalla. Permite verificar que cada requisito funcional tenga su pantalla correspondiente y que las rutas protegidas estén bien separadas de las públicas.

---

## Conexiones

- Se relaciona con [[Wireframes]]
- Se relaciona con [[Requisitos Funcionales]]
- Apoya la idea de [[Vision del Proyecto]]
- Deriva de [[Proyecto Semestral La Casa de Mandi]]

---

## Fuente

- **Origen:** Diseño propio — proyecto semestral Programación 2
- **Autor:** 
- **Fecha de la fuente:** 

---

## Notas Adicionales

### Zona Pública *(sin login)*

```
Inicio
│
├── Catálogo
│   ├── Dulces
│   │   └── Detalle del Producto
│   │       └── → "Hacer pedido" (redirige a Login si no hay sesión)
│   └── Postres
│       └── Detalle del Producto
│           └── → "Hacer pedido" (redirige a Login si no hay sesión)
│
├── Sobre Nosotros
│
│
├── Login (correo o WhatsApp)
│   └── → redirige según rol: cliente o admin
│
└── Registro (solo clientes)
```

---

### Zona Cliente *(requiere login de cliente)*

```
Panel del Cliente
│
├── Nuevo Pedido
│   └── Formulario de pedido
│       ├── Selección de variante (tamaño)
│       ├── Cantidad
│       ├── Descripción del diseño
│       ├── Fecha de entrega (datepicker con fechas disponibles)
│       └── Resumen y precio (automático para postres / referencial para dulces)
│
├── Mis Pedidos
│   ├── Lista de pedidos con estado y badge de color
│   └── Detalle del Pedido
│       ├── Información completa del pedido
│       ├── Estado actual + historial de cambios
│       ├── Sección de pagos
│       │   ├── Registrar Abono (visible si estado = Aceptado y sin abono)
│       │   │   └── Formulario de abono (monto, método, referencia)
│       │   └── Registrar Pago Final (visible si estado = Listo y sin pago final)
│       │       └── Formulario de pago final (monto, método, referencia)
│       └── Cancelar Pedido (visible solo si estado = Pendiente)
│
├─ Mi Perfil
│   └── Editar datos (nombre, teléfono, WhatsApp)
│   
└─ Sobre Nosotros    
```

---

### Zona Administración *(requiere login de admin)*

```
Panel Administrador
│
├── Dashboard
│   ├── Contadores de pedidos por estado
│   ├── Pedidos pendientes de acción (abonos o pagos sin confirmar)
│   └── Resumen de ingresos del mes
│
├── Pedidos
│   ├── Lista de todos los pedidos (filtrable por estado)
│   └── Detalle del Pedido
│       ├── Información completa + datos del cliente
│       ├── Ajuste de precio por variante (solo dulces, antes de aceptar)
│       ├── Cambio de estado (manual)
│       └── Confirmar abono / Confirmar pago final
│
├── Productos
│   ├── Lista de productos (con categoría y estado activo/inactivo)
│   ├── Crear producto
│   ├── Editar producto
│   └── Gestión de variantes del producto
│       ├── Agregar variante (tamaño + precio base)
│       └── Editar / desactivar variante (oculta solo esa presentación por temporada)
│
├── Clientes
│   ├── Lista de clientes registrados
│   └── Perfil del cliente con historial de pedidos
│
├── Capacidad de Entregas
│   ├── Vista de calendario con ocupación por fecha
│   └── Configurar límite diario (default: 5)
│
├── Reportes
│   ├── Pedidos por estado
│   ├── Ingresos por período
│   └── Variantes más solicitadas
│
└─ Sobre Nosotros
```

---

*← [[­HOME]] | [[MOC — Proyectos]]*
