# Contexto del Proyecto — La Casa de Mandi

> **Ruta del proyecto:** `/home/marian01/eclipse-workspace/LacasadeMandi/`
> **Fecha de ultima actualizacion:** 30 de junio de 2026
> **Tecnologia:** Java (JSP + Servlets) + MySQL + CSS propio (Tomcat 9, javax.servlet)

---

## 1. Resumen del Proyecto

**La Casa de Mandi** es una plataforma web para una pasteleria artesanal panamena que digitaliza el ciclo completo del pedido personalizado:

**Flujo:** Catalogo (Dulces y Postres) -> Pedido con diseno a medida -> Abono verificado por admin -> Produccion -> Pago final verificado -> Entrega

**Problema actual del negocio:**
- Pedidos via WhatsApp (se pierden)
- Tracking en Excel (no es compartido ni trazable)
- Cobros por Yappy (sin vinculacion al pedido)
- Sin control de capacidad de produccion diaria

**Objetivo:** Reemplazar el flujo manual con un sistema donde el cliente hace y rastrea su pedido en linea, y el admin gestiona todo desde un panel con control real de lo que puede producir (limite 5 pedidos/dia).

---

## 2. Estructura del Proyecto

```
LacasadeMandi/
├── build/                              -- Clases compiladas (.class)
├── database/
│   ├── schema.sql                      -- Esquema completo de 10 tablas en MySQL
│   ├── seed.sql                        -- Datos de prueba (catalogo real + 8 pedidos)
│   └── admin.sql                       -- Cuenta de administrador
├── docs/                               -- Documentacion del proyecto
│   ├── Proyecto Semestral La Casa de Mandi.md
│   ├── Requisitos Funcionales.md
│   ├── Vision del Proyecto.md
│   ├── Mapa del Sitio.md
│   ├── Modelo de Datos.md
│   ├── Wireframes.md
│   ├── Reglas de Desarrollo.md
│   ├── Script Base de Datos.md
│   └── contexto-proyecto-lacasademandi.md
├── src/main/java/
│   ├── controlador/
│   │   ├── LoginServlet.java           ✅ FUNCIONAL (valida correo/WhatsApp, rol auto)
│   │   ├── RegistroServlet.java        ✅ Funcional (GET=form, POST=registra+login)
│   │   ├── PedidoServlet.java          ✅ Funcional (crear/estado/precio/cancelar)
│   │   ├── PerfilServlet.java          ✅ Funcional (actualizar datos de cliente)
│   │   └── LogoutServlet.java          ✅ Funcional (invalida sesion y redirige)
│   ├── modelo/                         -- Beans (entidades Java)
│   │   ├── Cliente.java                ✅ Bean completo (6 campos)
│   │   ├── Pedido.java                 ✅ Bean completo (10 campos)
│   │   ├── Producto.java               ✅ Bean completo (8 campos + lista variantes)
│   │   ├── Variante.java               ✅ Bean completo (5 campos)
│   │   ├── Administrador.java          ✅ Bean completo (4 campos)
│   │   ├── Abono.java                  ❌ FALTANTE
│   │   ├── PagoFinal.java              ❌ FALTANTE
│   │   ├── CapacidadEntrega.java       ❌ FALTANTE
│   │   ├── Categoria.java              ❌ FALTANTE
│   │   └── PedidoVariante.java         ❌ FALTANTE
│   ├── dao/                            -- Data Access Objects
│   │   ├── ClienteDAO.java             ✅ Completo (CRUD + busqueda correo/WhatsApp)
│   │   ├── ProductoDAO.java            ✅ Completo (listar por categoria, por ID, variantes)
│   │   ├── PedidoDAO.java              ✅ Completo (crear con transaccion, listar, estados, contadores)
│   │   ├── AdministradorDAO.java       ✅ Completo (buscar por correo)
│   │   ├── AbonoDAO.java               ❌ FALTANTE
│   │   ├── PagoFinalDAO.java           ❌ FALTANTE
│   │   ├── CapacidadEntregaDAO.java    ❌ FALTANTE
│   │   ├── CategoriaDAO.java           ❌ FALTANTE
│   │   └── PedidoVarianteDAO.java      ❌ FALTANTE
│   └── util/
│       └── Conexion.java               ✅ Conexion centralizada a MySQL (root/password vacia)
├── src/main/webapp/
│   ├── index.jsp                       -- Pagina de inicio
│   ├── login.jsp                       ✅ Login dual FUNCIONAL (correo o WhatsApp, con BCrypt)
│   ├── WEB-INF/
│   │   ├── web.xml                     ✅ 5 Servlets mapeados
│   │   └── lib/
│   │       ├── mysql-connector-j-9.x.jar
│   │       └── jbcrypt-0.4.jar
│   ├── css/
│   │   ├── estilos.css                 -- Estilos base (terracota #a23c3e)
│   │   ├── login.css                   -- Estilos del login
│   │   └── admin.css                   ✅ NUEVO: estilos del panel admin
│   ├── img/                            -- Imagenes del proyecto (Logo, Hero, Iconos, Equipo)
│   │   ├── Logo.png
│   │   ├── HeroIndex.png               ✅ Optimizado (de 676KB a 260KB)
│   │   ├── EvelinPineda.jpeg
│   │   ├── LauraOrellana.jpeg
│   │   ├── MarianBarba.jpeg
│   │   └── Icon/                       -- Iconos del dashboard admin
│   ├── jsp/layouts/
│   │   ├── header.jsp                  ✅ Dinamico (rol + nombre + boton salir)
│   │   └── footer.jsp                  ✅ Reutilizable
│   ├── jsp/publico/
│   │   ├── catalogo.jsp                ✅ CONECTADO A BD (ProductoDAO, tabs Dulces/Postres)
│   │   ├── detalle-producto.jsp        ✅ NUEVO: detalle completo con producto desde BD
│   │   ├── detalle-dulce.jsp           ✅ Cambio de url a detalle-producto.jsp
│   │   ├── detalle-postre.jsp          ✅ Cambio de url a detalle-producto.jsp
│   │   ├── nosotros.jsp                ✅ Sobre Nosotros (equipo real con fotos)
│   │   └── registro.jsp                ✅ Formulario de creacion de cuenta (dual columnas, validaciones)
│   ├── jsp/cliente/
│   │   ├── mis-pedidos.jsp             ✅ Lista dinamica desde BD (PedidoDAO)
│   │   ├── nuevo-pedido.jsp            ✅ Productos de BD, calculo de total en vivo
│   │   ├── detalle-pedido.jsp          ✅ Datos reales del pedido, timeline de estados
│   │   └── mi-perfil.jsp               ✅ Lee y guarda en BD, valida correo unico
│   └── jsp/admin/
│       ├── dashboard.jsp               ✅ Contadores reales + ultimos 10 pedidos + sidebar
│       ├── pedidos.jsp                 ✅ Tabla con datos reales, filtros por estado
│       ├── productos.jsp               ✅ Productos dinamicos
│       ├── sidebar.jsp                 ✅ NUEVO: sidebar reutilizable del admin
│       └── footer-admin.jsp            ✅ NUEVO: footer compacto del admin
```

