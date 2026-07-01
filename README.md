# La Casa de Mandi — Proyecto Semestral

## 📌 Visión General
La Casa de Mandi es una plataforma web para una pastelería artesanal panameña que digitaliza todo el ciclo de pedidos personalizados. El cliente puede ver el catálogo, crear pedidos, hacer pagos parcial (abonos) y finales, y rastrear el estado en tiempo real. El administrador gestiona pedidos, pagos, inventario y controla la capacidad diaria (máximo 5 pedidos por día).

## 🛠️ Tecnologías
| Capa | Tecnología |
|------|-----------|
| Frontend | HTML5, CSS3, JSP |
| Backend | Java (Servlets, JSP), Jakarta EE, Tomcat 9 |
| Base de datos | MySQL (utf8mb4) |
|
## 🚀 Arquitectura
```
LacasadeMandi/
├── build/                        # clases compiladas (.class)
├── database/
│   ├── schema.sql                # 10 tablas principales
│   ├── seed.sql                   # datos de catálogo + 8 pedidos de prueba
│   └── admin.sql                  # cuenta de administrador
├── docs/                          # documentación oficial del proyecto
├── src/main/java/
│   ├── controlador/                # Servlets (Login, Registro, Pedido, Perfil, Pago, Logout)
│   ├── modelo/                    # Bean de dominio (Cliente, Pedido, Producto, etc.)
│   ├── dao/                      # DAO con conexiones centralizadas (Conexion.java)
│   └── util/                      # utilidades de conexión
└── src/main/webapp/
    ├── index.jsp                 # landing page
    ├── login.jsp                 # login dual (correo/WhatsApp)
    ├── WEB-INF/
    │   ├── web.xml                # mapeo de servlets
    │   └── lib/                   # mysql‑connector‑j, jbcrypt
    ├── css/                     # estilos base y admin
    ├── img/                     # asset de logos, hero, iconos
    ├── jsp/
    │   ├── layouts/             # header/footer dinámicos
    │   ├── publico/             # catálogo, detalle, nosotros, registro
    │   ├── cliente/              # mis‑pedidos, nuevo‑pedido, detalle‑pedido, mi‑perfil
    │   └── admin/                # dashboard, pedidos, productos, clientes, sidebar, footer
```

## ✨ Estado actual
| Componente | Estatus |
|------------|---------|
| **Banco de datos** | Estructura completa (`schema.sql`), datos iniciales cargados. |
| **Bean‑DAO‑Servlet** | Todos funcionales, con validaciones de correo/WhatsApp y BCrypt. |
| **Pago** | Modelo y DAO totalmente funcionales (abonos y pagos finales). |
| **Frontend Cliente** | Detalle‑pedido, nuevos‑pedido, mis‑pedidos, etc., conectados a BD, cálculo de totales en vivo. |
| **Frontend Admin** | Dashboard con contadores reales, pedidos, productos, clientes, sidebar reutilizable. |
| **Autenticación** | Login dual, sesiones con roles, validaciones de propiedades del pedido. |
| **Otras vistas** | Registro, nosotros, catalogo. |
| **Commit pendientes** | Páginas `capacidad.jsp` y `reportes.jsp`, módulo de capacidad de entregas, reportes de ingresos. |

## ⚙️ Procedimientos de montaje
1. **Clonar repositorio**
   ```bash
   git clone https://github.com/tu-usuario/LacasadeMandi.git
   ```
2. **Configurar BD**
   ```sql
   CREATE DATABASE la_casa_de_mandi CHARACTER SET utf8mb4;
   USE la_casa_de_mandi;
   SOURCE database/schema.sql;
   SOURCE database/seed.sql;
   ```
3. **Arrancar Tomcat** (o cualquier contenedor compatible con Jakarta EE 9)
   ```bash
   cd $TOMCAT_HOME/bin
   ./startup.sh
   ```
4. **Visita** `http://localhost:8080`.

## 🧪 Pruebas
El proyecto usa JUnit y Mockito a través de Maven (se encuentra el pom.xml en la raíz). Ejecútalas con:
```bash
mvn test
```
Los resultados aparecen en `target/surefire-reports`.

## 🔥 Próximas tareas
- Páginas `capacidad.jsp` y `reportes.jsp` (admin). 
- Módulo de capacidad de entregas (limite 5 pedidos por día). 
- Resumir ingresos mensual y productos más solicitados. 
- Página de error 404 personalizada. 
- Mejorar responsive en móvil.

## 🎯 Roadmap
| Prioridad | Feature |
|-----------|---------|
| Urgente | Módulo de pagos y confirmaciones. |
| Alta | Control de capacidad de entregas. |
| Media | Páginas de reportes e informes. |
| Baja | Políticas de seguridad, API REST futura. |

---

*Documento generado automáticamente a partir del análisis del código fuente.*
