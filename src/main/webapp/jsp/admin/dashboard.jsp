<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.PedidoDAO, dao.ProductoDAO, java.util.List, modelo.Pedido, modelo.Producto" %>
<%
    String rol = (String) session.getAttribute("rol");
    if (!"admin".equals(rol)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String nombreAdminTopbar = (String) session.getAttribute("nombre");
    PedidoDAO pedidoDAO  = new PedidoDAO();
    int pendientes       = pedidoDAO.contarPorEstado("Pendiente");
    int enProduccion     = pedidoDAO.contarPorEstado("En produccion");
    int listos           = pedidoDAO.contarPorEstado("Listo");

    List<Pedido> recientes = pedidoDAO.listarTodos(null);
    List<Pedido> ultimos   = recientes.size() > 5 ? recientes.subList(0, 5) : recientes;

    // Resumen de inventario (a partir de la disponibilidad real de productos/variantes)
    ProductoDAO productoDAO   = new ProductoDAO();
    int[] inventario          = productoDAO.contarDisponibilidad(); // [activos, inactivos, variantesInactivas]
    List<Producto> sinStock   = productoDAO.listarNoDisponibles();
    List<Producto> sinStockTop = sinStock.size() > 3 ? sinStock.subList(0, 3) : sinStock;

    // Saludo según hora del día
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <style>
        /* ---- Específico del Dashboard ---- */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 300px;
            gap: 24px;
        }
        .col-izq, .col-der { display: flex; flex-direction: column; gap: 24px; }

        .topbar__user {
            display: flex;
            align-items: center;
            gap: 10px;
            background: #fff;
            border: 1px solid var(--borde);
            border-radius: 12px;
            padding: 10px 16px;
            flex-shrink: 0;
        }
        .topbar__user .avatar {
            width: 36px; height: 36px;
            background: var(--primario);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            color: #fff; font-size: 15px; font-weight: 700;
        }
        .topbar__user .info strong { display: block; font-size: 14px; font-weight: 600; }
        .topbar__user .info span   { font-size: 12px; color: var(--texto-suave); }

        .stat-hint {
            font-size: 12px;
            color: var(--texto-suave);
            margin-top: 6px;
        }

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
            flex-shrink: 0;
        }
        .alerta-confirmaciones .alerta-ico img {
            width: 22px; height: 22px;
            filter: brightness(0) invert(1);
        }
        .stat-card__ico { width: 20px; height: 20px; vertical-align: middle; }
        .stat-hint img { width: 13px; height: 13px; vertical-align: middle; margin-right: 4px; }
        .card__header h2 img { width: 18px; height: 18px; vertical-align: middle; margin-right: 8px; }
        .resumen-label img { width: 14px; height: 14px; vertical-align: middle; margin-right: 6px; }
        .gestionar-link img { width: 12px; height: 12px; vertical-align: middle; margin-left: 4px; }
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
        .alerta-confirmaciones .btn-alerta:hover { background: var(--fondo-alt); text-decoration: none; }

        .card {
            background: #fff;
            border: 1px solid var(--borde);
            border-radius: 14px;
            padding: 22px;
        }

        /* Tabla de Pedidos Recientes */
        .tabla-pedidos { width: 100%; border-collapse: collapse; font-size: 13px; table-layout: fixed; }
        .tabla-pedidos col.col-pedido  { width: 14%; }
        .tabla-pedidos col.col-cliente { width: 32%; }
        .tabla-pedidos col.col-fecha   { width: 18%; }
        .tabla-pedidos col.col-estado  { width: 18%; }
        .tabla-pedidos col.col-monto   { width: 18%; }
        .tabla-pedidos th, .tabla-pedidos td {
            padding: 12px; text-align: left; border-bottom: 1px solid var(--borde);
            vertical-align: middle;
        }
        .tabla-pedidos th {
            font-size: 11px; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.06em; color: var(--texto-suave);
            background: var(--fondo-alt);
        }
        .tabla-pedidos tr:last-child td { border-bottom: none; }
        .tabla-pedidos tr:hover td { background: #fafafa; }
        .tabla-pedidos td.col-pedido { font-weight: 600; white-space: nowrap; }
        .tabla-pedidos td.col-monto  { font-weight: 600; white-space: nowrap; }
        .tabla-pedidos .cliente-nombre { display: block; font-weight: 600; }
        .tabla-pedidos .cliente-producto {
            display: block; font-size: 11px; color: var(--texto-suave);
            overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
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

        .resumen-label {
            font-size: 11px; font-weight: 700; letter-spacing: 0.08em;
            text-transform: uppercase; color: var(--texto-suave); margin-bottom: 8px;
        }
        .resumen-total { font-family: var(--titulo); font-size: 30px; font-weight: 700; margin-bottom: 4px; }
        .resumen-crecimiento { font-size: 12px; color: #16a34a; margin-bottom: 16px; }
        .resumen-fila {
            display: flex; justify-content: space-between;
            font-size: 13px; padding: 8px 0;
            border-bottom: 1px solid var(--borde);
        }
        .resumen-fila:last-child { border-bottom: none; }
        .resumen-fila .pendiente-cobro { color: var(--primario); font-weight: 600; }

        .insumo-fila {
            display: flex; align-items: center; justify-content: space-between;
            padding: 10px 0; border-bottom: 1px solid var(--borde); font-size: 13px;
        }
        .insumo-fila:last-child { border-bottom: none; }
        .insumo-dot { width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0; }
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

        .banner-artesanal {
            border-radius: 14px;
            overflow: hidden;
            background: var(--primario);
            min-height: 120px;
            display: flex;
            align-items: flex-end;
            padding: 20px;
        }
        .banner-artesanal p {
            font-family: var(--titulo);
            font-style: italic;
            font-size: 20px;
            color: #fff;
            font-weight: 700;
        }

        @media (max-width: 1100px) {
            .dashboard-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="admin-layout">

    <% request.setAttribute("seccionActiva", "dashboard"); %>
    <%@ include file="/jsp/admin/sidebar.jsp" %>

    <div class="admin-main">
        <div class="admin-content">

            <div class="admin-content-header">
                <div>
                    <h1><%= saludo %>, Administrador</h1>
                    <p>Aquí tienes el resumen de hoy en la pastelería.</p>
                </div>
                <div class="topbar__user">
                    <div class="avatar"><%= (nombreAdminTopbar != null && !nombreAdminTopbar.isEmpty()) ? nombreAdminTopbar.substring(0,1).toUpperCase() : "A" %></div>
                    <div class="info">
                        <strong><%= nombreAdminTopbar != null ? nombreAdminTopbar : "Admin" %></strong>
                        <span>Dueña / Chef</span>
                    </div>
                </div>
            </div>

            <div class="dashboard-grid">

                <%-- COLUMNA IZQUIERDA --%>
                <div class="col-izq">

                    <div class="admin-stats-grid" style="grid-template-columns:repeat(3,1fr); margin-bottom:0;">
                        <div class="admin-stat-card">
                            <h3>Pendientes <img class="stat-card__ico" src="${pageContext.request.contextPath}/img/Icon/pendiente.png" alt=""></h3>
                            <div class="num"><%= String.format("%02d", pendientes) %></div>
                            <div class="stat-hint"><img src="${pageContext.request.contextPath}/img/Icon/PorConirmar.png" alt=""> Por confirmar detalles</div>
                        </div>
                        <div class="admin-stat-card naranja">
                            <h3>En Producción <img class="stat-card__ico" src="${pageContext.request.contextPath}/img/Icon/Producion.png" alt=""></h3>
                            <div class="num"><%= String.format("%02d", enProduccion) %></div>
                            <div class="stat-hint"><img src="${pageContext.request.contextPath}/img/Icon/SalidaPrevia.png" alt=""> Salida prevista: 16:00h</div>
                        </div>
                        <div class="admin-stat-card verde">
                            <h3>Listos <img class="stat-card__ico" src="${pageContext.request.contextPath}/img/Icon/listo.png" alt=""></h3>
                            <div class="num"><%= String.format("%02d", listos) %></div>
                            <div class="stat-hint"><img src="${pageContext.request.contextPath}/img/Icon/entrega.png" alt=""> Esperando recogida</div>
                        </div>
                    </div>

                    <% if (pendientes > 0) { %>
                    <div class="alerta-confirmaciones">
                        <div class="alerta-ico"><img src="${pageContext.request.contextPath}/img/Icon/PorConirmar.png" alt=""></div>
                        <div>
                            <h3>Confirmaciones Pendientes</h3>
                            <p>Hay <%= pendientes %> pedido<%= pendientes != 1 ? "s" : "" %> esperando tu revisión para proceder con la producción.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/jsp/admin/pedidos.jsp?estado=Pendiente"
                           class="btn-alerta">Revisar Ahora</a>
                    </div>
                    <% } %>

                    <div class="card">
                        <div class="card__header">
                            <h2><img src="${pageContext.request.contextPath}/img/Icon/pedido.png" alt="">Pedidos Recientes</h2>
                            <a href="${pageContext.request.contextPath}/jsp/admin/pedidos.jsp">Ver todos</a>
                        </div>
                        <table class="tabla-pedidos">
                            <colgroup>
                                <col class="col-pedido">
                                <col class="col-cliente">
                                <col class="col-fecha">
                                <col class="col-estado">
                                <col class="col-monto">
                            </colgroup>
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
                                    String badgeClass = badgeClase(estado);
                            %>
                                <tr>
                                    <td class="col-pedido">#ORD-<%= String.format("%04d", p.getIdPedido()) %></td>
                                    <td>
                                        <span class="cliente-nombre"><%= p.getNombreCliente() != null ? p.getNombreCliente() : "—" %></span>
                                        <span class="cliente-producto"><%= p.getNombreProducto() %></span>
                                    </td>
                                    <td><%= p.getFechaEntrega() %></td>
                                    <td><span class="badge <%= badgeClass %>"><%= estado.toUpperCase() %></span></td>
                                    <td class="col-monto">$<%= String.format("%.2f", p.getPrecioTotal()) %></td>
                                </tr>
                            <% } } %>
                            </tbody>
                        </table>
                    </div>

                </div>

                <%-- COLUMNA DERECHA --%>
                <div class="col-der">

                    <div class="card">
                        <div class="resumen-label"><img src="${pageContext.request.contextPath}/img/Icon/estadistica.png" alt=""> Resumen Mensual</div>
                        <div class="resumen-total">$0.00</div>
                        <div class="resumen-crecimiento">Ingresos confirmados este mes</div>
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
                    </div>

                    <div class="card">
                        <div class="card__header">
                            <h2><img src="${pageContext.request.contextPath}/img/Icon/insumos.png" alt="">Inventario</h2>
                        </div>
                        <div class="insumo-fila">
                            <div class="insumo-nombre">
                                <strong>Productos activos</strong>
                                <span><%= inventario[0] %> disponibles en el catálogo</span>
                            </div>
                            <div class="insumo-dot verde"></div>
                        </div>
                        <% if (sinStockTop.isEmpty()) { %>
                        <div class="insumo-fila">
                            <div class="insumo-nombre">
                                <strong>Sin stock / no disponibles</strong>
                                <span>Ningún producto pausado</span>
                            </div>
                            <div class="insumo-dot verde"></div>
                        </div>
                        <% } else {
                            for (Producto p : sinStockTop) {
                        %>
                        <div class="insumo-fila">
                            <div class="insumo-nombre">
                                <strong><%= p.getNombre() %></strong>
                                <span>No disponible</span>
                            </div>
                            <div class="insumo-dot rojo"></div>
                        </div>
                        <% } } %>
                        <% if (inventario[2] > 0) { %>
                        <div class="insumo-fila">
                            <div class="insumo-nombre">
                                <strong>Variantes pausadas</strong>
                                <span><%= inventario[2] %> variante<%= inventario[2] != 1 ? "s" : "" %> sin disponibilidad</span>
                            </div>
                            <div class="insumo-dot rojo"></div>
                        </div>
                        <% } %>
                        <a href="${pageContext.request.contextPath}/jsp/admin/productos.jsp" class="gestionar-link">Gestionar Inventario <img src="${pageContext.request.contextPath}/img/Icon/inventario.png" alt=""></a>
                    </div>

                    <div class="banner-artesanal">
                        <p>Pasión por lo artesanal.</p>
                    </div>

                </div>
            </div>

        </div>

        <%@ include file="/jsp/admin/footer-admin.jsp" %>
    </div>

</div>

<%!
    /** Traduce el estado de BD a la clase CSS de badge correspondiente (definida en estilos.css). */
    public String badgeClase(String estado) {
        if (estado == null) return "badge-pendiente";
        switch (estado) {
            case "Pendiente":      return "badge-pendiente";
            case "Aceptado":       return "badge-aceptado";
            case "En produccion":  return "badge-produccion";
            case "Listo":          return "badge-listo";
            case "Entregado":      return "badge-entregado";
            case "Cancelado":
            case "Rechazado":      return "badge-cancelado";
            default:                return "badge-pendiente";
        }
    }
%>
</body>
</html>
