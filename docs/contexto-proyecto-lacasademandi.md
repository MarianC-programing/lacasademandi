# Contexto del Proyecto — La Casa de Mandi

> **Ruta del proyecto:** `/home/marian01/eclipse-workspace/LacasadeMandi/`
> **Fecha de actualizacion:** 3 de julio de 2026
> **Tecnologia:** Java (JSP + Servlets) + MySQL + CSS propio (Tomcat 9, javax.servlet)
> **Base de datos:** `la_casa_de_mandi` (utf8mb4)
> **Historial de versiones:** Grupo de 4 aprendizaje (Git)

---

## 1. Resumen del Proyecto

**La Casa de Mandi** es una plataforma web para una pasteleria artesanal panamena que digitaliza el ciclo completo del pedido personalizado:

**Flujo:** Catalogo (Dulces y Postres) → Pedido con diseno a medida → Abono verificado por admin → Produccion → Pago final verificado → Entrega (max 5 pedidos/dia)

**Estado actual: el proyecto esta funcionalmente completo.** Solo falta agregar las imagenes reales de los productos (actualmente el catalogo usa el campo `imagen` de la BD, pero no hay fotos definitivas cargadas) y pulir el responsive design en movil.

---

## 2. Estructura del Proyecto

```
LacasadeMandi/
├── Sistema de versiones
│   ├── .gitignore                    -- Ignora build/, .settings/, .classpath, .project
│   ├── .classpath                    -- Ruta build/classes y librerias (Eclipse)
│   └── .project                      -- Descripcion del proyecto (Eclipse)
├── database/
│   ├── schema.sql                      -- Esquema de 11 tablas en MySQL (incluye Historial_Estado)
│   ├── seed.sql                        -- Datos de prueba (catalogo real + 8 pedidos)
│   └── admin.sql                       -- Cuenta de administrador
├── docs/                               -- Documentacion del proyecto
└── src/main/java/
    ├── modelo/                         -- 7 Beans (entidades Java)
    │   ├── Cliente.java / Pedido.java / Producto.java / Variante.java
    │   └── Administrador.java / Abono.java / PagoFinal.java
    ├── dao/                              -- 6 DAOs (Data Access Objects)
    │   ├── ClienteDAO.java               ✅ CRUD + busqueda correo/WhatsApp + contarPedidos
    │   ├── ProductoDAO.java              ✅ Listar/CRUD + contarDisponibilidad/listarNoDisponibles (resumen inventario)
    │   ├── PedidoDAO.java                ✅ Crear con transaccion, listar, estados + historial de cambios
    │   ├── AdministradorDAO.java         ✅ Buscar por correo
    │   ├── PagoDAO.java                  ✅ CRUD + confirmar/rechazar abonos y pagos finales
    │   └── CapacidadDAO.java             ✅ getCapacidad, actualizarLimite, listarCalendario, fechasBloqueadas
    │   (ReporteDAO fue eliminado: modulo de reportes sin uso, sin enlace en el sidebar)
    ├── controlador/                      -- 8 Servlets
    │   ├── LoginServlet / RegistroServlet / PedidoServlet / PerfilServlet
    │   └── PagoServlet / ProductoServlet / CapacidadServlet / LogoutServlet
    └── util/
        └── Conexion.java                 ✅ Conexion centralizada a MySQL (root/password vacia)
├── src/main/webapp/
│   ├── index.jsp                       -- Pagina principal (redirecciona a catalogo.jsp)
│   ├── login.jsp                       -- Login dual (correo o WhatsApp, con BCrypt) + boton Inicio
│   ├── error/                          -- 404.jsp y 500.jsp, mapeadas en web.xml
│   ├── WEB-INF/
│   │   ├── web.xml                     ✅ 8 Servlets + paginas de error 404/500 mapeadas
│   │   └── lib/ (mysql-connector-j, jbcrypt)
│   ├── css/ (estilos.css, login.css, admin.css)
│   ├── img/                            -- Imagenes del proyecto (Logo, Hero, Iconos, Equipo)
│   │                                      ⚠️ Pendiente: fotos reales de productos
│   ├── jsp/layouts/ (header.jsp, footer.jsp)
│   ├── jsp/publico/
│   │   ├── catalogo.jsp / detalle-producto.jsp / nosotros.jsp / registro.jsp
│   │   └── (contacto.jsp fue eliminado: era solo un stub de redireccion, sin contenido)
│   ├── jsp/cliente/
│   │   ├── mis-pedidos.jsp / nuevo-pedido.jsp / mi-perfil.jsp
│   │   └── detalle-pedido.jsp          ✅ Timeline de estados + pagos (abono/pago final)
│   └── jsp/admin/
│       ├── dashboard.jsp               ✅ Contadores reales, sidebar, saludo, resumen de INVENTARIO real (ya no "Insumos" ficticios ni "Descargar Reporte")
│       ├── pedidos.jsp                 ✅ Tabla con paginacion real (10/pagina), filtros, detalle con Historial de cambios de estado
│       ├── productos.jsp               ✅ CRUD con variantes
│       ├── clientes.jsp                ✅ Listado con busqueda y paginacion real (10/pagina)
│       ├── capacidad.jsp               ✅ Calendario de capacidad conectado a BD (limite 5/dia editable)
│       ├── sidebar.jsp / footer-admin.jsp
│       └── (reportes.jsp fue eliminado: no tenia enlace en el sidebar, era codigo muerto)
```

