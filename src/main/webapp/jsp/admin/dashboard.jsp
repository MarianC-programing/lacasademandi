<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.PedidoDAO, java.util.List, modelo.Pedido" %>
<%
    String rol = (String) session.getAttribute("rol");
    if (!"admin".equals(rol)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String nombreAdmin   = (String) session.getAttribute("nombre");
    PedidoDAO pedidoDAO  = new PedidoDAO();
    int pendientes       = pedidoDAO.contarPorEstado("Pendiente");
    int enProduccion     = pedidoDAO.contarPorEstado("En produccion");
    int listos           = pedidoDAO.contarPorEstado("Listo");

    List<Pedido> recientes = pedidoDAO.listarTodos(null);
    List<Pedido> ultimos   = recientes.size() > 5 ? recientes.subList(0, 5) : recientes;

    // Hora del día para el saludo
    java.util.Calendar cal = java.util.Calendar.getInstance();
    int hora = cal.get(java.util.Calendar.HOUR_OF_DAY);
    String saludo = hora < 12 ? "Buenos días" : hora < 18 ? "Buenas tardes" : "Buenas noches";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Control — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { min-height: 100vh; background: #f5f0ee; font-family: var(--cuerpo); }

        .admin-dashboard {
            display: flex;
            min-height: calc(100vh - 120px);
        }

        /* ── SIDEBAR ── */
        .sidebar {
            width: 180px;
            min-height: 100vh;
            background: #fff;
            border-right: 1px solid var(--borde);
            display: flex;
            flex-direction: column;
            padding: 28px 0;
            position: fixed;
            top: 0; left: 0;
        }
        .sidebar__logo {
            font-family: var(--titulo);
            font-style: italic;
            font-size: 18px;
            color: var(--primario);
            font-weight: 700;
            padding: 0 20px 4px;
        }
        .sidebar__sub {
            font-size: 11px;
            color: var(--texto-suave);
            padding: 0 20px 28px;
        }
        .sidebar__nav { flex: 1; }
        .sidebar__nav a {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 11px 20px;
            font-size: 14px;
            font-weight: 500;
            color: var(--texto);
            text-decoration: none;
            border-radius: 8px;
            margin: 2px 8px;
            transition: background 0.12s;
        }
        .sidebar__nav a:hover { background: var(--fondo-alt); text-decoration: none; }
        .sidebar__nav a.activo { background: var(--primario); color: #fff; }
        .sidebar__nav a .ico { font-size: 16px; width: 20px; text-align: center; }
        .sidebar__logout {
            padding: 16px 8px 0;
            border-top: 1px solid var(--borde);
            margin: 0 0;
        }
        .sidebar__logout a {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 20px;
            font-size: 13px;
            font-weight: 500;
            color: var(--texto-suave);
            text-decoration: none;
            border-radius: 8px;
            margin: 0 8px;
        }
        .sidebar__logout a:hover { background: #fef2f2; color: var(--primario); }

        /* ── MAIN ── */
        .main-content {
            margin-left: 180px;
            flex: 1;
            padding: 32px 32px 64px;
        }

        /* ── TOP BAR ── */
        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 28px;
        }
        .topbar__titulo h1 {
            font-family: var(--titulo);
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 4px;
        }
        .topbar__titulo p { color: var(--texto-suave); font-size: 14px; }
        .topbar__user {
            display: flex;
            align-items: center;
            gap: 10px;
            background: #fff;
            border: 1px solid var(--borde);
            border-radius: 12px;
            padding: 10px 16px;
        }
        .topbar__user .avatar {
            width: 36px; height: 36px;
            background: var(--primario);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            color: #fff; font-size: 16px;
        }
        .topbar__user .info strong { display: block; font-size: 14px; font-weight: 600; }
        .topbar__user .info span   { font-size: 12px; color: var(--texto-suave); }

        /* ── LAYOUT DOS COLUMNAS ── */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 300px;
            gap: 24px;
        }
        .col-izq { display: flex; flex-direction: column; gap: 24px; }
        .col-der { display: flex; flex-direction: column; gap: 24px; }

        /* ── STAT CARDS ── */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
        }
        .stat-card {
            background: #fff;
            border: 1px solid var(--borde);
            border-radius: 14px;
            padding: 20px 22px;
        }
        .stat-card__label {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--texto-suave);
            margin-bottom: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .stat-card__label .ico { font-size: 18px; }
        .stat-card__num {
            font-family: var(--titulo);
            font-size: 44px;
            font-weight: 700;
            line-height: 1;
            margin-bottom: 8px;
        }
        .stat-card__num.rojo   { color: var(--primario); }
        .stat-card__num.naranja{ color: #d97706; }
        .stat-card__num.verde  { color: #16a34a; }
        .stat-card__hint {
            font-size: 12px;
            color: var(--texto-suave);
            display: flex;
            align-items: center;
            gap: 4px;
        }

        /* ── ALERTA CONFIRMACIONES ── */
        .alerta-confirmaciones {
            background: var(--primario);
            border-radius: 14px;
            padding: 22px 28px;
            display: flex;
            align-items: center;
            gap: 20px;
            color: #fff;
        }
        .alerta-confirmaciones .alerta-ico {
            width: 44px; height: 44px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 20px;
            flex-shrink: 0;
        }
        .alerta-confirmaciones h3 { font-size: 17px; font-weight: 700; margin-bottom: 4px; }
        .alerta-confirmaciones p  { font-size: 13px; opacity: 0.85; line-height: 18px; }
        .alerta-confirmaciones .btn-alerta {
            margin-left: auto;
            padding: 10px 20px;
            background: #fff;
            color: var(--primario);
            border-radius: 8px;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            white-space: nowrap;
            flex-shrink: 0;
        }
        .alerta-confirmaciones .btn-alerta:hover { background: #f5f0ee; text-decoration: none; }

        /* ── CARD GENÉRICA ── */
        .card {
            background: #fff;
            border: 1px solid var(--borde);
            border-radius: 14px;
            padding: 22px;
        }
        .card__header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }
        .card__header h2 { font-family: var(--titulo); font-size: 18px; font-weight: 700; }
        .card__header a  { font-size: 13px; color: var(--primario); text-decoration: none; }
        .card__header a:hover { text-decoration: underline; }

        /* ── TABLA PEDIDOS ── */
        table { width: 100%; border-collapse: collapse; font-size: 13px; }
        th, td { padding: 11px 12px; text-align: left; border-bottom: 1px solid var(--borde); }
        th {
            font-size: 11px; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.06em; color: var(--texto-suave);
            background: var(--fondo-alt);
        }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #fafafa; }
        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.04em;
        }
        .badge-pendiente    { background: #fef3c7; color: #92400e; }
        .badge-enproduccion { background: #dbeafe; color: #1e40af; }
        .badge-listo        { background: #dcfce7; color: #15803d; }
        .badge-entregado    { background: #f3f4f6; color: #374151; }
        .badge-cancelado    { background: #fee2e2; color: #991b1b; }
        .badge-aceptado     { background: #ede9fe; color: #5b21b6; }
        .badge-rechazado    { background: #fee2e2; color: #991b1b; }
        .btn-xs {
            padding: 4px 12px;
            background: var(--primario);
            color: #fff;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
        }
        .btn-xs:hover { background: var(--primario-dark); text-decoration: none; }

        /* ── RESUMEN MENSUAL ── */
        .resumen-label {
            font-size: 11px; font-weight: 700; letter-spacing: 0.08em;
            text-transform: uppercase; color: var(--texto-suave); margin-bottom: 8px;
        }
        .resumen-total {
            font-family: var(--titulo);
            font-size: 30px;
            font-weight: 700;
            margin-bottom: 4px;
        }
        .resumen-crecimiento {
            font-size: 12px; color: #16a34a; margin-bottom: 16px;
        }
        .resumen-fila {
            display: flex; justify-content: space-between;
            font-size: 13px; padding: 8px 0;
            border-bottom: 1px solid var(--borde);
        }
        .resumen-fila:last-child { border-bottom: none; }
        .resumen-fila .pendiente-cobro { color: var(--primario); font-weight: 600; }
        .btn-reporte {
            display: block;
            margin-top: 16px;
            padding: 10px;
            text-align: center;
            border: 1px solid var(--borde);
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            color: var(--texto);
            text-decoration: none;
        }
        .btn-reporte:hover { background: var(--fondo-alt); text-decoration: none; }

        /* ── INSUMOS ── */
        .insumo-fila {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid var(--borde);
            font-size: 13px;
        }
        .insumo-fila:last-child { border-bottom: none; }
        .insumo-dot {
            width: 10px; height: 10px;
            border-radius: 50%;
            flex-shrink: 0;
        }
        .insumo-dot.rojo  { background: #ef4444; }
        .insumo-dot.verde { background: #22c55e; }
        .insumo-nombre strong { display: block; font-size: 13px; font-weight: 600; }
        .insumo-nombre span   { font-size: 11px; color: var(--texto-suave); }
        .gestionar-link {
            display: block; text-align: center;
            font-size: 11px; font-weight: 700;
            letter-spacing: 0.06em; text-transform: uppercase;
            color: var(--texto-suave); text-decoration: none;
            margin-top: 14px;
        }
        .gestionar-link:hover { color: var(--primario); text-decoration: none; }

        /* ── BANNER ── */
        .banner-artesanal {
            border-radius: 14px;
            overflow: hidden;
            background: var(--primario);
            min-height: 120px;
            display: flex;
            align-items: flex-end;
            padding: 20px;
            position: relative;
        }
        .banner-artesanal p {
            font-family: var(--titulo);
            font-style: italic;
            font-size: 20px;
            color: #fff;
            font-weight: 700;
            position: relative;
            z-index: 1;
        }
    </style>
</head>
<body>

<%-- ── CONTENIDO PRINCIPAL ── --%>
<div class="admin-dashboard">
    <aside class="sidebar">
        <div class="sidebar__logo">La Casa de Mandi</div>
        <div class="sidebar__sub">Panel de Control Admin</div>

        <nav class="sidebar__nav">
            <a href="${pageContext.request.contextPath}/jsp/admin/dashboard.jsp" class="activo">
                <img src="${pageContext.request.contextPath}/img/Icon/dashboard.png" class="icon-inline" alt="Dashboard">Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/jsp/admin/pedidos.jsp">
                <img src="${pageContext.request.contextPath}/img/Icon/pedido.png" class="icon-inline" alt="Pedidos">Pedidos
            </a>
            <a href="${pageContext.request.contextPath}/jsp/admin/productos.jsp">
                <img src="${pageContext.request.contextPath}/img/Icon/inventario.png" class="icon-inline" alt="Inventario">Inventario
            </a>
            <a href="#">
                <img src="${pageContext.request.contextPath}/img/Icon/cliente.png" class="icon-inline" alt="Clientes">Clientes
            </a>
            <a href="#">
                <img src="${pageContext.request.contextPath}/img/Icon/ajustes.png" class="icon-inline" alt="Configuración">Configuración
            </a>
        </nav>

        <div class="sidebar__logout">
            <a href="${pageContext.request.contextPath}/logout">
                <img src="${pageContext.request.contextPath}/img/Icon/logout.png" class="icon-inline" alt="Cerrar sesión">Cerrar sesión
            </a>
        </div>
    </aside>

    <div class="main-content">

    <%-- Top bar --%>
    <div class="topbar">
        <div class="topbar__titulo">
            <h1><%= saludo %>, Administrador</h1>
            <p>Aquí tienes el resumen de hoy en la pastelería.</p>
        </div>
        <div class="topbar__user">
            <div class="avatar"><img src="${pageContext.request.contextPath}/img/Icon/.png" alt="Usuario"></div>
            <div class="info">
                <strong><%= nombreAdmin != null ? nombreAdmin : "Admin" %></strong>
                <span>Dueña / Chef</span>
            </div>
        </div>
    </div>

    <div class="dashboard-grid">

        <%-- COLUMNA IZQUIERDA --%>
        <div class="col-izq">

            <%-- Stats --%>
            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-card__label">
                        <img src="${pageContext.request.contextPath}/img/Icon/pendiente.png" class="icon-inline" alt="Pendientes">Pendientes
                    </div>
                    <div class="stat-card__num rojo"><%= String.format("%02d", pendientes) %></div>
                    <div class="stat-card__hint">⏱ Por confirmar detalles</div>
                </div>
                <div class="stat-card">
                    <div class="stat-card__label">
                        <img src="${pageContext.request.contextPath}/img/Icon/Producion.png" class="icon-inline" alt="En Producción">En Producción
                    </div>
                    <div class="stat-card__num naranja"><%= String.format("%02d", enProduccion) %></div>
                    <div class="stat-card__hint">⏱ Salida prevista: 16:00h</div>
                </div>
                <div class="stat-card">
                    <div class="stat-card__label">
                        <img src="${pageContext.request.contextPath}/img/Icon/listo.png" class="icon-inline" alt="Listos">Listos
                    </div>
                    <div class="stat-card__num verde"><%= String.format("%02d", listos) %></div>
                    <div class="stat-card__hint"><img src="${pageContext.request.contextPath}/img/Icon/entrega.png" class="icon-inline" alt="Esperando recogida">Esperando recogida</div>
                </div>
            </div>

            <%-- Alerta confirmaciones --%>
            <% if (pendientes > 0) { %>
            <div class="alerta-confirmaciones">
                <div class="alerta-ico">!</div>
                <div>
                    <h3>Confirmaciones Pendientes</h3>
                    <p>Hay <%= pendientes %> pedido<%= pendientes != 1 ? "s" : "" %> esperando tu revisión para proceder con la producción.</p>
                </div>
                <a href="${pageContext.request.contextPath}/jsp/admin/pedidos.jsp?estado=Pendiente"
                   class="btn-alerta">Revisar Ahora</a>
            </div>
            <% } %>

            <%-- Tabla pedidos recientes --%>
            <div class="card">
                <div class="card__header">
                    <h2>Pedidos Recientes</h2>
                    <a href="${pageContext.request.contextPath}/jsp/admin/pedidos.jsp">Ver todos</a>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>Pedido</th>
                            <th>Cliente</th>
                            <th>Fecha Entrega</th>
                            <th>Estado</th>
                            <th>Monto</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (ultimos.isEmpty()) { %>
                        <tr><td colspan="5" style="text-align:center;color:var(--texto-suave);padding:24px;">No hay pedidos aún.</td></tr>
                    <% } else {
                        for (Pedido p : ultimos) {
                            String estado = p.getEstado();
                            String badgeClass = "badge-" + estado.toLowerCase()
                                .replace(" ", "").replace("ó","o").replace("ú","u").replace("é","e");
                    %>
                        <tr>
                            <td style="font-weight:600;">#ORD-<%= String.format("%04d", p.getIdPedido()) %></td>
                            <td>
                                <strong><%= p.getNombreCliente() != null ? p.getNombreCliente() : "—" %></strong><br>
                                <span style="font-size:11px;color:var(--texto-suave);"><%= p.getNombreProducto() %></span>
                            </td>
                            <td><%= p.getFechaEntrega() %></td>
                            <td><span class="badge <%= badgeClass %>"><%= estado.toUpperCase() %></span></td>
                            <td style="font-weight:600;">$<%= String.format("%.2f", p.getPrecioTotal()) %></td>
                        </tr>
                    <% } } %>
                    </tbody>
                </table>
            </div>

        </div>

        <%-- COLUMNA DERECHA --%>
        <div class="col-der">

            <%-- Resumen mensual --%>
            <div class="card">
                <div class="resumen-label"><img src="${pageContext.request.contextPath}/img/Icon/estadistica.png" class="icon-inline" alt="Resumen Mensual">Resumen Mensual</div>
                <div class="resumen-total">$0.00</div>
                <div class="resumen-crecimiento">↗ Ingresos confirmados este mes</div>
                <div class="resumen-fila">
                    <span>Abonos (50%)</span>
                    <span>$0.00</span>
                </div>
                <div class="resumen-fila">
                    <span>Pagos Finales</span>
                    <span>$0.00</span>
                </div>
                <div class="resumen-fila">
                    <span class="pendiente-cobro">Pendiente de Cobro</span>
                    <span class="pendiente-cobro">$0.00</span>
                </div>
                <a href="#" class="btn-reporte">Descargar Reporte</a>
            </div>

            <%-- Insumos --%>
            <div class="card">
                <div class="card__header">
                    <h2>Insumos</h2>
                    <img src="${pageContext.request.contextPath}/img/Icon/insumos.png" class="icon-inline" alt="Insumos">
                </div>
                <div class="insumo-fila">
                    <div class="insumo-nombre">
                        <strong>Harina de Fuerza</strong>
                        <span>Stock bajo: 2kg</span>
                    </div>
                    <div class="insumo-dot rojo"></div>
                </div>
                <div class="insumo-fila">
                    <div class="insumo-nombre">
                        <strong>Mantequilla Artesanal</strong>
                        <span>Normal: 15kg</span>
                    </div>
                    <div class="insumo-dot verde"></div>
                </div>
                <div class="insumo-fila">
                    <div class="insumo-nombre">
                        <strong>Vainas de Vainilla</strong>
                        <span>Normal: 50u</span>
                    </div>
                    <div class="insumo-dot verde"></div>
                </div>
                <a href="#" class="gestionar-link">Gestionar Stock →</a>
            </div>

            <%-- Banner --%>
            <div class="banner-artesanal">
                <p>Pasión por lo artesanal.</p>
            </div>

        </div>
    </div>
    </div>
</div>

<%@ include file="/jsp/layouts/footer.jsp" %>
</body>
</html>
