# Contexto del Proyecto — La Casa de Mandi

> **Ruta del proyecto:** `/home/marian01/eclipse-workspace/LacasadeMandi/`
> **Última actualización:** 29 de junio de 2026
> **Tecnología:** Java (JSP + Servlets) + MySQL + CSS propio

---

## 1. Resumen del Proyecto

**La Casa de Mandi** es una plataforma web para una pastelería artesanal panameña que digitaliza el ciclo completo del pedido personalizado:

**Flujo:** Catálogo (Dulces y Postres) → Pedido con diseño a medida → Abono verificado por admin → Producción → Pago final verificado → Entrega

**Problema actual del negocio:**
- Pedidos vía WhatsApp (se pierden)
- Tracking en Excel (no es compartido ni trazable)
- Cobros por Yappy (sin vinculación al pedido)
- Sin control de capacidad de producción diaria

**Objetivo:** Reemplazar el flujo manual con un sistema donde el cliente hace y rastrea su pedido en línea, y el admin gestiona todo desde un panel con control real de lo que puede producir (límite 5 pedidos/día).

---

## 2. Estructura del Proyecto

```
LacasadeMandi/
├── build/
├── database/
│   ├── schema.sql
│   ├── seed.sql
│   └── admin.sql
├── docs/
│   ├── contexto-proyecto-lacasademandi.md   -- ESTE DOCUMENTO
│   ├── Proyecto Semestral La Casa de Mandi.md
│   ├── Requisitos Funcionales.md
│   ├── Vision del Proyecto.md
│   ├── Mapa del Sitio.md
│   ├── Modelo de Datos.md
│   ├── Wireframes.md
│   ├── Reglas de Desarrollo.md
│   └── Script Base de Datos.md
├── src/main/java/
│   ├── controlador/
│   │   ├── RegistroServlet.java     ✅ Funcional (GET=form, POST=registra+login)
│   │   ├── PedidoServlet.java       ❌ Declarado en web.xml pero .java FALTANTE
│   │   ├── PerfilServlet.java        ❌ Declarado en web.xml pero .java FALTANTE
│   │   └── LogoutServlet.java       ❌ Declarado en web.xml pero .java FALTANTE
│   ├── modelo/
│   │   ├── Cliente.java              ✅ Bean completo (6 campos)
│   │   ├── Producto.java             ✅ Bean completo (8 campos + lista variantes)
│   │   ├── Variante.java             ✅ Bean completo (5 campos)
│   │   ├── Pedido.java               ✅ Bean completo (10 campos)
│   │   ├── Administrador.java         ❌ FALTANTE
│   │   ├── Abono.java                ❌ FALTANTE
│   │   ├── PagoFinal.java            ❌ FALTANTE
│   │   ├── CapacidadEntrega.java     ❌ FALTANTE
│   │   ├── Categoria.java            ❌ FALTANTE
│   │   └── PedidoVariante.java       ❌ FALTANTE
│   ├── dao/
│   │   ├── ClienteDAO.java           ✅ Completo (CRUD + búsqueda por correo/WhatsApp)
│   │   ├── ProductoDAO.java          ✅ Completo (listar por categoría, por ID, variantes)
│   │   ├── PedidoDAO.java           ✅ Completo (crear con transacción, listar, estados, contadores)
│   │   ├── AdministradorDAO.java     ❌ FALTANTE
│   │   ├── AbonoDAO.java             ❌ FALTANTE
│   │   ├── PagoFinalDAO.java         ❌ FALTANTE
│   │   ├── CapacidadEntregaDAO.java  ❌ FALTANTE
│   │   ├── CategoriaDAO.java         ❌ FALTANTE
│   │   └── PedidoVarianteDAO.java    ❌ FALTANTE
│   └── util/
│       └── Conexion.java             ✅ Clase utilitaria de conexión a BD
├── src/main/webapp/
│   ├── index.jsp                     -- Productos destacados estáticos
│   ├── login.jsp                    ✅ Login dual FUNCIONAL (lógica embebida en JSP)
│   ├── login_servlet.jsp            ⚠️ Duplicado — ELIMINAR
│   ├── panel_admin.jsp              -- Redirect a dashboard
│   ├── WEB-INF/
│   │   ├── web.xml                  ✅ Creado con 4 servlets mapeados
│   │   ├── conexion.jsp             ⚠️ REDUNDANTE (reemplazado por util/Conexion.java)
│   │   └── lib/
│   │       ├── mysql-connector-j-9.3.0.jar
│   │       └── jbcrypt-0.4.jar
│   ├── css/
│   │   ├── estilos.css
│   │   └── login.css
│   ├── img/
│   ├── jsp/layouts/
│   │   ├── header.jsp               ✅ CORREGIDO
│   │   └── footer.jsp               ✅ CORREGIDO
│   ├── jsp/publico/
│   │   ├── catalogo.jsp             ✅ CONECTADO A BD (ProductoDAO)
│   │   ├── contacto.jsp             -- No envía
│   │   ├── login.jsp                -- Redirect
│   │   ├── nosotros.jsp
│   │   └── registro.jsp             ❌ FALTANTE (el servlet forwards aquí)
│   ├── jsp/cliente/
│   │   ├── mis-pedidos.jsp          -- Datos estáticos (EJEMPLO), sin BD
│   │   ├── nuevo-pedido.jsp         -- Form sin action, no guarda
│   │   ├── detalle-pedido.jsp       -- Datos estáticos, sin BD
│   │   └── mi-perfil.jsp            ✅ Texto chino eliminado, sin BD
│   └── jsp/admin/
│       ├── dashboard.jsp            -- Contadores y tabla estáticos, sin BD
│       ├── pedidos.jsp              -- Tabla estática, sin BD
│       └── productos.jsp            ✅ CSS verde corregido, sin BD
```

