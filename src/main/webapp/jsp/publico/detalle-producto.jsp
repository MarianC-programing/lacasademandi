<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.ProductoDAO, modelo.Producto, modelo.Variante" %>
<%
    Producto producto = null;
    String errorMsg = null;

    try {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) throw new Exception("ID no especificado");
        int idProducto = Integer.parseInt(idParam.trim());
        producto = new ProductoDAO().buscarPorId(idProducto);
        if (producto == null) errorMsg = "Producto no encontrado.";
    } catch (Exception e) {
        errorMsg = "Producto no encontrado.";
    }

    String rol = (String) session.getAttribute("rol");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= producto != null ? producto.getNombre() : "Producto" %> — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        .detalle-wrap {
            display: grid; grid-template-columns: 1fr 1fr; gap: 48px;
            padding: 48px 64px 64px;
        }
        .detalle-img {
            width: 100%; aspect-ratio: 4/3; border-radius: 20px;
            overflow: hidden; background: var(--fondo-alt);
        }
        .detalle-img img { width: 100%; height: 100%; object-fit: cover; }

        .detalle-info .card-producto__cat {
            font-size: 12px; font-weight: 600; letter-spacing: 0.08em;
            text-transform: uppercase; color: var(--primario); margin-bottom: 12px;
        }
        .detalle-info h1 { font-family: var(--titulo); font-size: 40px; font-weight: 700; margin-bottom: 16px; }
        .detalle-info .descripcion { color: var(--texto-suave); font-size: 16px; line-height: 26px; margin-bottom: 28px; }

        .variantes-lista { margin-bottom: 28px; }
        .variantes-lista h3 { font-size: 14px; font-weight: 600; margin-bottom: 12px; color: var(--texto); }
        .variante-fila {
            display: flex; justify-content: space-between; align-items: center;
            padding: 14px 18px; border: 1px solid var(--borde); border-radius: 10px; margin-bottom: 10px;
        }
        .variante-fila .precio { color: var(--primario); font-weight: 700; }

        .sin-resultado { text-align: center; padding: 80px; }
        .sin-resultado h1 { font-family: var(--titulo); font-size: 32px; margin-bottom: 16px; }
    </style>
</head>
<body>
<% request.setAttribute("paginaActiva", "catalogo"); %>
<%@ include file="/jsp/layouts/header.jsp" %>

<main>
    <% if (errorMsg != null) { %>
        <div class="sin-resultado">
            <h1>Producto no encontrado</h1>
            <p style="color:var(--texto-suave); margin-bottom:24px;"><%= errorMsg %></p>
            <a href="${pageContext.request.contextPath}/jsp/publico/catalogo.jsp" class="btn btn-primario">Volver al catálogo</a>
        </div>
    <% } else { %>

    <div class="detalle-wrap">
        <div class="detalle-img">
            <% if (producto.getImagen() != null && !producto.getImagen().isEmpty()) { %>
                <img src="${pageContext.request.contextPath}/img/<%= producto.getImagen() %>"
                     alt="<%= producto.getNombre() %>" onerror="this.style.display='none'">
            <% } %>
        </div>

        <div class="detalle-info">
            <p class="card-producto__cat"><%= producto.getNombreCategoria() %></p>
            <h1><%= producto.getNombre() %></h1>
            <p class="descripcion"><%= producto.getDescripcion() != null ? producto.getDescripcion() : "" %></p>

            <div class="variantes-lista">
                <h3>Tamaños disponibles</h3>
                <% for (Variante v : producto.getVariantes()) { %>
                <div class="variante-fila">
                    <span><%= v.getTamano() %></span>
                    <span class="precio">$<%= String.format("%.2f", v.getPrecioBase()) %></span>
                </div>
                <% } %>
            </div>

            <% if ("cliente".equals(rol)) { %>
                <a href="${pageContext.request.contextPath}/jsp/cliente/nuevo-pedido.jsp?producto=<%= producto.getIdProducto() %>"
                   class="btn btn-primario">Pedir ahora</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primario">Inicia sesión para pedir</a>
            <% } %>
            <a href="${pageContext.request.contextPath}/jsp/publico/catalogo.jsp" class="btn btn-outline" style="margin-left:12px;">← Catálogo</a>
        </div>
    </div>

    <% } %>
</main>

<%@ include file="/jsp/layouts/footer.jsp" %>
</body>
</html>
