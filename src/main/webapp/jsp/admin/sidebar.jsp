<%-- Sidebar del panel admin.
     Antes del include: request.setAttribute("seccionActiva", "dashboard|pedidos|inventario|clientes|configuracion");
--%>
<%
    String seccionActiva = request.getAttribute("seccionActiva") != null
        ? (String) request.getAttribute("seccionActiva") : "";
    String nombreAdmin = session.getAttribute("nombre") != null
        ? (String) session.getAttribute("nombre") : "Admin";
%>
<aside class="admin-sidebar">
    <div class="admin-sidebar__logo">La Casa de Mandi</div>
    <div class="admin-sidebar__sub">Admin Dashboard</div>

    <ul class="admin-sidebar__nav">
        <li><a href="${pageContext.request.contextPath}/jsp/admin/dashboard.jsp"
               class="<%= "dashboard".equals(seccionActiva) ? "activo" : "" %>">
            <img class="icono" src="${pageContext.request.contextPath}/img/Icon/dashboard.png" alt=""> Dashboard
        </a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/admin/pedidos.jsp"
               class="<%= "pedidos".equals(seccionActiva) ? "activo" : "" %>">
            <img class="icono" src="${pageContext.request.contextPath}/img/Icon/pedido.png" alt=""> Pedidos
        </a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/admin/productos.jsp"
               class="<%= "productos".equals(seccionActiva) ? "activo" : "" %>">
            <img class="icono" src="${pageContext.request.contextPath}/img/Icon/inventario.png" alt=""> Inventario
        </a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/admin/clientes.jsp"
               class="<%= "clientes".equals(seccionActiva) ? "activo" : "" %>">
            <img class="icono" src="${pageContext.request.contextPath}/img/Icon/cliente.png" alt=""> Clientes
        </a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/admin/capacidad.jsp"
               class="<%= "configuracion".equals(seccionActiva) ? "activo" : "" %>">
            <img class="icono" src="${pageContext.request.contextPath}/img/Icon/ajustes.png" alt=""> Configuracion
        </a></li>
    </ul>

    <div class="admin-sidebar__footer">
        <div class="nombre"><%= nombreAdmin %></div>
        <a href="${pageContext.request.contextPath}/logout">
            <img class="icono-logout" src="${pageContext.request.contextPath}/img/Icon/logout.png" alt=""> Cerrar sesion
        </a>
    </div>
</aside>