> ⚠️ **Problema 1:** `web.xml` declara 3 servlets (`PedidoServlet`, `PerfilServlet`, `LogoutServlet`) cuyas clases `.java` NO existen → **la aplicación NO despliega** (ClassNotFoundException en Tomcat).
>
> ⚠️ **Problema 2:** `RegistroServlet.doGet()` hace forward a `/jsp/publico/registro.jsp` pero ese archivo **NO existe** → **HTTP 404** al entrar a `/registro`.
>
> ⚠️ **Problema 3:** Los JSPs de cliente y admin siguen mostrando datos estáticos. Solo `catalogo.jsp` se conecta a la BD.

---

## 3. Lo que FUNCIONA (implementado y operativo)

### Documentación (completa)
- Visión, requisitos funcionales, modelo ER, mapa del sitio, wireframes, reglas de desarrollo, script SQL.

### Base de Datos (completa)
- 10 tablas: Categoria, Cliente, Administrador, Producto, Producto_Variante, Pedido, Pedido_Variante, Abono, Pago_Final, Capacidad_Entrega
- Seed con 7 dulces (3 tamaños), 3 postres, 5 clientes de prueba, 8 pedidos en todos los estados
- Hashes BCrypt reales para passwords

### Login (FUNCIONAL ✅)
- Detección automática del tipo de usuario: `esCorreo = usuario.contains("@")`
- Búsqueda primero en Administrador (solo por correo), luego en Cliente (correo o WhatsApp)
- Verificación BCrypt con jBCrypt
- Redirección según rol: `cliente` → `mis-pedidos.jsp` / `admin` → `dashboard.jsp`
- Sesión con atributos: `rol`, `id_cliente`/`id_admin`, `nombre`
- `.classpath` corregido — jars declarados correctamente en Eclipse
- ⚠️ Arquitectura: la lógica sigue embebida en JSP, debería migrarse a `LoginServlet`

### Registro (FUNCIONAL ✅ — servlet, falta JSP)
- `RegistroServlet` implementado con `jakarta.servlet` (Jakarta EE)
- GET: forward a `/jsp/publico/registro.jsp` (archivo FALTANTE)
- POST: valida campos, verifica duplicados con `ClienteDAO`, hashea BCrypt con `gensalt(12)`, registra y abre sesión
- Validaciones: campos vacíos, correo con `@`, password ≥6 chars, coincidencia de passwords
- Detección de correo/WhatsApp duplicados vía `ClienteDAO.existeCorreo()` / `existeWhatsapp()`
- **BCrypt aplicado correctamente en el Servlet** (no en el DAO) ✅

