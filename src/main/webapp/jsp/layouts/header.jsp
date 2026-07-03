<%-- Header reutilizable
     Antes del include: request.setAttribute("paginaActiva", "inicio|catalogo|nosotros|pedidos");
--%>
<%
    String paginaActiva = request.getAttribute("paginaActiva") != null
        ? (String) request.getAttribute("paginaActiva") : "";
    String rolSesion = (String) session.getAttribute("rol");
    String nombreSesion = session.getAttribute("nombre") != null
        ? (String) session.getAttribute("nombre") : "";
%>
<header class="header">
    <a href="${pageContext.request.contextPath}/index.jsp" class="header__logo" aria-label="La Casa de Mandi">
        <img src="${pageContext.request.contextPath}/img/Logo.png" alt="Logo de La Casa de Mandi">
    </a>

    <nav>
        <ul class="header__nav">
            <li><a href="${pageContext.request.contextPath}/index.jsp"
                   class="<%= "inicio".equals(paginaActiva)   ? "activo" : "" %>">Inicio</a></li>
            <li><a href="${pageContext.request.contextPath}/jsp/publico/catalogo.jsp"
                   class="<%= "catalogo".equals(paginaActiva) ? "activo" : "" %>">Catalogo</a></li>
            <li><a href="${pageContext.request.contextPath}/jsp/publico/nosotros.jsp"
                   class="<%= "nosotros".equals(paginaActiva) ? "activo" : "" %>">Sobre Nosotros</a></li>
        </ul>
    </nav>

    <div style="display:flex; align-items:center; gap:12px;">
        <% if ("cliente".equals(rolSesion)) { %>
            <span style="font-size:14px; color:var(--texto-suave);">Hola, <%= nombreSesion %></span>
            <a href="${pageContext.request.contextPath}/jsp/cliente/mis-pedidos.jsp" class="btn btn-primario">Mis pedidos</a>
            <a href="${pageContext.request.contextPath}/logout" style="font-size:13px; color:var(--texto-suave);">Salir</a>
        <% } else if ("admin".equals(rolSesion)) { %>
            <span style="font-size:14px; color:var(--texto-suave);">Admin: <%= nombreSesion %></span>
            <a href="${pageContext.request.contextPath}/jsp/admin/dashboard.jsp" class="btn btn-primario">Panel</a>
            <a href="${pageContext.request.contextPath}/logout" style="font-size:13px; color:var(--texto-suave);">Salir</a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline">Iniciar sesion</a>
            <a href="${pageContext.request.contextPath}/registro" class="btn btn-primario">Crear cuenta</a>
        <% } %>
    </div>
</header>