---

## 3. Cambios realizados en esta sesion (3 de julio de 2026)

1. **Eliminado el modulo de Reportes** (`reportes.jsp` + `ReporteDAO.java`): no tenia enlace de navegacion en `sidebar.jsp`, era codigo muerto sin usar.
2. **Eliminada `contacto.jsp`**: ya era solo un stub que redirigia a `nosotros.jsp`; se limpio tambien la referencia en el comentario de `header.jsp`.
3. **Dashboard**: se quito el boton "Descargar Reporte" (enlace muerto `href="#"`) y la seccion "Insumos" (datos ficticios hardcodeados). Se reemplazo por una seccion **Inventario** real que usa `ProductoDAO.contarDisponibilidad()` y `listarNoDisponibles()` — muestra productos activos, productos sin stock/pausados y variantes pausadas, con enlace real a `productos.jsp`.
4. **Boton de Inicio** agregado en `login.jsp` y `registro.jsp` (esquina superior, vuelve a `index.jsp`).
5. **Historial de cambios de estado**: nueva tabla `Historial_Estado` en `schema.sql`. `PedidoDAO.actualizarEstado()` ahora registra cada transicion (estado anterior → nuevo, con fecha). Se agrego `listarHistorial()` y una tarjeta "Historial de cambios" en la vista de detalle de `pedidos.jsp` (admin).
6. **Paginacion real** en `pedidos.jsp` y `clientes.jsp` (admin): 10 registros por pagina, controles Anterior/Siguiente, conserva filtros de busqueda/estado en la URL.
7. **Paginas de error 404 y 500** creadas (`/error/404.jsp`, `/error/500.jsp`) y mapeadas en `web.xml`.
8. **Bug de codificacion corregido** en `footer.jsp` ("Sí​guenos" → "Síguenos").
9. Se compilo todo el codigo Java (`javac`) y se precompilaron todas las JSP con Jasper (el compilador de Tomcat) — **0 errores**.

⚠️ **Importante:** si ya tienes una base de datos `la_casa_de_mandi` creada, debes ejecutar el bloque nuevo de `Historial_Estado` de `database/schema.sql` manualmente (o recrear la BD desde cero) para que el historial de pedidos funcione.

---

## 4. Base de Datos — 11 Tablas MySQL

| # | Tabla | Descripcion |
|---|-------|-------------|
| 1 | `Categoria` | Categorias de productos (id, nombre) |
| 2 | `Cliente` | Usuarios registrados |
| 3 | `Administrador` | Cuentas de admin |
| 4 | `Capacidad_Entrega` | Control diario (limite_diario=5) |
| 5 | `Producto` | Catalogo (incluye campo `imagen`, `disponible`) |
| 6 | `Producto_Variante` | Variantes de cada producto |
| 7 | `Pedido` | Pedidos del sistema |
| 8 | `Pedido_Variante` | Junction table |
| 9 | `Abono` | Abonos registrados |
| 10 | `Pago_Final` | Pagos finales |
| 11 | `Historial_Estado` | **Nueva:** auditoria de cambios de estado de cada pedido |

---

## 5. Lo que FALTA (por implementar)

### Unico pendiente real
- [ ] **Imagenes reales de productos** — cargar fotos definitivas en `img/` y en el campo `Producto.imagen` (via `seed.sql` o desde `productos.jsp`)

### Pulido opcional (no bloqueante)
- [ ] Responsive design mejorado en movil (ya existe una media query base, pero no fue el foco de esta sesion)
- [ ] SSL en produccion (depende del hosting final, fuera del alcance de codigo)
- [ ] Integracion con pasarela de pagos real (actualmente los pagos se registran y verifican manualmente, segun el modelo de negocio actual del cliente)

---

## 6. Notas de Desarrollo

- **Password BD:** `root` con password vacia -- **CAMBIAR EN PRODUCCION**.
- **Servlet API:** Proyecto usa `javax.servlet` (Tomcat 9). Para migrar a Tomcat 10+, cambiar a `jakarta.servlet`.
- **Manejo de recursos:** Todos los DAO usan try-with-resources (sin memory leak).
- **Encoding:** Todos los Servlets usan `req.setCharacterEncoding("UTF-8")` para evitar problemas de acentos.
- **Hash de claves:** Registro con BCrypt por debajo (`jbcrypt-0.4.jar`).
- **Sesion:** Timeout de 60 minutos definido en `web.xml`.
- **Capacidad:** Limite por defecto es 5 pedidos/dia, configurable admin.
- **Paginacion:** implementada a nivel de JSP (sublist sobre la lista ya cargada), 10 registros/pagina. Si el volumen de datos crece mucho, migrar a `LIMIT`/`OFFSET` en el DAO.
- **Seguridad:** Falta prevencion de CSRF, XSS y rate limiting (fuera del alcance de esta sesion).
- **Git:** Ignora `build/` y `.settings/`.
- **Eclipse:** No subir `.classpath`, `.project`, `.settings/` al repositorio.

---

**Grupo Semestral:** Programacion 2