### Catálogo (CONECTADO A BD ✅)
- `catalogo.jsp` importa `ProductoDAO` y `modelo.Producto`/`modelo.Variante`
- Carga productos dinámicamente con `dao.listarPorCategoria("Dulces")` y `"Postres"`
- Tabs Dulces/Postres con JavaScript, cada tarjeta muestra nombre, descripción y precio desde BD
- Enlace "Pedir ahora" apunta a `nuevo-pedido.jsp?producto=<idProducto>`
- Manejo de lista vacía con mensaje "No hay productos disponibles"
- ⚠️ La lógica de BD está en el JSP ( debería migrarse a `CatalogoServlet`)

### Capa Java — Modelos (4 de 10) ✅
- `Cliente.java` — idCliente, nombre, teléfono, whatsapp, correo, password
- `Producto.java` — idProducto, idCategoria, nombreCategoria, nombre, descripción, imagen, disponible, lista de variantes
- `Variante.java` — idVariante, idProducto, tamano, precioBase, disponible
- `Pedido.java` — idPedido, idCliente, nombreCliente, fechaPedido, fechaEntrega, descripcionDiseno, estado, precioTotal, precioConfirmado, nombreProducto, tamanoVariante

### Capa Java — DAOs (3 de 9) ✅
- `ClienteDAO` — buscarPorCorreo, buscarPorWhatsapp, buscarPorId, registrar, existeCorreo, existeWhatsapp, actualizar
- `ProductoDAO` — listarPorCategoria, listarTodos, buscarPorId, buscarVariantePorId, listarVariantes
- `PedidoDAO` — listarPorCliente, listarTodos (con filtro), buscarPorId, crear (con transacción), actualizarEstado, confirmarPrecio, contarPorEstado

### Capa Java — Servlets (1 de 4 declarados) ✅
- `RegistroServlet` — funcional y completo

### Capa Java — Utilidades ✅
- `util/Conexion.java` — conexión singleton con try-with-resources, URL completa, driver MySQL cargado en static block

### web.xml (CREADO ✅)
- 4 servlets mapeados: `/registro`, `/pedido`, `/perfil`, `/logout`
- Session timeout: 60 minutos
- Welcome file: `index.jsp`
- ⚠️ Usa namespace Jakarta EE 5.0 (`jakarta.servlet`) — verificar que Tomcat 9 soporta Jakarta (Tomcat 9 usa `javax.servlet`; Jakarta EE requiere Tomcat 10+)

### Header/Footer (CORREGIDO ✅)
- `header.jsp` declara `paginaActiva` desde `request.getAttribute()` — sin variable duplicada
- Todos los JSP usan `request.setAttribute("paginaActiva", "...")` antes del include
- `footer.jsp` usa `&copy;` en lugar del carácter corrupto anterior

### Frontend Público (estructura visual)
- `index.jsp` — productos destacados estáticos
- `catalogo.jsp` — ✅ **CONECTADO A BD** (ProductoDAO)
- `nosotros.jsp`, `contacto.jsp`

### Frontend Cliente (estructura visual, protección por rol, sin BD)
- `mis-pedidos.jsp`, `nuevo-pedido.jsp`, `detalle-pedido.jsp`, `mi-perfil.jsp`

### Frontend Admin (estructura visual, protección por rol, sin BD)
- `dashboard.jsp`, `pedidos.jsp`, `productos.jsp`

### CSS (completo y coherente)
- Paleta terracota `#a23c3e` sobre fondo crema `#fcf9f8`
- Fuentes: Playfair Display (títulos) + Manrope (cuerpo)
- Badges de estado, formularios, botones, header sticky, footer

---

## 4. ERRORES RESUELTOS (sesiones 28-29 jun 2026)