---

## 3. Lo que FUNCIONA (implementado y verificado)

### Backend (MVC completo)
- **Modelo (beans):** `Cliente`, `Pedido`, `Producto`, `Variante`, `Administrador`
- **DAO:** `ClienteDAO`, `PedidoDAO`, `ProductoDAO`, `AdministradorDAO` -- todos usan `util.Conexion`
- **Servlets:**
  - `LoginServlet` -- valida correo/WhatsApp, auto-asigna rol (admin/cliente)
  - `RegistroServlet` -- registro con validacion, hash BCrypt, sesion automatica
  - `PedidoServlet` -- crear, cambiar estado, confirmar precio, cancelar pedido
  - `PerfilServlet` -- actualizar datos del cliente con validacion de correo unico
  - `LogoutServlet` -- invalida sesion y redirige al login

### Base de Datos
- Todas las paginas JSP de cliente y admin leen de la BD en tiempo real
- `Conexion.java` centraliza conexion a `la_casa_de_mandi` (utf8mb4, timezone Panama)

### Frontend Cliente (conectado a BD)
- **mis-pedidos.jsp** -- Lista de pedidos reales del cliente logueado, con boton cancelar (solo Pendiente)
- **nuevo-pedido.jsp** -- Productos cargados dinamicamente desde BD, variantes con precios, calculo de total en vivo, preseleccion desde catalogo
- **detalle-pedido.jsp** -- Muestra datos reales del pedido, timeline de estados, feedback de exito al crear, validacion de propiedad del pedido
- **mi-perfil.jsp** -- Lee y guarda en BD, valida correo unico, muestra mensaje de exito
- **detalle-producto.jsp** -- Detalle completo del producto con variantes, desde BD, con boton "Pedir ahora"

### Frontend Admin (conectado a BD)
- **dashboard.jsp** -- Cards con contadores reales (Pendiente/En produccion/Listo/Entregado), tabla ultimos 5 pedidos, sidebar navegacion, saludo dinamico segun hora
- **pedidos.jsp** -- Tabla con datos reales, filtros por estado, layout con sidebar
- **productos.jsp** -- Productos dinamicos

