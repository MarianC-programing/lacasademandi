# La Casa de Mandi — Proyecto Semestral

Plataforma web para pastelería La casa de Mandi. Proyecto semestral de Programación 2.

## Stack tecnológico

| Capa | Tecnología |
|---|---|
| Frontend | HTML, CSS, JSP |
| Backend | Java Servlets (JSP/Tomcat) |
| Base de datos | MySQL (XAMPP) |
| IDE | Eclipse IDE |

## Estructura del proyecto

```
LacasadeMandi/
├── build/
├── database/
│   ├── schema.sql          -- Esquema completo de 10 tablas en MySQL
│   ├── seed.sql            -- Datos de prueba (catalogo real + 8 pedidos)
│   └── admin.sql           -- Cuenta de administrador
├── docs/
│   ├── Proyecto Semestral La Casa de Mandi.md  -- Vision general y tareas
│   ├── Requisitos Funcionales.md               -- 8 modulos funcionales (RF01-RF08)
│   ├── Vision del Proyecto.md                  -- Problema y solucion
│   ├── Mapa del Sitio.md                       -- 3 zonas: publica, cliente, admin
│   ├── Modelo de Datos.md                      -- 10 entidades con relaciones
│   ├── Wireframes.md                           -- Estructura de todas las pantallas
│   ├── Reglas de Desarrollo.md                 -- 7 reglas del proyecto
│   └── Script Base de Datos.md                 -- Guia de ejecucion del SQL
├── src/main/webapp/
│   ├── index.jsp                    -- Pagina de inicio
│   ├── login.jsp                    -- Login dual (correo o WhatsApp) con BCrypt  
│   ├── login_servlet.jsp            -- Duplicado de login.jsp (archivo extra)
│   ├── panel_admin.jsp              -- Redirect a dashboard
│   ├── css/
│   │   ├── estilos.css              -- Estilos base del sitio (terracota #a23c3e)
│   │   └── login.css                -- Estilos del login (version alternativa)
│   ├── img/                         -- Fotos del equipo (4 integrantes)
│   ├── jsp/layouts/
│   │   ├── header.jsp               -- Header reutilizable con navegacion
│   │   └── footer.jsp               -- Footer reutilizable
│   ├── jsp/publico/
│   │   ├── catalogo.jsp             -- Catalogo con tabs Dulces/Postres
│   │   ├── contacto.jsp             -- Formulario de contacto
│   │   ├── login.jsp                -- Redirect a login.jsp raiz
│   │   └── nosotros.jsp             -- Pagina Sobre Nosotros
│   ├── jsp/cliente/
│   │   ├── mis-pedidos.jsp          -- Lista de pedidos del cliente
│   │   ├── nuevo-pedido.jsp         -- Formulario de nuevo pedido
│   │   ├── detalle-pedido.jsp       -- Detalle de un pedido especifico
│   │   └── mi-perfil.jsp            -- Editar datos personales
│   └── jsp/admin/
│       ├── dashboard.jsp            -- Panel de control del admin
│       ├── pedidos.jsp              -- Gestion de pedidos con filtros
│       └── productos.jsp            -- Gestion de productos
```

## Requisitos para ejecutar