| # | Error | Archivo(s) | Solución aplicada | Sesión |
|---|-------|------------|-------------------|--------|
| E1 | `org.mindrot cannot be resolved` | `login.jsp` / `.classpath` | Ambos jars agregados a `.classpath` | 28 jun |
| E2 | `paginaActiva cannot be resolved` en header.jsp | `header.jsp` | Declaración de variable movida al header con valor por defecto desde request | 28 jun |
| E3 | `Duplicate local variable paginaActiva` en 12 JSPs | Todos los JSP | `String paginaActiva = ...` → `request.setAttribute(...)` | 28 jun |
| E4 | Carácter copyright corrupto `<feff>` | `footer.jsp` | Reemplazado por `&copy;` | 28 jun |
| E5 | `background: #548d2b` (verde) en `.producto-card` | `productos.jsp` | Corregido a `background: #fff` | 28 jun |
| E6 | `href="# safasf"` con basura | `productos.jsp` | Corregido a `href="#"` | 28 jun |
| E7 | Texto chino `做错系统` en sidebar | `mi-perfil.jsp` | Texto eliminado | 28 jun |
| E8 | Variable `esCorreo` faltante en login | `login.jsp` | Agregada: `boolean esCorreo = usuario.contains("@")` | 28 jun |
| E9 | URL de conexión truncada | `login.jsp` | URL completa restaurada | 28 jun |
| E10 | Sin clases Java en `src/main/java/` | `modelo/`, `dao/`, `util/` | Creados: 4 beans, 3 DAOs, Conexion.java | 28 jun |
| E11 | Sin servlet de registro | `controlador/` | Creado `RegistroServlet.java` con Jakarta EE | 29 jun |
| E12 | Sin `web.xml` | `WEB-INF/` | Creado con 4 servlets mapeados, session-config | 29 jun |
| E13 | Catálogo con datos estáticos | `catalogo.jsp` | Conectado a BD con `ProductoDAO.listarPorCategoria()` | 29 jun |

---

## 5. ERRORES PENDIENTES

### Errores CRÍTICOS (bloquean despliegue)

| # | Error | Archivo/Zona | Impacto |
|---|-------|-------------|---------|
| P0a | **`PedidoServlet.java`, `PerfilServlet.java`, `LogoutServlet.java` NO EXISTEN** pero están declarados en `web.xml` | `controlador/` faltante | **ClassNotFoundException en Tomcat** — la aplicación NO arranca |
| P0b | **`registro.jsp` NO EXISTE** pero `RegistroServlet.doGet()` hace forward a ella | `jsp/publico/registro.jsp` faltante | **HTTP 404** al entrar a `/registro` |
| P0c | Posible incompatibilidad **Tomcat 9 vs Jakarta EE 5.0** | `web.xml`, `RegistroServlet.java` | Tomcat 9 usa `javax.servlet`; Jakarta EE requiere Tomcat 10+. Si usan Tomcat 9, ambos servlet y web.xml deben usar `javax.servlet.*` |

### Errores arquitectónicos

| # | Error | Archivo/Zona | Impacto |
|---|-------|-------------|---------|
| P1 | Login y catálogo usan lógica embebida en JSP, no Servlets | `login.jsp`, `catalogo.jsp` | Arquitectura híbrida. Falta `LoginServlet` y `CatalogoServlet` |
| P2 | JSPs de cliente/admin siguen sin usar DAOs | `jsp/cliente/*.jsp`, `jsp/admin/*.jsp` | Datos estáticos |
| P4 | `conexion.jsp` es REDUNDANTE con `util/Conexion.java` | `WEB-INF/conexion.jsp` | Dos mecanismos de conexión coexisten — eliminar el JSP |

### Errores funcionales

| # | Error | Archivo | Impacto |
|---|-------|---------|---------|
| P5 | Falta `registro.jsp` (vista del formulario) | `jsp/publico/registro.jsp` | El servlet funciona pero no hay vista |
| P6 | Páginas de cliente sin conexión a BD | `jsp/cliente/*.jsp` | El cliente no ve datos reales |
| P7 | Páginas de admin sin conexión a BD | `jsp/admin/*.jsp` | El admin no puede gestionar datos reales |
| P8 | Inicio con productos estáticos | `index.jsp` | No refleja BD (a diferencia de catálogo que ya se conectó) |
| P9 | Faltan `detalle-dulce.jsp` y `detalle-postre.jsp` | Referencias en catálogo e index | Links rotos |
| P10 | Formulario de nuevo pedido no guarda | `nuevo-pedido.jsp` | RF03 incompleto |
| P11 | Sin módulo de abonos ni pago final | `detalle-pedido.jsp` | RF04 no iniciado |
| P12 | Sin módulo de reportes | — | RF06 no iniciado |
| P13 | Sin gestión de capacidad de entregas | — | RF05 no iniciado |
| P14 | Formulario de contacto no envía | `contacto.jsp` | RF decorativo |
| P15 | Perfil no lee/escribe en BD | `mi-perfil.jsp` | El cliente no puede editar datos |
| P16 | Sin validación de fecha contra capacidad | `nuevo-pedido.jsp` | RF05 no integrado |