### Frontend Publico
- **registro.jsp** -- Formulario de creacion de cuenta con diseno dual columnas, validaciones HTML5
- **login.jsp** -- Login dual con redireccion segun rol, validaciones server-side
- **nosotros.jsp** -- Pagina "Sobre Nosotros" con equipo real (Marian Barba, Laura Orellana, Evelin Pineda) y fotos
- **catalogo.jsp** -- Catalogo de productos con tabs Dulces/Postres, conectado a BD
- **header.jsp** -- Dinamico: muestra nombre del usuario, boton de salir, oculta/muestra enlaces segun rol

### Autenticacion y seguridad
- Registro con BCrypt (`jbcrypt-0.4.jar`)
- Sesiones con atributos: `rol`, `id_cliente`, `nombre`
- Proteccion por rol en todas las paginas (cliente/admin)
- Validacion de propiedad de pedido (cliente solo ve sus pedidos)
- Redireccion a login si no hay sesion activa

---

## 4. Cambios Recientes (sin commit aun)

### Core / Back-end
| # | Archivo | Cambio |
|---|---------|--------|
| 1 | `LoginServlet.java` | ✅ NUEVO: Servlet completo de login, valida admin primero (correo), luego cliente (correo o WhatsApp), redirige segun rol |
| 2 | `Administrador.java` | ✅ NUEVO: Bean completo (4 campos: idAdmin, nombre, correo, password) |
| 3 | `AdministradorDAO.java` | ✅ NUEVO: buscarPorCorreo() para autenticacion de administradores |
| 4 | `LogoutServlet.java` | Import cambiado de `jakarta.servlet` a `javax.servlet` (Tomcat 9 compatibilidad) |
| 5 | `Conexion.java` | URL cambiada de `localhost` a `127.0.0.1` para mayor compatibilidad |

### Base de Datos
| # | Archivo | Cambio |
|---|---------|--------|
| 6 | `admin.sql` | Hash de admin actualizado a formato jBCrypt (`$2a$...`) para compatibilidad con jBCrypt-0.4 |
| 7 | `seed.sql` | Hashes de clientes de prueba actualizados a formato jBCrypt (`$2a$...`), todos con password 'password123' |

### Front-end / JSP
| # | Archivo | Cambio |
|---|---------|--------|
| 8 | `login.jsp` | LIMPIADO: logica de autenticacion extraida a LoginServlet, ahora es solo el formulario |
| 9 | `detalle-producto.jsp` | ✅ NUEVO: pagina unificada de detalle de producto (dulces/postres), lee de BD con variantes y precios, boton "Pedir ahora" para clientes |
| 10 | `detalle-dulce.jsp` | ✅ NUEVO: redirect a detalle-producto.jsp |
| 11 | `detalle-postre.jsp` | ✅ NUEVO: redirect a detalle-producto.jsp |
| 12 | `sidebar.jsp` | ✅ NUEVO: sidebar reutilizable del admin (dashboard, pedidos, inventario, clientes, configuracion) |
| 13 | `footer-admin.jsp` | ✅ NUEVO: footer compacto del panel admin con marca y enlaces |
| 14 | `index.jsp` | Ajustes de redireccion y links |

### Estilos / CSS
| # | Archivo | Cambio |
|---|---------|--------|
| 15 | `admin.css` | ✅ NUEVO: 297 lineas de CSS dedicado al panel admin (sidebar, tablas, filtros, stat cards, paginacion, detalle de pedido, footer admin, responsive) |

### Limpieza
| # | Archivo | Cambio |
|---|---------|--------|
| 16 | `conexion.jsp` | ❌ ELIMINADO: redundante, ya se usa util/Conexion.java |
| 17 | `login_servlet.jsp` | ❌ ELIMINADO: redundante, login.jsp ahora maneja solo formulario |
| 18 | `panel_admin.jsp` | ❌ ELIMINADO: redundante, redirige a dashboard |
| 19 | `wireframes/` | ❌ ELIMINADO: contenido no nesesario |

### Configuracion
| # | Archivo | Cambio |
|---|---------|--------|
| 20 | `web.xml` | Agregado mapeo de LoginServlet, total de 5 servlets |

---

## 5. Problemas RESUELTOS en esta actualizacion

