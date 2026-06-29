<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, dao.PedidoDAO, modelo.Pedido" %>
<%
    String rol = (String) session.getAttribute("rol");
    if (!"cliente".equals(rol)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    int idCliente = (int) session.getAttribute("id_cliente");
    List<Pedido> pedidos = new PedidoDAO().listarPorCliente(idCliente);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Pedidos — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        .panel-hero { padding: 48px 64px 24px; }
        .panel-hero h1 { font-family:var(--titulo); font-size:36px; font-weight:700; margin-bottom:8px; }
        .panel-hero p  { color:var(--texto-suave); }

        .lista-pedidos { padding: 0 64px 64px; }

        .pedido-card {
            background:#fff; border:1px solid var(--borde);
            border-radius:12px; padding:24px; margin-bottom:16px;
        }
        .pedido-card__header {
            display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;
        }
        .pedido-card__header h3 { font-family:var(--titulo); font-size:18px; }

        .pedido-card__detalle {
            display:grid; grid-template-columns:repeat(3,1fr); gap:16px;
            font-size:14px; color:var(--texto-suave);
        }
        .pedido-card__detalle div strong { display:block; color:var(--texto); font-size:13px; margin-bottom:4px; }

        .pedido-card__footer { margin-top:16px; text-align:right; display:flex; gap:8px; justify-content:flex-end; }

        .btn-ver {
            display:inline-block; padding:8px 20px; background:var(--primario);
            color:#fff; border-radius:999px; font-size:13px; font-weight:600; text-decoration:none;
        }
        .btn-ver:hover { background:var(--primario-dark); text-decoration:none; }

        .btn-cancelar {
            display:inline-block; padding:8px 20px; background:transparent;
            color:#8b1a1a; border:1px solid #f5a5a5; border-radius:999px;
            font-size:13px; font-weight:600; text-decoration:none; cursor:pointer;
        }
        .btn-cancelar:hover { background:#fde8e8; text-decoration:none; }

        .cta-nuevo {
            text-align:center; padding:48px; background:var(--fondo-alt);
            border-radius:12px; margin:0 64px 64px;
        }
        .cta-nuevo h2 { font-family:var(--titulo); font-size:24px; margin-bottom:12px; }
        .cta-nuevo p  { color:var(--texto-suave); margin-bottom:24px; }

        .vacio {
            text-align:center; padding:64px; color:var(--texto-suave);
        }
        .vacio h2 { font-family:var(--titulo); font-size:24px; margin-bottom:12px; color:var(--texto); }
    </style>
</head>
<body>
<% request.setAttribute("paginaActiva", "pedidos"); %>
<%@ include file="/jsp/layouts/header.jsp" %>

<main>
    <section class="panel-hero">
        <span class="etiqueta">Panel del Cliente</span>
        <h1>Mis Pedidos</h1>
        <p>Hola, <strong><%= session.getAttribute("nombre") %></strong>. Aquí puedes seguir el estado de tus pedidos.</p>
    </section>

    <div class="lista-pedidos">
        <% if (pedidos.isEmpty()) { %>
            <div class="vacio">
                <h2>Aún no tienes pedidos</h2>
                <p>Explora nuestro catálogo y haz tu primer pedido personalizado.</p>
                <a href="${pageContext.request.contextPath}/jsp/publico/catalogo.jsp" class="btn btn-primario" style="margin-top:16px;">Ver catálogo</a>
            </div>
        <% } else {
            for (Pedido p : pedidos) {
                String badgeClass = "badge-" + p.getEstado().toLowerCase()
                    .replace(" ", "").replace("ó","o").replace("ú","u").replace("é","e");
        %>
        <div class="pedido-card">
            <div class="pedido-card__header">
                <h3>Pedido #<%= p.getIdPedido() %> — <%= p.getNombreProducto() %></h3>
                <span class="badge <%= badgeClass %>"><%= p.getEstado() %></span>
            </div>
            <div class="pedido-card__detalle">
                <div>
                    <strong>Variante</strong>
                    <%= p.getTamanoVariante() %>
                </div>
                <div>
                    <strong>Fecha de entrega</strong>
                    <%= p.getFechaEntrega() %>
                </div>
                <div>
                    <strong>Precio total</strong>
                    <% if (p.isPrecioConfirmado()) { %>
                        $<%= String.format("%.2f", p.getPrecioTotal()) %>
                    <% } else { %>
                        <em style="color:var(--texto-suave)">Pendiente de confirmación</em>
                    <% } %>
                </div>
            </div>
            <div class="pedido-card__footer">
                <% if ("Pendiente".equals(p.getEstado())) { %>
                <form action="${pageContext.request.contextPath}/pedido" method="POST" style="display:inline"
                      onsubmit="return confirm('¿Seguro que deseas cancelar este pedido?')">
                    <input type="hidden" name="accion"    value="cancelar">
                    <input type="hidden" name="id_pedido" value="<%= p.getIdPedido() %>">
                    <button type="submit" class="btn-cancelar">Cancelar</button>
                </form>
                <% } %>
                <a href="${pageContext.request.contextPath}/jsp/cliente/detalle-pedido.jsp?id=<%= p.getIdPedido() %>"
                   class="btn-ver">Ver detalles</a>
            </div>
        </div>
        <% } } %>
    </div>

    <% if (!pedidos.isEmpty()) { %>
    <div class="cta-nuevo">
        <h2>¿Quieres hacer otro pedido?</h2>
        <p>Explora nuestro catálogo y realiza un pedido personalizado para cualquier ocasión.</p>
        <a href="${pageContext.request.contextPath}/jsp/cliente/nuevo-pedido.jsp" class="btn btn-primario">Nuevo pedido</a>
        <a href="${pageContext.request.contextPath}/jsp/publico/catalogo.jsp" class="btn btn-outline" style="margin-left:12px;">Ver catálogo</a>
    </div>
    <% } %>
</main>

<%@ include file="/jsp/layouts/footer.jsp" %>
</body>
</html>