### Errores de código/Diseño

| # | Error | Archivo | Detalle |
|---|-------|---------|---------|
| P17 | `PedidoDAO.listarTodos()` concatena WHERE sin espacio previo | `PedidoDAO.java:48` | Funciona por suerte pero es frágil |
| P18 | `PedidoDAO` ignora SQLExceptions silenciosamente | `PedidoDAO.java:57,84` | `try { } catch (SQLException ignored) {}` oculta errores reales |
| P19 | `login_servlet.jsp` es duplicado exacto de `index.jsp` | `login_servlet.jsp` | Eliminar archivo |
| P20 | `PreparedStatement`/`ResultSet` no se cierran con try-with-resources en login | `login.jsp:58,85` | Resource leak — `rs.close(); ps.close()` manual |
| P21 | Sin filtro de seguridad HTTP | Todo el proyecto | Protección de sesión/rol manual con scriptlets. Debería haber un `Filter` |
| P22 | Sin página de error 404/500 personalizada | General | No hay error-pages en web.xml |
| P23 | Imágenes del catálogo no existen | `catalogo.jsp`, `index.jsp` | Solo placeholders grises |
| P24 | `ClienteDAO.buscarPor()` usa nombre de columna dinámico | `ClienteDAO.java:76` | SQL injection improbable pero viola buenas prácticas |
| P25 | `catalogo.jsp` llama DAO directamente desde JSP | `catalogo.jsp:3-6` | Debería usar `CatalogoServlet` que pase datos vía `request.setAttribute()` |
| P26 | `login.jsp` también llama BD directamente sin DAO | `login.jsp:27-31` | Debería usar `ClienteDAO` y `AdministradorDAO` |

---

## 6. Modelos y DAOs — Estado detallado

### Beans (modelo/)

| Bean | Estado | Campos | Observación |
|------|--------|--------|-------------|
| `Cliente` | ✅ Completo | 6 | idCliente, nombre, telefono, whatsapp, correo, password |
| `Producto` | ✅ Completo | 8 + lista | Incluye lista de variantes |
| `Variante` | ✅ Completo | 5 | idVariante, idProducto, tamano, precioBase, disponible |
| `Pedido` | ✅ Completo | 10 | Incluye nombreProducto y tamanoVariante para listados |
| `Administrador` | ❌ Faltante | — | El login.jsp consulta la tabla pero usa SQL inline |
| `Abono` | ❌ Faltante | — | Necesario para RF04 |
| `PagoFinal` | ❌ Faltante | — | Necesario para RF04 |
| `CapacidadEntrega` | ❌ Faltante | — | Necesario para RF05 |
| `Categoria` | ❌ Faltante | — | Utilizado internamente en ProductoDAO como string |
| `PedidoVariante` | ❌ Faltante | — | Se inserta dentro de PedidoDAO.crear() sin bean propio |

### DAOs (dao/)

| DAO | Estado | Métodos | Observación |
|-----|--------|---------|-------------|
| `ClienteDAO` | ✅ Completo | 7 | buscarPorCorreo, buscarPorWhatsapp, buscarPorId, registrar, existeCorreo, existeWhatsapp, actualizar |
| `ProductoDAO` | ✅ Completo | 5 | listarPorCategoria, listarTodos, buscarPorId, buscarVariantePorId, listarVariantes |
| `PedidoDAO` | ✅ Completo | 7 | listarPorCliente, listarTodos, buscarPorId, crear, actualizarEstado, confirmarPrecio, contarPorEstado |
| `AdministradorDAO` | ❌ Faltante | — | Necesario para extraer SQL del login.jsp |
| `AbonoDAO` | ❌ Faltante | — | Registrar/listar abonos — RF04 |
| `PagoFinalDAO` | ❌ Faltante | — | Registrar/listar pagos finales — RF04 |
| `CapacidadEntregaDAO` | ❌ Faltante | — | Consultar/disponer fechas — RF05 |
| `CategoriaDAO` | ❌ Faltante | — | Listar categorías para catálogo dinámico |
| `PedidoVarianteDAO` | ❌ Faltante | — | Se maneja dentro de PedidoDAO pero debería ser DAO propio |

### Servlets (controlador/)