- Eclipse IDE con Tomcat configurado
- XAMPP con MySQL activo
- Java 21
- `jbcrypt-0.4.jar` en `WEB-INF/lib/` (descarga: https://github.com/jeremyh/jBCrypt/releases) igual este repo ya lo tiene
- MySQL Connector: `/usr/share/java/mysql-connector-j-9.7.0.jar` (ya referenciado en `.classpath`)

## Configurar la base de datos

1. Abrir phpMyAdmin: `http://localhost/phpmyadmin`
2. Importar en orden:
   - `database/schema.sql`
   - `database/seed.sql`
   - `database/admin.sql`

## Cuentas de prueba

| Tipo | Correo | Contraseña |
|---|---|---|
| Admin | mandi.admin@gmail.com | MandiWorld |
| Cliente | ana.perez@gmail.com | cliente123 |

## Resumen del Proyecto

**La Casa de Mandi** es una plataforma web para una pasteleria artesanal panamena que digitaliza el ciclo completo del pedido personalizado:

**Flujo:** Catalogo (Dulces y Postres) -> Pedido con diseno a medida -> Abono verificado por admin -> Produccion -> Pago final verificado -> Entrega

**Problema actual del negocio:**
- Pedidos via WhatsApp (se pierden)
-_tracking en Excel (no es compartido ni trazable)
- Cobros por Yappy (sin vinculacion al pedido)
- Sin control de capacidad de produccion diaria

**Objetivo:** Reemplazar el flujo manual con un sistema donde el cliente hace y rastrea su pedido en linea, y el admin gestiona todo desde un panel con control real de lo que puede producir (limite 5 pedidos/dia).

---

## 1. Lo que FUNCIONA (implementado)

### Documentacion (completa)
- Vision del proyecto, requisitos funcionales, modelo ER, mapa del sitio, wireframes, reglas de desarrollo, script SQL con catalogo real

### Base de Datos (completa)
- 10 tablas: Categoria, Cliente, Administrador, Producto, Producto_Variante, Pedido, Pedido_Variante, Abono, Pago_Final, Capacidad_Entrega
- Seed con 7 dulces (3 tamanos cada uno), 3 postres, 5 clientes de prueba, 8 pedidos en todos los estados
- Hashes BCrypt reales para passwords

### Frontend Publico (estructura visual)
- **index.jsp** -- Hero, productos destacados (estaticos), proceso de 4 pasos, noticias
- **catalogo.jsp** -- Tabs Dulces/Postres con tarjetas de producto (datos estaticos)
- **nosotros.jsp** -- Pagina informativa con historia y valores
- **contacto.jsp** -- Formulario de contacto (sin envio real)

### Frontend Cliente (estructura visual, proteccion basica)
- **mis-pedidos.jsp** -- Lista de pedidos con estados (ejemplos estaticos), proteccion por rol `cliente`
- **nuevo-pedido.jsp** -- Formulario de pedido con campos de producto, variante, cantidad, descripcion, fecha (sin logica de guardado)
- **detalle-pedido.jsp** -- Detalle de pedido con info basica (sin conexion a BD)
- **mi-perfil.jsp** -- Formulario de edicion de perfil (sin guardar en BD)

### Frontend Admin (estructura visual, proteccion basica)
- **dashboard.jsp** -- Cards con contadores (estaticos), tabla de pedidos recientes (estaticos), quick links
- **pedidos.jsp** -- Tabla con filtros por estado (estatica)
- **productos.jsp** -- Grid de productos con botones editar/variantes (estatico)

### Login (parcialmente funcional)
- Formulario con login dual: correo o WhatsApp + password
- Verificacion BCrypt con jBCrypt
- Redireccion segun rol: cliente -> mis-pedidos.jsp / admin -> dashboard.jsp
- Manejo basico de sesion

### CSS (completo y coherente)
- Paleta terracota (#a23c3e) sobre fondo crema (#fcf9f8)
- Fuentes: Playfair Display (titulos) + Manrope (cuerpo)
- Badges de estado, campos de formulario, botones, footer, header sticky

---

## 2. ERRORES y PROBLEMAS conocidos

### Errores Funcionales

| # | Error | Archivo | Impacto |
|---|-------|---------|---------|
| 1 | **Login.jsp esta incompleto** -- falta la variable `esCorreo` que determina si el usuario ingreso correo o WhatsApp. La linea de conexion a BD esta truncada (muestra `***@`). Falta logica de deteccion de tipo de usuario. | `login.jsp` | CRITICO -- el login no funciona en su totalidad |
| 2 | **login_servlet.jsp es un duplicado exacto de index.jsp** -- no tiene relacion con un servlet real | `login_servlet.jsp` | Confusion -- archivo innecesario o mal nombrado |
| 3 | **No hay servlet ni clase Java para manejar el login** -- solo existe logica embebida en login.jsp | Proyecto completo | Arquitectura incorrecta para un proyecto Java EE/Servlet |
| 4 | **No hay Servlet de registro** -- la pagina de registro se menciona en login.jsp pero no existe el archivo | `registro.jsp` (faltante) | El usuario no puede crear cuentas nuevas |
| 5 | **Ninguna pagina del lado del cliente conecta con la base de datos** -- las paginas de mis-pedidos, nuevo-pedido, detalle-pedido muestran solo datos de ejemplo estaticos | `jsp/cliente/*.jsp` | El cliente no puede ver sus pedidos reales |
| 6 | **Ninguna pagina del admin conecta con la base de datos** -- dashboard, pedidos, productos muestran datos estaticos | `jsp/admin/*.jsp` | El admin no puede gestionar pedidos/productos reales |
| 7 | **El catalogo no carga productos desde la BD** -- todo es HTML estatico | `catalogo.jsp` | Si se cambia un producto en BD, no se refleja en la web |
| 8 | **La pagina de inicio tiene productos destacados estaticos** -- no lee de la BD | `index.jsp` | Los destacados no reflejan el catalogo real |
| 9 | **Faltan las paginas detalle-dulce.jsp y detalle-postre.jsp** -- los enlaces desde catalogo e index apuntan archivos que no existen | Referencias en catalogo.jsp e index.jsp | Links rotos |
| 10 | **El formulario de nuevo pedido no guarda en la BD** -- solo muestra campos sin action real | `nuevo-pedido.jsp` | El pedido no se registra |
| 11 | **El formulario de contacto no envia** | `contacto.jsp` | El mensaje de contacto no llega |
| 12 | **La pagina de perfil no lee/escribe en BD** | `mi-perfil.jsp` | El usuario no puede editar su perfil |
| 13 | **No existe pagina de registro de abono ni pago final** -- solo hay un boton placeholder | `detalle-pedido.jsp` | La funcionalidad de pagos no esta implementada |
| 14 | **No existe el modulo de reportes** | -- | RF06 no implementado |
| 15 | **No existe la gestion de capacidad de entregas** | -- | RF05 - gestion de capacidad no implementada |

### Errores de Codigo/Arquitectura

| # | Problema | Detalle |
|---|----------|---------|
| 16 | **Arquitectura modelo/vista mezclada** -- toda la logica esta en los JSP sin usar Servlets ni clases DAO | Violacion de separacion de responsabilidades |
| 17 | **No hay clases Java** (modelo/beans, DAO, utilidades) en `src/ | El proyecto solo tiene JSP y CSS, sin capa de logica Java |
| 18 | **Password de BD vacia en conexion.jsp** -- `DB_PASS = ""` | Potencial problema de seguridad |
| 19 | **El footer tiene un caracter de copyright incorrecto** (`<feff>`) | Error de codificacion menor |
| 20 | **El producto-card en productos.jsp tiene `background: #548d2b`** (verde) en lugar del estilo correcto | Error CSS visual en admin |
| 21 | **login.jsp tiene una URL de conexion truncada** -- muestra asteriscos en lugar de la password real | Archivo corrupto o modificado |
| 22 | **No se limpian los recursos de BD correctamente** -- solo `conn.close()` | Potencial memory leak |

### Problemas de Diseno/UX

| # | Problema | Archivo |
|---|----------|---------|
| 24 | Las imagenes del catalogo no existen (tres-leches.jpg, etc.) -- solo se muestran placeholders | Catalogo e index |
| 25 | La pagina de inicio tiene enlaces a `detalle-dulce.jsp` y `detalle-postre.jsp` que no existen | `index.jsp` |
| 26 | No hay pagina de error 404 personalizada | General |
| 27 | No hay feedback al usuario cuando un pedido se registra correctamente | `nuevo-pedido.jsp` |
| 28 | No se valida la fecha de entrega contra la capacidad maxima | `nuevo-pedido.jsp` |

---

## 3. Lo que FALTA (por implementar)

### Modulos criticos faltantes (bloquean funcionalidad)

1. **Sistema de registro de clientes** (registro.jsp + servlet)
2. **Servlets para manejar logica del negocio:**
   - LoginServlet (separar logica de login.jsp)
   - RegistroServlet
   - PedidoServlet (crear, listar, actualizar estado)
   - ProductoServlet (CRUD de productos)
   - AbonoServlet / PagoFinalServlet (registrar pagos)
   - CapacidadServlet (consultar/modificar capacidad)
3. **Clases modelo/beans** (paquete `modelo`): Cliente, Producto, Pedido, etc.
4. **Clases DAO** (paquete `dao`): acceso a BD para cada entidad
5. **Clase utilitaria** de conexion a BD (separar de JSP)
6. **Paginas faltantes:**
   - `registro.jsp` (Publico)
   - `detalle-dulce.jsp` (Publico)
   - `detalle-postre.jsp` (Publico)
   - `clientes.jsp` (Admin)
   - `capacidad.jsp` (Admin)
   - `reportes.jsp` (Admin)

### Funcionalidades RF pendientes

| RF | Modulo | Estado |
|----|--------|--------|
| RF01 | Autenticacion (login/registro) | Parcial (login incompleto, falta registro) |
| RF02 | Catalogo de productos | Estructura visual, sin conexion a BD |
| RF03 | Pedidos (crear, listar, cancelar) | Estructura visual, sin guardar en BD |
| RF04 | Pagos (abono + pago final) | No iniciado |
| RF05 | Panel de administracion | Estructura visual, sin conexion a BD |
| RF06 | Reportes | No iniciado |
| RF07 | Validaciones del sistema | Parcial (solo proteccion de roles en JSP) |
| RF08 | Pagina de inicio publica | Implementada visualmente |

### Funcionalidades de negocio pendientes

- [ ] Precio automatico para postres (cantidad x precio_base)
- [ ] Precio ajustable por admin para dulces
- [ ] Confirmacion de abono y pago final por parte del admin
- [ ] Cambio de estados del pedido (flujo completo)
- [ ] Control de capacidad de entregas (max 5/dia)
- [ ] Bloqueo de fechas sin disponibilidad en datepicker
- [ ] Cancelacion de pedido (solo si esta en estado Pendiente)
- [ ] Historial de pedidos por cliente
- [ ] Reportes de ingresos y productos mas solicitados

---

## 4. Tareas por Prioridad

### Urgente (bloquea funcionalidad basica)
1.  Completar `login.jsp` (variable `esCorreo`, conexion a BD correcta)
2.  Crear `registro.jsp` con su servlet
3.  Crear clases modelo (beans) para las 10 entidades
4.  Crear clases DAO para acceso a BD
5.  Crear Servlets principales (Login, Registro, Pedido)

### Alta (funcionalidad esencial)
6.  Conectar catalogo con la BD (cargar productos dinamicamente)
7.  Implementar creacion de pedido nuevo (guardar en BD)
8.  Implementar listado de pedidos del cliente (desde BD)
9.  Implementar panel admin con datos reales
10. Implementar gestion de productos (CRUD)

### Media (funcionalidad completa)
11. Modulo de abonos y pagos finales
12. Flujo de cambio de estados del pedido
13. Control de capacidad de entregas
14. Modulo de reportes
15. Paginas detalle-dulce.jsp y detalle-postre.jsp

### Baja (pulido)
16. Imagenes reales de los productos
17. Pagina de error 404
18. Formulario de contacto funcional (enviar email)
19. Responsive design mejorado en movil

---

## 5. Notas para el Desarrollo Futuro

- El proyecto usa **Eclipse Workspace** pero no tiene estructura Maven/Gradle -- considerar agregar `pom.xml` o usar el import de Dynamic Web Project de Eclipse
- Las contrasenas se guardan con **BCrypt** (los hashes en seed.sql son de PHP, el login.jsp usa jBCrypt) -- verificar compatibilidad o regenerar hashes
- El driver MySQL (`mysql-connector-j-9.3.0.jar`) esta en `WEB-INF/lib/`
- El proyecto parece estar configurado como proyecto web en Eclipse
- La base de datos debe llamarse `la_casa_de_mandi` con encoding `utf8mb4`
- Faltan validaciones de servidor (lado Java) -- solo hay validaciones HTML basicas

---

## Equipo

| Nombre | Cédula | Rama Git |
|---|---|---|
| Marian Barba | 8-1012-213 | feature/admin-panel |
| Gabriela Fuentes | 8-1042-245 | feature/auth-onboarding |
| Laura Orellana | E-8-221893 | feature/catalogo-publico |
| Evelin Pineda | 8-1031-1126 | feature/pedidos-pagos-cliente |
