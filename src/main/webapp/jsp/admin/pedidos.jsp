<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, dao.PedidoDAO, dao.PagoDAO, modelo.Pedido, modelo.Abono, modelo.PagoFinal" %>
<%-- Admin - Gestión de Pedidos --%>
<%
    String rol = (String) session.getAttribute("rol");
    if (!"admin".equals(rol)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    PedidoDAO pedidoDAO = new PedidoDAO();

    // ¿Vista de detalle de un pedido específico?
    String idParam = request.getParameter("id");
    Pedido pedidoDetalle = null;
    Abono     abonoDetalle     = null;
    PagoFinal pagoFinalDetalle = null;
    if (idParam != null && !idParam.trim().isEmpty()) {
        try {
            pedidoDetalle     = pedidoDAO.buscarPorId(Integer.parseInt(idParam.trim()));
            PagoDAO pagoDAO   = new PagoDAO();
            abonoDetalle      = pagoDAO.buscarAbonoPorPedido(Integer.parseInt(idParam.trim()));
            pagoFinalDetalle  = pagoDAO.buscarPagoFinalPorPedido(Integer.parseInt(idParam.trim()));
        } catch (NumberFormatException ignored) {}
    }

    String filtroEstado = request.getParameter("estado"); // viene de las pestañas, ej: "Pendiente"
    String busqueda     = request.getParameter("buscar");

    List<Pedido> pedidos = pedidoDetalle == null
        ? pedidoDAO.listarTodos(filtroEstado != null && !filtroEstado.isEmpty() ? filtroEstado : null)
        : null;

    List<String[]> historial = pedidoDetalle != null
        ? pedidoDAO.listarHistorial(pedidoDetalle.getIdPedido())
        : null;

    if (pedidos != null && busqueda != null && !busqueda.trim().isEmpty()) {
        String b = busqueda.trim().toLowerCase();
        pedidos.removeIf(p ->
            !String.valueOf(p.getIdPedido()).contains(b)
            && (p.getNombreCliente() == null || !p.getNombreCliente().toLowerCase().contains(b))
        );
    }

    // Paginacion (vista lista)
    final int TAM_PAGINA = 10;
    int totalPedidos = pedidos != null ? pedidos.size() : 0;
    int totalPaginas = Math.max(1, (int) Math.ceil(totalPedidos / (double) TAM_PAGINA));
    int paginaActual = 1;
    if (request.getParameter("pagina") != null) {
        try { paginaActual = Integer.parseInt(request.getParameter("pagina")); } catch (NumberFormatException ignored) {}
    }
    if (paginaActual < 1) paginaActual = 1;
    if (paginaActual > totalPaginas) paginaActual = totalPaginas;

    List<Pedido> pedidosPagina = pedidos;
    if (pedidos != null && !pedidos.isEmpty()) {
        int desde = (paginaActual - 1) * TAM_PAGINA;
        int hasta = Math.min(desde + TAM_PAGINA, totalPedidos);
        pedidosPagina = pedidos.subList(desde, hasta);
    }

    String qsBase = "estado=" + java.net.URLEncoder.encode(filtroEstado != null ? filtroEstado : "", "UTF-8")
        + (busqueda != null && !busqueda.isEmpty() ? "&buscar=" + java.net.URLEncoder.encode(busqueda, "UTF-8") : "");

    // Pestañas del wireframe -> valores reales del ENUM en BD
    String[][] pestanas = {
        {"", "Todos"},
        {"Pendiente", "Pendiente"},
        {"En produccion", "En Producción"},
        {"Listo", "Listo"},
        {"Entregado", "Entregado"},
        {"Cancelado", "Cancelado"}
    };

    String[] estadosDisponibles = {"Pendiente","Aceptado","Rechazado","En produccion","Listo","Entregado","Cancelado"};
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Pedidos — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <style>
        .admin-table-wrap table { table-layout: fixed; }
        .admin-table-wrap col.col-num      { width: 8%; }
        .admin-table-wrap col.col-cliente  { width: 16%; }
        .admin-table-wrap col.col-producto { width: 28%; }
        .admin-table-wrap col.col-fecha    { width: 14%; }
        .admin-table-wrap col.col-estado   { width: 14%; }
        .admin-table-wrap col.col-total    { width: 10%; }
        .admin-table-wrap col.col-accion   { width: 10%; }
        .admin-table-wrap td { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .admin-table-wrap td.col-producto-celda { white-space: normal; }
    </style>
</head>
<body>
<div class="admin-layout">

    <% request.setAttribute("seccionActiva", "pedidos"); %>
    <%@ include file="/jsp/admin/sidebar.jsp" %>

    <div class="admin-main">
        <div class="admin-content">

            <% if ("1".equals(request.getParameter("ok"))) { %>
                <div class="admin-alerta-exito"> Pedido actualizado correctamente.</div>
            <% } else if ("1".equals(request.getParameter("error"))) { %>
                <div class="admin-alerta-error">No se pudo actualizar el pedido. Intenta de nuevo.</div>
            <% } %>

            <% if (pedidoDetalle != null) { %>
            <%-- VISTA DETALLE --%>
            <div class="admin-content-header">
                <div>
                    <h1>Pedido #<%= pedidoDetalle.getIdPedido() %></h1>
                    <p>Detalle completo y acciones de gestión.</p>
                </div>
            </div>

            <div class="admin-detalle-grid">
                <div class="admin-info-card">
                    <h2>Información del pedido</h2>
                    <div class="admin-info-fila"><strong>Cliente</strong><span><%= pedidoDetalle.getNombreCliente() %></span></div>
                    <div class="admin-info-fila"><strong>Producto</strong><span><%= pedidoDetalle.getNombreProducto() %></span></div>
                    <div class="admin-info-fila"><strong>Variante</strong><span><%= pedidoDetalle.getTamanoVariante() %></span></div>
                    <div class="admin-info-fila"><strong>Fecha del pedido</strong><span><%= pedidoDetalle.getFechaPedido() %></span></div>
                    <div class="admin-info-fila"><strong>Fecha de entrega</strong><span><%= pedidoDetalle.getFechaEntrega() %></span></div>
                    <div class="admin-info-fila">
                        <strong>Descripción del diseño</strong>
                        <span><%= pedidoDetalle.getDescripcionDiseno() != null && !pedidoDetalle.getDescripcionDiseno().isEmpty()
                                  ? pedidoDetalle.getDescripcionDiseno() : "Sin descripción" %></span>
                    </div>
                    <div class="admin-info-fila">
                        <strong>Estado actual</strong>
                        <span>
                            <% String bcDet = badgeClase(pedidoDetalle.getEstado()); %>
                            <span class="badge <%= bcDet %>"><%= pedidoDetalle.getEstado() %></span>
                        </span>
                    </div>
                    <div class="admin-info-fila">
                        <strong>Precio total</strong>
                        <span>
                            $<%= String.format("%.2f", pedidoDetalle.getPrecioTotal()) %>
                            <%= pedidoDetalle.isPrecioConfirmado() ? "(confirmado)" : "(estimado, sin confirmar)" %>
                        </span>
                    </div>
                </div>

                <div>
                    <div class="admin-acciones-card">
                        <h3>Cambiar estado</h3>
                        <form action="${pageContext.request.contextPath}/pedido" method="POST">
                            <input type="hidden" name="accion" value="estado">
                            <input type="hidden" name="id_pedido" value="<%= pedidoDetalle.getIdPedido() %>">
                            <label for="estado">Nuevo estado</label>
                            <select id="estado" name="estado">
                                <% for (String e : estadosDisponibles) { %>
                                    <option value="<%= e %>" <%= e.equals(pedidoDetalle.getEstado()) ? "selected" : "" %>><%= e %></option>
                                <% } %>
                            </select>
                            <button type="submit">Actualizar estado</button>
                        </form>

                        <h3 style="margin-top:24px;">Confirmar precio</h3>
                        <form action="${pageContext.request.contextPath}/pedido" method="POST">
                            <input type="hidden" name="accion" value="precio">
                            <input type="hidden" name="id_pedido" value="<%= pedidoDetalle.getIdPedido() %>">
                            <label for="precio_total">Precio total ($)</label>
                            <input type="number" id="precio_total" name="precio_total" step="0.01" min="0"
                                   value="<%= pedidoDetalle.getPrecioTotal() %>" required>
                            <button type="submit">Confirmar precio</button>
                        </form>
                    </div>

                    <%-- PANEL DE PAGOS DEL ADMIN --%>
                    <div class="admin-acciones-card" style="margin-top:20px;">
                        <h3>Abono (50%)</h3>
                        <% if (abonoDetalle == null) { %>
                            <p style="font-size:13px;color:var(--texto-suave);">El cliente no ha registrado abono.</p>
                        <% } else if (abonoDetalle.isConfirmado()) { %>
                            <p style="font-size:13px;color:#16a34a;font-weight:600;">✓ Confirmado — $<%= String.format("%.2f", abonoDetalle.getMonto()) %></p>
                            <p style="font-size:12px;color:var(--texto-suave);">Vía <%= abonoDetalle.getMetodoPago() %> · Ref: <%= abonoDetalle.getReferencia() != null ? abonoDetalle.getReferencia() : "—" %></p>
                        <% } else { %>
                            <p style="font-size:13px;font-weight:600;">$<%= String.format("%.2f", abonoDetalle.getMonto()) %> — <%= abonoDetalle.getMetodoPago() %></p>
                            <p style="font-size:12px;color:var(--texto-suave);margin-bottom:12px;">Ref: <%= abonoDetalle.getReferencia() != null ? abonoDetalle.getReferencia() : "—" %> · <%= abonoDetalle.getFechaPago() %></p>
                            <form action="${pageContext.request.contextPath}/pago" method="POST" style="display:inline;">
                                <input type="hidden" name="accion"    value="conf_abono">
                                <input type="hidden" name="id_pedido" value="<%= pedidoDetalle.getIdPedido() %>">
                                <button type="submit">✓ Confirmar abono</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/pago" method="POST" style="display:inline;margin-top:8px;">
                                <input type="hidden" name="accion"    value="rech_abono">
                                <input type="hidden" name="id_pedido" value="<%= pedidoDetalle.getIdPedido() %>">
                                <button type="submit" style="background:var(--fondo-alt);color:var(--texto);">✗ Rechazar</button>
                            </form>
                        <% } %>

                        <h3 style="margin-top:20px;">Pago Final (50%)</h3>
                        <% if (pagoFinalDetalle == null) { %>
                            <p style="font-size:13px;color:var(--texto-suave);">El cliente no ha registrado el pago final.</p>
                        <% } else if (pagoFinalDetalle.isConfirmado()) { %>
                            <p style="font-size:13px;color:#16a34a;font-weight:600;">✓ Confirmado — $<%= String.format("%.2f", pagoFinalDetalle.getMonto()) %></p>
                            <p style="font-size:12px;color:var(--texto-suave);">Vía <%= pagoFinalDetalle.getMetodoPago() %> · Ref: <%= pagoFinalDetalle.getReferencia() != null ? pagoFinalDetalle.getReferencia() : "—" %></p>
                        <% } else { %>
                            <p style="font-size:13px;font-weight:600;">$<%= String.format("%.2f", pagoFinalDetalle.getMonto()) %> — <%= pagoFinalDetalle.getMetodoPago() %></p>
                            <p style="font-size:12px;color:var(--texto-suave);margin-bottom:12px;">Ref: <%= pagoFinalDetalle.getReferencia() != null ? pagoFinalDetalle.getReferencia() : "—" %> · <%= pagoFinalDetalle.getFechaPago() %></p>
                            <form action="${pageContext.request.contextPath}/pago" method="POST" style="display:inline;">
                                <input type="hidden" name="accion"    value="conf_final">
                                <input type="hidden" name="id_pedido" value="<%= pedidoDetalle.getIdPedido() %>">
                                <button type="submit">✓ Confirmar pago final</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/pago" method="POST" style="display:inline;margin-top:8px;">
                                <input type="hidden" name="accion"    value="rech_final">
                                <input type="hidden" name="id_pedido" value="<%= pedidoDetalle.getIdPedido() %>">
                                <button type="submit" style="background:var(--fondo-alt);color:var(--texto);">✗ Rechazar</button>
                            </form>
                        <% } %>
                    </div>

                    <div class="admin-info-card" style="margin-top:20px;">
                        <h2>Historial de cambios</h2>
                        <% if (historial.isEmpty()) { %>
                            <p style="font-size:13px;color:var(--texto-suave);">Sin cambios de estado registrados todavía.</p>
                        <% } else {
                            for (String[] h : historial) {
                                String anterior = h[0] != null ? h[0] : "Creado";
                                String nuevo    = h[1];
                                String fecha    = h[2];
                        %>
                        <div class="admin-info-fila">
                            <strong><%= fecha %></strong>
                            <span><%= anterior %> → <%= nuevo %></span>
                        </div>
                        <% } } %>
                    </div>

                    <a href="${pageContext.request.contextPath}/jsp/admin/pedidos.jsp"
                       class="btn btn-outline" style="display:block; text-align:center; margin-top:14px;">
                        ← Volver a la lista
                    </a>
                </div>
            </div>

            <% } else { %>
            <%-- VISTA LIST --%>
            <div class="admin-content-header">
                <div>
                    <h1>Gestión de Pedidos</h1>
                    <p>Administra las órdenes entrantes y el flujo de producción de la pastelería.</p>
                </div>
            </div>

            <div class="admin-filtros">
                <% for (String[] p : pestanas) {
                    boolean activa = (filtroEstado == null || filtroEstado.isEmpty()) ? p[0].isEmpty() : p[0].equals(filtroEstado);
                    String hrefBusqueda = (busqueda != null && !busqueda.isEmpty())
                        ? "&buscar=" + java.net.URLEncoder.encode(busqueda, "UTF-8") : "";
                %>
                <a class="tab-pill <%= activa ? "activo" : "" %>"
                   href="${pageContext.request.contextPath}/jsp/admin/pedidos.jsp?estado=<%= java.net.URLEncoder.encode(p[0], "UTF-8") %><%= hrefBusqueda %>">
                    <%= p[1] %>
                </a>
                <% } %>

                <form class="admin-buscar" method="GET" action="${pageContext.request.contextPath}/jsp/admin/pedidos.jsp">
                    <input type="hidden" name="estado" value="<%= filtroEstado != null ? filtroEstado : "" %>">
                    <input type="text" name="buscar" placeholder="Buscar pedido o cliente..."
                           value="<%= busqueda != null ? busqueda : "" %>">
                </form>
            </div>

            <div class="admin-table-wrap">
                <table>
                    <colgroup>
                        <col class="col-num">
                        <col class="col-cliente">
                        <col class="col-producto">
                        <col class="col-fecha">
                        <col class="col-estado">
                        <col class="col-total">
                        <col class="col-accion">
                    </colgroup>
                    <thead>
                        <tr><th>N° Pedido</th><th>Cliente</th><th>Producto</th><th>Fecha Entrega</th><th>Estado</th><th>Total</th><th>Acción</th></tr>
                    </thead>
                    <tbody>
                    <% if (pedidosPagina.isEmpty()) { %>
                        <tr><td colspan="7" style="text-align:center;color:var(--texto-suave);padding:32px;">No hay pedidos que coincidan.</td></tr>
                    <% } else {
                        for (Pedido p : pedidosPagina) {
                            String bc = badgeClase(p.getEstado());
                    %>
                        <tr>
                            <td>#<%= p.getIdPedido() %></td>
                            <td><%= p.getNombreCliente() %></td>
                            <td class="col-producto-celda"><%= p.getNombreProducto() %> / <%= p.getTamanoVariante() %></td>
                            <td><%= p.getFechaEntrega() %></td>
                            <td><span class="badge <%= bc %>"><%= p.getEstado() %></span></td>
                            <td>$<%= String.format("%.2f", p.getPrecioTotal()) %></td>
                            <td><a href="${pageContext.request.contextPath}/jsp/admin/pedidos.jsp?id=<%= p.getIdPedido() %>" class="btn-sm">Ver detalle</a></td>
                        </tr>
                    <% } } %>
                    </tbody>
                </table>
                <div class="admin-paginacion">
                    <span>
                        <% if (totalPedidos == 0) { %>
                            Mostrando 0 pedidos
                        <% } else { %>
                            Mostrando <%= (paginaActual - 1) * TAM_PAGINA + 1 %>–<%= Math.min(paginaActual * TAM_PAGINA, totalPedidos) %> de <%= totalPedidos %> pedidos
                        <% } %>
                    </span>
                    <% if (totalPaginas > 1) { %>
                    <div style="display:flex; gap:6px; align-items:center;">
                        <a class="btn-sm <%= paginaActual <= 1 ? "disabled" : "" %>"
                           href="${pageContext.request.contextPath}/jsp/admin/pedidos.jsp?<%= qsBase %>&pagina=<%= Math.max(1, paginaActual - 1) %>">← Anterior</a>
                        <span style="font-size:12px;color:var(--texto-suave);">Página <%= paginaActual %> de <%= totalPaginas %></span>
                        <a class="btn-sm <%= paginaActual >= totalPaginas ? "disabled" : "" %>"
                           href="${pageContext.request.contextPath}/jsp/admin/pedidos.jsp?<%= qsBase %>&pagina=<%= Math.min(totalPaginas, paginaActual + 1) %>">Siguiente →</a>
                    </div>
                    <% } %>
                </div>
            </div>

            <% } %>

        </div>

        <%@ include file="/jsp/admin/footer-admin.jsp" %>
    </div>

</div>

<%!
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