| Servlet | Estado | URL | Observación |
|---------|--------|-----|-------------|
| `RegistroServlet` | ✅ Funcional | `/registro` | GET=form, POST=registra+login. Usa Jakarta EE. |
| `PedidoServlet` | ❌ **FALTANTE** | `/pedido` | Declarado en web.xml pero .java no existe → **ClassNotFoundException** |
| `PerfilServlet` | ❌ **FALTANTE** | `/perfil` | Declarado en web.xml pero .java no existe → **ClassNotFoundException** |
| `LogoutServlet` | ❌ **FALTANTE** | `/logout` | Declarado en web.xml pero .java no existe → **ClassNotFoundException** |
| `LoginServlet` | — | — | No declarado en web.xml (login sigue en JSP) |
| `CatalogoServlet` | — | — | No declarado en web.xml (catálogo consulta DAO desde JSP) |

---

## 7. Funcionalidades RF — Estado actualizado

| RF | Módulo | Estado | Detalle |
|----|--------|--------|---------|
| RF01 | Autenticación (login/registro) | ⚠️ Parcial | Login funcional en JSP. Registro: Servlet funcionando, **falta JSP**. Falta `LoginServlet`. Verificar compatibilidad Jakarta/javax |
| RF02 | Catálogo de productos | ⚠️ Parcial | ✅ `catalogo.jsp` CONECTADO A BD. `index.jsp` sigue estático. Falta Servlet para catálogo |
| RF03 | Pedidos (crear, listar, cancelar) | ⚠️ Parcial | `PedidoDAO` con crear/listar/estados. `PedidoServlet` declarado en web.xml pero **.java no existe**. JSPs estáticos |
| RF04 | Pagos (abono + pago final) | ❌ No iniciado | Sin beans, DAOs, Servlets ni JSP |
| RF05 | Panel de administración | ⚠️ Parcial | Vistas hechas, `PedidoDAO.contarPorEstado()` existe. JSPs NO lo usan |
| RF06 | Reportes | ❌ No iniciado | Sin implementación |
| RF07 | Validaciones del sistema | ⚠️ Parcial | Protección de roles en JSP con scriptlets. Sin Filter, sin error-pages |
| RF08 | Página de inicio pública | ⚠️ Parcial | Implementada visualmente, productos destacados estáticos |

---

## 8. Navigator: qué falta para conectar DAOs → JSPs

El problema central actual es que la **capa de datos existe pero está parcialmente desconectada**. `catalogo.jsp` ya se conectó directamente (sin Servlet). Para una arquitectura correcta se necesita:

### Flujo actual (mixto):
```
catalogo.jsp → ProductoDAO directamente (sin Servlet) ← FUNCIONA pero incorrecto
login.jsp    → JDBC directamente (sin DAO, sin Servlet) ← FUNCIONA pero incorrecto
mis-pedidos.jsp → datos estáticos                     ← NO FUNCIONA
nuevo-pedido.jsp → form sin action                    ← NO FUNCIONA
dashboard.jsp    → datos estáticos                    ← NO FUNCIONA
```

### Flujo deseado:
```
Cliente → Servlet (llama DAO) → request.setAttribute() → JSP (muestra datos)
```

### Conexiones necesarias:

| JSP | DAO a conectar | Servlet necesario | Estado |
|-----|---------------|-------------------|--------|
| `catalogo.jsp` | `ProductoDAO.listarPorCategoria()` | `CatalogoServlet` (GET) | ⚠️ DAO en JSP directo — migrar a Servlet |
| `index.jsp` | `ProductoDAO.listarTodos()` | `InicioServlet` (GET) | ❌ Sin conectar |
| `login.jsp` | `ClienteDAO` + `AdministradorDAO` | `LoginServlet` (POST) | ⚠️ JDBC inline — migrar a DAO+Servlet |
| `nuevo-pedido.jsp` | `ProductoDAO.listarTodos()` + `PedidoDAO.crear()` | `PedidoServlet` (GET=form, POST=guardar) | ❌ Servlet declarado en web.xml pero .java faltante |
| `mis-pedidos.jsp` | `PedidoDAO.listarPorCliente()` | `MisPedidosServlet` (GET) | ❌ Sin conectar |
| `detalle-pedido.jsp` | `PedidoDAO.buscarPorId()` | `DetallePedidoServlet` (GET) | ❌ Sin conectar |
| `dashboard.jsp` | `PedidoDAO.contarPorEstado()` + `PedidoDAO.listarTodos()` | `DashboardServlet` (GET) | ❌ Sin conectar |
| `pedidos.jsp` | `PedidoDAO.listarTodos(filtro)` | `AdminPedidosServlet` (GET) | ❌ Sin conectar |
| `productos.jsp` | `ProductoDAO.listarTodos()` | `AdminProductosServlet` (GET) | ❌ Sin conectar |
| `mi-perfil.jsp` | `ClienteDAO.buscarPorId()` + `actualizar()` | `PerfilServlet` (GET=mostrar, POST=guardar) | ❌ Servlet declarado en web.xml pero .java faltante |

