<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, dao.ProductoDAO, modelo.Producto, modelo.Variante" %>
<%
    ProductoDAO dao = new ProductoDAO();
    List<Producto> dulces  = dao.listarPorCategoria("Dulces");
    List<Producto> postres = dao.listarPorCategoria("Postres");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catálogo — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        .catalogo-hero { text-align: center; padding: 64px 64px 32px; }
        .catalogo-hero h1 { font-family: var(--titulo); font-size: 48px; font-weight: 700; margin: 8px 0 16px; }
        .catalogo-hero p { color: var(--texto-suave); max-width: 500px; margin: 0 auto; }
        .tabs { display: flex; justify-content: center; gap: 12px; margin: 32px 0 40px; }
        .tab { padding: 10px 28px; border-radius: 999px; border: 1px solid var(--borde); background: transparent;
               font-family: var(--cuerpo); font-size: 15px; cursor: pointer; color: var(--texto); transition: background 0.15s, color 0.15s; }
        .tab.activo { background: var(--primario); color: #fff; border-color: var(--primario); }
        .catalogo-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; padding: 0 64px 64px; }
        .card-producto { background: #fff; border: 1px solid var(--borde); border-radius: 16px; overflow: hidden; }
        .card-producto__img { width: 100%; aspect-ratio: 4/3; background: var(--fondo-alt); overflow: hidden; position: relative; }
        .card-producto__img img { width: 100%; height: 100%; object-fit: cover; }
        .card-producto__cuerpo { padding: 20px; }
        .card-producto__cat { font-size: 11px; font-weight: 600; letter-spacing: 0.08em;
               text-transform: uppercase; color: var(--texto-suave); margin-bottom: 8px; }
        .card-producto__nombre { font-family: var(--titulo); font-size: 20px; font-weight: 600; margin-bottom: 8px; }
        .card-producto__desc { font-size: 14px; color: var(--texto-suave); line-height: 22px; margin-bottom: 16px; }
        .card-producto__pie { display: flex; justify-content: space-between; align-items: center;
               border-top: 1px solid var(--borde); padding-top: 14px; font-size: 14px; }
        .precio { color: var(--primario); font-weight: 700; font-size: 16px; }
        .suscripcion { text-align: center; padding: 64px; background: var(--fondo-alt); }
        .suscripcion h2 { font-family: var(--titulo); font-size: 28px; margin-bottom: 8px; }
        .suscripcion p { color: var(--texto-suave); margin-bottom: 24px; }
        .suscripcion__form { display: flex; justify-content: center; gap: 12px; }
        .suscripcion__form input { padding: 12px 20px; border: 1px solid var(--borde); border-radius: 999px;
               font-size: 15px; width: 300px; font-family: var(--cuerpo); outline: none; }
        .sin-productos { text-align: center; padding: 40px; color: var(--texto-suave); }
    </style>
</head>
<body>
<% request.setAttribute("paginaActiva", "catalogo"); %>
<%@ include file="/jsp/layouts/header.jsp" %>

<main>
    <div class="catalogo-hero">
        <span class="etiqueta">Tradición &amp; Sabor</span>
        <h1>Nuestras Delicias Artesanales</h1>
        <p>Ingredientes frescos, recetas de siempre y mucho amor en cada bocado.</p>
    </div>

    <div class="tabs">
        <button class="tab activo" onclick="mostrar('dulces', this)">🎂 Dulces</button>
        <button class="tab"        onclick="mostrar('postres', this)">🍮 Postres</button>
    </div>

    <%-- ====== SECCIÓN DULCES ====== --%>
    <div id="sec-dulces">
        <% if (dulces.isEmpty()) { %>
            <p class="sin-productos">No hay dulces disponibles en este momento.</p>
        <% } else { %>
        <div class="catalogo-grid">
            <% for (Producto p : dulces) {
                Variante primera = p.getVariantes().isEmpty() ? null : p.getVariantes().get(0); %>
            <div class="card-producto">
                <div class="card-producto__img">
                    <% if (p.getImagen() != null && !p.getImagen().isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/img/<%= p.getImagen() %>"
                             alt="<%= p.getNombre() %>" onerror="this.style.display='none'">
                    <% } %>
                </div>
                <div class="card-producto__cuerpo">
                    <p class="card-producto__cat">Dulce Artesanal</p>
                    <h3 class="card-producto__nombre"><%= p.getNombre() %></h3>
                    <p class="card-producto__desc"><%= p.getDescripcion() %></p>
                    <div class="card-producto__pie">
                        <span>Desde <strong class="precio">
                            $<%= primera != null ? String.format("%.2f", primera.getPrecioBase()) : "--" %>
                        </strong></span>
                        <a href="${pageContext.request.contextPath}/jsp/cliente/nuevo-pedido.jsp?producto=<%= p.getIdProducto() %>">
                            Pedir ahora
                        </a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>

    <%-- ====== SECCIÓN POSTRES ====== --%>
    <div id="sec-postres" style="display:none;">
        <% if (postres.isEmpty()) { %>
            <p class="sin-productos">No hay postres disponibles en este momento.</p>
        <% } else { %>
        <div class="catalogo-grid">
            <% for (Producto p : postres) {
                Variante primera = p.getVariantes().isEmpty() ? null : p.getVariantes().get(0); %>
            <div class="card-producto">
                <div class="card-producto__img">
                    <% if (p.getImagen() != null && !p.getImagen().isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/img/<%= p.getImagen() %>"
                             alt="<%= p.getNombre() %>" onerror="this.style.display='none'">
                    <% } %>
                </div>
                <div class="card-producto__cuerpo">
                    <p class="card-producto__cat">Postre Individual</p>
                    <h3 class="card-producto__nombre"><%= p.getNombre() %></h3>
                    <p class="card-producto__desc"><%= p.getDescripcion() %></p>
                    <div class="card-producto__pie">
                        <span>Desde <strong class="precio">
                            $<%= primera != null ? String.format("%.2f", primera.getPrecioBase()) : "--" %>
                        </strong></span>
                        <a href="${pageContext.request.contextPath}/jsp/cliente/nuevo-pedido.jsp?producto=<%= p.getIdProducto() %>">
                            Pedir ahora
                        </a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>

    <div class="suscripcion">
        <h2>¿Quieres probar algo especial?</h2>
        <p>Suscríbete para recibir noticias sobre nuevos lanzamientos y ofertas exclusivas.</p>
        <div class="suscripcion__form">
            <input type="email" placeholder="Tu correo electrónico">
            <button class="btn btn-primario">Suscribirse</button>
        </div>
    </div>
</main>

<%@ include file="/jsp/layouts/footer.jsp" %>

<script>
    function mostrar(cat, boton) {
        document.getElementById('sec-dulces').style.display  = 'none';
        document.getElementById('sec-postres').style.display = 'none';
        document.getElementById('sec-' + cat).style.display = 'block';
        document.querySelectorAll('.tab').forEach(t => t.classList.remove('activo'));
        boton.classList.add('activo');
    }
</script>
</body>
</html>