| # | Problema anterior | Solucion |
|---|-------------------|----------|
| 1 | No existia LoginServlet (login.jsp tenia logica embebida) | Creado LoginServlet, login.jsp ahora es solo vista |
| 2 | No habia modelo/DAO para Administrador | Creados Administrador.java y AdministradorDAO.java |
| 3 | No se podian crear paginas de detalle de producto | Creado detalle-producto.jsp conectado a BD |
| 4 | Admin no tenia estilos propios ni sidebar reutilizable | Creados admin.css, sidebar.jsp y footer-admin.jsp |
| 5 | login_servlet.jsp era duplicado de index.jsp | LIMPIADO: ahora solo redirige a login.jsp |
| 6 | conexion.jsp estaba deprecated | ELIMINADO: ahora todos usan util/Conexion.java |
| 7 | panel_admin.jsp era redundante | ELIMINADO: se usa dashboard.jsp directamente |
| 8 | wireframes ocupaban espacio innecesario | ELIMPIADO |

---

## 6. Lo que FALTA (por implementar)

### Modulos criticos faltantes
1. **Modulo de abonos y pagos finales** (AbonoServlet / PagoFinalServlet)
2. **Gestion de capacidad de entregas** (max 5/dia)
3. **Modulo de reportes** (RF06)
4. **Paginas faltantes:**
   - `clientes.jsp`, `capacidad.jsp`, `reportes.jsp` (Admin)

### Funcionalidades RF pendientes

| RF | Modulo | Estado |
|----|--------|--------|
| RF01 | Autenticacion | ✅ Completo (login, registro, logout, sesiones con rol)
| RF02 | Catalogo de productos | Conectado a BD (ProductoDAO) |
| RF03 | Pedidos | Crear, listar, cancelar FUNCIONAL; falta flujo completo de estados |
| RF04 | Pagos | No iniciado (abonos/pagos finales) |
| RF05 | Panel de administracion | Dashboard con datos reales, pedidos, productos |
| RF06 | Reportes | No iniciado |
| RF07 | Validaciones del sistema | Medio (backend valida, pero falta mas validacion servidor) |
| RF08 | Pagina de inicio publica | Visualmente implementada, sin conectar a BD |

### Funcionalidades de negocio pendientes
- [ ] Modulo de abonos y pagos finales
- [ ] Precio automatico confirmado por admin
- [ ] Control de capacidad de entregas (max 5/dia)
- [ ] Bloqueo de fechas sin disponibilidad en datepicker
- [ ] Cancelacion de pedido desde admin
- [ ] Reportes de ingresos y productos mas solicitados
- [ ] Pagina de error 404 personalizada
- [ ] Responsive design mejorado en movil

---

## 7. Tareas por Prioridad

### Urgente (bloquea funcionalidad basica)
1. ~~Crear `LoginServlet` y mapear en web.xml~~ ✅ HECHO

### Alta (funcionalidad esencial)
2. Modulo de abonos y pagos finales
3. Control de capacidad de entregas (limite 5/dia)
4. Gestion de clientes (vista admin)
5. ~~Paginas detalle-producto.jsp~~ ✅ HECHO

### Media (funcionalidad completa)
6. Flujo completo de cambio de estados del pedido (Aceptado -> En produccion -> Listo -> Entregado)
7. Modulo de reportes
8. Paginas de admin faltantes (clientes, capacidad, reportes)

### Baja (pulido)
9. Imagenes reales de productos
10. Pagina de error 404
11. Responsive design en movil

---

## 8. Notas de Desarrollo

- `Conexion.java` usa `root` con password vacia -- **CAMBIAR EN PRODUCCION**
- El proyecto usa `javax.servlet` (Tomcat 9). Para usar Tomcat 10+, revertir imports a `jakarta.servlet`.
- Todos los DAO usan try-with-resources (no hay memory leak)
- Los Servlets usan `req.setCharacterEncoding("UTF-8")` para evitar problemas de acentos
- `login.jsp` ahora solo es vista, la logica de autenticacion esta en `LoginServlet`
- `PedidoServlet` maneja 4 acciones via parametro `accion`: crear, estado, precio, cancelar
- `RegistroServlet` valida: campos obligatorios, correo valido, password >= 6 caracteres, password coinciden, correo y WhatsApp unicos
- Dashboard admin muestra links a: pedidos.jsp, productos.jsp, clientes.jsp (no existe aun), capacidad.jsp (no existe aun)
- La pagina `nosotros.jsp` muestra las 3 integrantes del equipo con IDs reales
- `detalle-producto.jsp` unifica las vistas anteriores de `detalle-dulce.jsp` y `detalle-postre.jsp`
- El CSS de admin (`admin.css`) usa las mismas variables de color que `estilos.css` para consistencia visual

---

*Documento generado automaticamente a partir del analisis del codigo fuente del proyecto.*