---

## 9. Páginas faltantes

| Página | Zona | Prioridad | Dependencias | Nota |
|---------|------|-----------|-------------|------|
| `registro.jsp` | Público | 🔴 **CRÍTICO** | `RegistroServlet` ya existe | El servlet forwadea aquí pero NO EXISTE → 404 |
| `detalle-dulce.jsp` | Público | 🟠 Alta | `ProductoServlet` (por ID) | |
| `detalle-postre.jsp` | Público | 🟠 Alta | `ProductoServlet` (por ID) | |
| `clientes.jsp` | Admin | 🟡 Media | `ClienteDAO` (listar todos) | |
| `capacidad.jsp` | Admin | 🟡 Media | `CapacidadEntregaDAO` + Servlet | |
| `reportes.jsp` | Admin | 🟡 Media | Queries de reportes | |
| `abono.jsp` | Admin/Cliente | 🟡 Media | `AbonoDAO` + Servlet | |
| `pago-final.jsp` | Admin/Cliente | 🟡 Media | `PagoFinalDAO` + Servlet | |
| `error-404.jsp` | General | 🟢 Baja | Config en `web.xml` | |
| `error-500.jsp` | General | 🟢 Baja | Config en `web.xml` | |

---

## 10. Próximos pasos (por prioridad)

### 🔴 CRÍTICO — errores que bloquean despliegue
1. Crear `PedidoServlet.java`, `PerfilServlet.java`, `LogoutServlet.java` (o eliminar del `web.xml` temporalmente)
2. Crear `jsp/publico/registro.jsp` (formulario de registro con campos: nombre, correo, whatsapp, teléfono, password, password2)
3. Verificar compatibilidad **Jakarta EE vs javax.servlet**: si usan Tomcat 9, cambiar imports a `javax.servlet.*` en `RegistroServlet` y namespace en `web.xml`; si usan Tomcat 10+, mantener Jakarta

### 🔴 Urgente — conectar la capa de datos
4. `LoginServlet.java` — migrar lógica de `login.jsp` → usar `ClienteDAO` + crear `AdministradorDAO`
5. `CatalogoServlet.java` — migrar lógica de `catalogo.jsp` → pasar productos vía `request.setAttribute()`
6. Conectar `nuevo-pedido.jsp` → `PedidoServlet` → `PedidoDAO.crear()` + `ProductoDAO`
7. Conectar `mis-pedidos.jsp` → `MisPedidosServlet` → `PedidoDAO.listarPorCliente()`
8. Eliminar `login_servlet.jsp` y `WEB-INF/conexion.jsp`

### 🟠 Alta — funcionalidad esencial con datos reales
9. Conectar `dashboard.jsp` → `DashboardServlet` → `PedidoDAO.contarPorEstado()` + `listarTodos()`
10. Conectar `pedidos.jsp` → `AdminPedidosServlet` → `PedidoDAO.listarTodos(filtro)`
11. Conectar `productos.jsp` → `AdminProductosServlet` → `ProductoDAO.listarTodos()`
12. Conectar `mi-perfil.jsp` → `PerfilServlet` (GET=datos, POST=guardar) → `ClienteDAO`
13. Crear `Administrador.java` (bean) + `AdministradorDAO.java`
14. Crear `detalle-dulce.jsp` + `detalle-postre.jsp`

