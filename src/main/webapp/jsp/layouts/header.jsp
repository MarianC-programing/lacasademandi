<%-- Header reutilizable
     Antes del include declarar: String paginaActiva = "inicio";
     Valores posibles: inicio, catalogo, nosotros, contacto, pedidos
--%>
<% String paginaActiva = request.getAttribute("paginaActiva") != null ? (String) request.getAttribute("paginaActiva") : ""; %>
<header class="header">
    <a href="${pageContext.request.contextPath}/index.jsp" class="header__logo">La Casa de Mandi</a>

    <nav>
        <ul class="header__nav">
            <li><a href="${pageContext.request.contextPath}/index.jsp"
                class="<%= "inicio".equals(paginaActiva) ? "activo" : "" %>">Inicio</a></li>
            <li><a href="${pageContext.request.contextPath}/jsp/publico/catalogo.jsp"
                class="<%= "catalogo".equals(paginaActiva) ? "activo" : "" %>">Catalogo</a></li>
            <li><a href="${pageContext.request.contextPath}/jsp/publico/nosotros.jsp"
                class="<%= "nosotros".equals(paginaActiva) ? "activo" : "" %>">Sobre Nosotros</a></li>
            <li><a href="${pageContext.request.contextPath}/jsp/publico/contacto.jsp"
                class="<%= "contacto".equals(paginaActiva) ? "activo" : "" %>">Contacto</a></li>
        </ul>
    </nav>

    <div>
        <% if (session.getAttribute("cliente") != null) { %>
            <a href="${pageContext.request.contextPath}/jsp/cliente/mis-pedidos.jsp" class="btn btn-primario">Mi cuenta</a>
        <% } else if (session.getAttribute("admin") != null) { %>
            <a href="${pageContext.request.contextPath}/jsp/admin/dashboard.jsp" class="btn btn-primario">Panel admin</a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/jsp/publico/login.jsp" class="btn btn-primario">Acceder</a>
        <% } %>
    </div>
</header>
