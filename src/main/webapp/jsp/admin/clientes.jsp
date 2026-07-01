<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, dao.ClienteDAO, dao.PedidoDAO, modelo.Cliente" %>
<%
    String rol = (String) session.getAttribute("rol");
    if (!"admin".equals(rol)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }

    ClienteDAO clienteDAO = new ClienteDAO();
    List<Cliente> clientes = clienteDAO.listarTodos();

    String busqueda = request.getParameter("buscar");
    if (busqueda != null && !busqueda.trim().isEmpty()) {
        String b = busqueda.trim().toLowerCase();
        clientes.removeIf(c ->
            !c.getNombre().toLowerCase().contains(b) &&
            !c.getCorreo().toLowerCase().contains(b) &&
            !c.getWhatsapp().toLowerCase().contains(b)
        );
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clientes — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <style>
        .admin-table-wrap table { table-layout: fixed; }
        .admin-table-wrap col.col-id      { width: 6%; }
        .admin-table-wrap col.col-nombre  { width: 24%; }
        .admin-table-wrap col.col-correo  { width: 28%; }
        .admin-table-wrap col.col-wp      { width: 16%; }
        .admin-table-wrap col.col-tel     { width: 14%; }
        .admin-table-wrap col.col-pedidos { width: 12%; }
        .admin-table-wrap td {
            overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
            vertical-align: middle;
        }
        .num-pedidos {
            display: inline-flex; align-items: center; justify-content: center;
            width: 28px; height: 28px; border-radius: 50%;
            background: var(--fondo-alt); border: 1px solid var(--borde);
            font-size: 13px; font-weight: 700; color: var(--primario);
        }
        .num-pedidos.cero { color: var(--texto-suave); background: transparent; }
        .cliente-avatar {
            display: inline-flex; align-items: center; justify-content: center;
            width: 32px; height: 32px; border-radius: 50%;
            background: var(--primario); color: #fff;
            font-size: 13px; font-weight: 700; flex-shrink: 0;
            margin-right: 10px; vertical-align: middle;
        }
        .nombre-celda { display: flex; align-items: center; }
    </style>
</head>
<body>
<div class="admin-layout">

    <% request.setAttribute("seccionActiva", "clientes"); %>
    <%@ include file="/jsp/admin/sidebar.jsp" %>

    <div class="admin-main">
        <div class="admin-content">

            <div class="admin-content-header">
                <div>
                    <h1>Clientes</h1>
                    <p>Listado de todos los clientes registrados en la plataforma.</p>
                </div>
                <div class="admin-stats-grid" style="grid-template-columns:repeat(2,1fr);margin-bottom:0;gap:12px;">
                    <div class="admin-stat-card" style="padding:16px 20px;">
                        <h3>Total clientes</h3>
                        <div class="num" style="font-size:28px;"><%= clientes.size() %></div>
                    </div>
                </div>
            </div>

            <div class="admin-filtros">
                <form method="GET" action="${pageContext.request.contextPath}/jsp/admin/clientes.jsp"
                      class="admin-buscar" style="margin-left:0;">
                    <input type="text" name="buscar"
                           placeholder="Buscar por nombre, correo o WhatsApp..."
                           value="<%= busqueda != null ? busqueda : "" %>"
                           style="width:340px;">
                </form>
                <% if (busqueda != null && !busqueda.isEmpty()) { %>
                <a href="${pageContext.request.contextPath}/jsp/admin/clientes.jsp"
                   class="tab-pill">Limpiar búsqueda</a>
                <% } %>
            </div>

            <div class="admin-table-wrap">
                <table>
                    <colgroup>
                        <col class="col-id">
                        <col class="col-nombre">
                        <col class="col-correo">
                        <col class="col-wp">
                        <col class="col-tel">
                        <col class="col-pedidos">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Correo</th>
                            <th>WhatsApp</th>
                            <th>Teléfono</th>
                            <th>Pedidos</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (clientes.isEmpty()) { %>
                        <tr>
                            <td colspan="6" style="text-align:center;color:var(--texto-suave);padding:40px;">
                                <%= busqueda != null && !busqueda.isEmpty()
                                    ? "No se encontraron clientes con \"" + busqueda + "\""
                                    : "No hay clientes registrados aún." %>
                            </td>
                        </tr>
                    <% } else {
                        ClienteDAO dao = new ClienteDAO();
                        for (Cliente c : clientes) {
                            int numPedidos = dao.contarPedidos(c.getIdCliente());
                            String inicial = c.getNombre().substring(0,1).toUpperCase();
                    %>
                        <tr>
                            <td style="color:var(--texto-suave);font-size:13px;">#<%= c.getIdCliente() %></td>
                            <td>
                                <div class="nombre-celda">
                                    <span class="cliente-avatar"><%= inicial %></span>
                                    <span style="overflow:hidden;text-overflow:ellipsis;"><%= c.getNombre() %></span>
                                </div>
                            </td>
                            <td title="<%= c.getCorreo() %>"><%= c.getCorreo() %></td>
                            <td><%= c.getWhatsapp() %></td>
                            <td><%= c.getTelefono() != null ? c.getTelefono() : "—" %></td>
                            <td>
                                <span class="num-pedidos <%= numPedidos == 0 ? "cero" : "" %>">
                                    <%= numPedidos %>
                                </span>
                            </td>
                        </tr>
                    <% } } %>
                    </tbody>
                </table>
                <div class="admin-paginacion">
                    <span>Mostrando <%= clientes.size() %> cliente<%= clientes.size() != 1 ? "s" : "" %></span>
                </div>
            </div>

        </div>
        <%@ include file="/jsp/admin/footer-admin.jsp" %>
    </div>
</div>
</body>
</html>