### 🟡 Media — funcionalidad completa (RF04, RF05, RF06)
15. Crear beans faltantes: `Abono`, `PagoFinal`, `CapacidadEntrega`, `Categoria`, `PedidoVariante`
16. Crear DAOs faltantes: `AbonoDAO`, `PagoFinalDAO`, `CapacidadEntregaDAO`, `CategoriaDAO`
17. `AbonoServlet` + `abono.jsp` — módulo de abonos (RF04)
18. `PagoFinalServlet` + `pago-final.jsp` — módulo de pagos finales (RF04)
19. `CapacidadServlet` + `capacidad.jsp` — control de entregas (RF05)
20. Validación de fecha de entrega vs capacidad en `nuevo-pedido.jsp`
21. `ReporteServlet` + `reportes.jsp` — módulo de reportes (RF06)
22. `FiltroAutenticacion.java` — Filter de sesión/rol para reemplazar scriptlets

### 🟢 Baja — pulido final
23. Imágenes reales de los productos
24. Página 404/500 personalizada + config en `web.xml`
25. Formulario de contacto funcional (enviar email)
26. Responsive design en móvil
27. Corregir `PedidoDAO.listarTodos()` — concatenación de WHERE
28. Eliminar `catch (SQLException ignored)` en `PedidoDAO`
29. Cerrar `PreparedStatement`/`ResultSet` en `login.jsp` con try-with-resources

---

## 11. Funcionalidades de negocio pendientes

- [ ] Precio automático para postres (cantidad × precio_base)
- [ ] Precio ajustable por admin para dulces
- [ ] Confirmación de abono y pago final por parte del admin
- [ ] Cambio de estados del pedido (flujo completo: Pendiente → Aceptado → En Producción → Listo → Entregado)
- [ ] Control de capacidad de entregas (max 5/día)
- [ ] Bloqueo de fechas sin disponibilidad en datepicker
- [ ] Cancelación de pedido (solo si está en estado Pendiente)
- [ ] Historial de pedidos por cliente
- [ ] Reportes de ingresos y productos más solicitados

---

## 12. Notas técnicas

- **⚠️ Jakarta EE vs javax.servlet:** `RegistroServlet.java` usa `import jakarta.servlet.*` y `web.xml` usa namespace Jakarta EE 5.0. **Tomcat 9 usa `javax.servlet`**; Jakarta EE requiere Tomcat 10+. Verificar qué Tomcat tienen configurado. Si es Tomcat 9, cambiar todos los imports y el namespace a `javax.servlet`.
- **jBCrypt:** `jbcrypt-0.4.jar` en `WEB-INF/lib/` y declarado en `.classpath`. Si los hashes del `seed.sql` (generados con PHP) no validan, regenerarlos con jBCrypt desde Java.
- **BCrypt en registro:** ✅ Correctamente implementado en `RegistroServlet` linea 68: `BCrypt.hashpw(password, BCrypt.gensalt(12))`. El DAO solo guarda.
- **MySQL driver:** `mysql-connector-j-9.3.0.jar` en `WEB-INF/lib/` y en `.classpath`.
- **BD:** nombre `la_casa_de_mandi`, encoding `utf8mb4`, usuario `root`, password vacía (cambiar en producción).
- **Tomcat:** configurado en `.classpath` como Apache Tomcat v9.0. **Si es realmente Tomcat 9, los servlets Jakarta NO funcionarán** — usar `javax.servlet.*`.
- **Java:** JDK 21.
- **Eclipse:** Dynamic Web Project sin Maven/Gradle. Build output en `build/classes/`.
- **paginaActiva:** siempre pasar con `request.setAttribute("paginaActiva", "valor")` antes del include del header. Valores: `inicio`, `catalogo`, `nosotros`, `contacto`, `pedidos`.
- **conexion.jsp:** archivo redundante en `WEB-INF/`. Todos los nuevos desarrollos deben usar `util/Conexion.java`. Eliminar cuando ningún JSP lo referencie.
- **web.xml:** existe pero declara 3 servlets sin .java → **la app no despliega hasta crear los archivos o comentar las declaraciones**.
- **Sin Filter de autenticación:** actualmente cada JSP protege su acceso con scriptlets manuales. Crear `FiltroAutenticacion` que implemente `javax.servlet.Filter` (o `jakarta.servlet.Filter`) y verifique `session.getAttribute("rol")` por patrón de URL.
- **Paquete `controlador`:** los servlets van en `controlador/`, no en `servlet/` como se mencionaba anteriormente. Mantener esta convención.

---

*Documento actualizado el 29 de junio de 2026.*
