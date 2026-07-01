# La Casa de Mandi — Proyecto Semestral

Plataforma web para pasteleria La Casa de Mandi. Proyecto semestral de Programacion 2.

## Stack tecnologico

| Capa          | Tecnologia                           |
|---------------|--------------------------------------|
| Frontend      | HTML5, CSS3, JSP                     |
| Backend       | Java Servlets (Jakarta EE / Tomcat 9+) |
| Base de datos | MySQL (XAMPP)                        |
| IDE           | Eclipse IDE                          |

## Estructura del proyecto

```
LacasadeMandi/
├── database/
│   ├── schema.sql          -- Esquema completo de 10 tablas en MySQL
│   ├── seed.sql            -- Datos de prueba (catalogo real + clientes + pedidos)
│   └── admin.sql           -- Cuenta de administrador
├── docs/
│   └── contexto-proyecto-lacasademandi.md  -- Vision general, requisitos y tareas
├── src/main/
│   ├── java/
│   │   ├── controlador/    -- Servlets (Login, Registro, Pedido, Perfil, Logout)
│   │   ├── modelo/           -- Clases Java (beans): Cliente, Producto, Pedido, ...
│   │   ├── dao/            -- Clases DAO para acceso a base de datos
│   │   └── util/           -- Utilidades (Conexion.java)
│   └── webapp/
│       ├── index.jsp                    -- Pagina de inicio
│       ├── login.jsp                    -- Login dual (correo o WhatsApp) con BCrypt
│       ├── css/
│       │   ├── estilos.css              -- Estilos base del sitio (terracota #a23c3e)
│       │   └── admin.css                -- Estilos del panel de administracion
│       ├── img/                         -- Fotos del equipo y productos
│       ├── jsp/layouts/
│       │   ├── header.jsp               -- Header reutilizable con navegacion
│       │   └── footer.jsp               -- Footer reutilizable
│       ├── jsp/publico/
│       │   ├── catalogo.jsp             -- Catalogo con tabs Dulces/Postres (dinamico)
│       │   ├── detalle-producto.jsp     -- Detalle de un producto
│       │   ├── contacto.jsp             -- Formulario de contacto
│       │   ├── nosotros.jsp             -- PagTruncada en la pagina Sobre Nosotros
│       │   └── registro.jsp             -- Registro de nuevos clientes
│       ├── jsp/cliente/
│       │   ├── mis-pedidos.jsp          -- Lista de pedidos del cliente
│       │   ├── nuevo-pedido.jsp         -- Formulario de nuevo pedido
│       │   ├── detalle-pedido.jsp       -- Detalle de un pedido especifico
│       │   └── mi-perfil.jsp            -- Editar datos personales
│       └── jsp/admin/
│           ├── dashboard.jsp            -- Panel de control del admin
│           ├── pedidos.jsp              -- Gestion de pedidos con filtros
│           └── productos.jsp            -- Gestion de productos
└── README.md
```

## Requisitos para ejecutar

- Eclipse IDE con Tomcat 9+ configurado
- XAMPP con MySQL activo
- Java 21
- MySQL Connector (`mysql-connector-j-9.x.jar`) en `WEB-INF/lib/` o referenciado en `.classpath`

## Configurar la base de datos

1. Abrir phpMyAdmin: `http://localhost/phpmyadmin`
2. Importar en orden:
   - `database/schema.sql`
   - `database/seed.sql`
   - `database/admin.sql`

## Cuentas de prueba

| Tipo    | Correo                    | Contraseña  |
|---------|---------------------------|-------------|
| Admin   | mandi.admin@gmail.com     | MandiWorld  |
| Cliente | ana.perez@gmail.com       | cliente123  |

## Estado actual del proyecto

### Implementado

- **Arquitectura MVC completa** con Servlets, DAOs y Beans
- **Login dual** (correo o WhatsApp) con BCrypt
- **Registro de clientes**
- **Catalogo de productos** conectado a la base de datos
- **Detalle de producto** dinamico
- **Creacion de pedidos** por parte del cliente
- **Listado de pedidos** del cliente
- **Panel de administracion** con dashboard y gestion de pedidos
- **Proteccion de rutas** por rol (cliente / admin)
- **Gestion de sesiones** con logout

### En desarrollo / pendiente

- Modulo de reportes (RF06)
- Gestion de capacidad de entregas (RF05)
- Modulo de abonos y pagos finales
- Pagina de error 404 personalizada
- Responsive design mejorado en movil

## Flujo del negocio

```
Catalogo (Dulces y Postres) -> Pedido con diseno a medida
      -> Abono verificado por admin -> Produccion
      -> Pago final verificado -> Entrega
```

## Equipo

| Nombre           | Cedula     | Rama Git                  |
|------------------|------------|---------------------------|
| Marian Barba     | 8-1012-213 | feature/admin-panel       |
| Gabriela Fuentes | 8-1042-245 | feature/auth-onboarding   |
| Laura Orellana   | E-8-221893 | feature/catalogo-publico  |
| Evelin Pineda    | 8-1031-1126| feature/pedidos-pagos-cliente|
