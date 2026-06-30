<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, dao.PedidoDAO, modelo.Pedido" %>
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
    if (idParam != null && !idParam.trim().isEmpty()) {
        try {
            pedidoDetalle = pedidoDAO.buscarPorId(Integer.parseInt(idParam.trim()));
        } catch (NumberFormatException ignored) {}
    }

    String filtroEstado = request.getParameter("estado"); // viene de las pestañas, ej: "Pendiente"
    String busqueda     = request.getParameter("buscar");

    List<Pedido> pedidos = pedidoDetalle == null
        ? pedidoDAO.listarTodos(filtroEstado != null && !filtroEstado.isEmpty() ? filtroEstado : null)
        : null;

    if (pedidos != null && busqueda != null && !busqueda.trim().isEmpty()) {
        String b = busqueda.trim().toLowerCase();
        pedidos.removeIf(p ->
            !String.valueOf(p.getIdPedido()).contains(b)
            && (p.getNombreCliente() == null || !p.getNombreCliente().toLowerCase().contains(b))
        );
    }

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
</head>
<body>
<div class="admin-layout">

    <% request.setAttribute("seccionActiva", "pedidos"); %>
    <%@ include file="/jsp/admin/sidebar.jsp" %>

    <div class="admin-main">
        <div class="admin-content">

            <% if ("1".equals(request.getParameter("ok"))) { %>
                <div class="admin-alerta-exito">✅ Pedido actualizado correctamente.</div>
            <% } else if ("1".equals(request.getParameter("error"))) { %>
                <div class="admin-alerta-error">No se pudo actualizar el pedido. Intenta de nuevo.</div>
            <% } %>

            <% if (pedidoDetalle != null) { %>
            <%-- ===================== VISTA DETALLE ===================== --%>
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

                    <a href="${pageContext.request.contextPath}/jsp/admin/pedidos.jsp"
                       class="btn btn-outline" style="display:block; text-align:center; margin-top:14px;">
                        ← Volver a la lista
                    </a>
                </div>
            </div>

            <% } else { %>
            <%-- ===================== VISTA LISTA ===================== --%>
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
                    <thead>
                        <tr><th>N° Pedido</th><th>Cliente</th><th>Producto</th><th>Fecha Entrega</th><th>Estado</th><th>Total</th><th>Acción</th></tr>
                    </thead>
                    <tbody>
                    <% if (pedidos.isEmpty()) { %>
                        <tr><td colspan="7" style="text-align:center;color:var(--texto-suave);padding:32px;">No hay pedidos que coincidan.</td></tr>
                    <% } else {
                        for (Pedido p : pedidos) {
                            String bc = badgeClase(p.getEstado());
                    %>
                        <tr>
                            <td>#<%= p.getIdPedido() %></td>
                            <td><%= p.getNombreCliente() %></td>
                            <td><%= p.getNombreProducto() %> / <%= p.getTamanoVariante() %></td>
                            <td><%= p.getFechaEntrega() %></td>
                            <td><span class="badge <%= bc %>"><%= p.getEstado() %></span></td>
                            <td>$<%= String.format("%.2f", p.getPrecioTotal()) %></td>
                            <td><a href="${pageContext.request.contextPath}/jsp/admin/pedidos.jsp?id=<%= p.getIdPedido() %>" class="btn-sm">Ver detalle</a></td>
                        </tr>
                    <% } } %>
                    </tbody>
                </table>
                <div class="admin-paginacion">
                    <span>Mostrando <%= pedidos.size() %> de <%= pedidos.size() %> pedidos</span>
                </div>
            </div>

            <% } %>

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
