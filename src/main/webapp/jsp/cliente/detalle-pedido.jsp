<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.PedidoDAO, modelo.Pedido" %>
<%
    String rol = (String) session.getAttribute("rol");
    if (!"cliente".equals(rol)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    int idCliente = (int) session.getAttribute("id_cliente");

    Pedido pedido = null;
    String errorMsg = null;

    try {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) throw new Exception("ID no especificado");

        int idPedido = Integer.parseInt(idParam.trim());
        pedido = new PedidoDAO().buscarPorId(idPedido);

        if (pedido == null) {
            errorMsg = "Pedido no encontrado.";
        } else if (pedido.getIdCliente() != idCliente) {
            // Seguridad: el pedido no pertenece al cliente en sesión
            response.sendRedirect(request.getContextPath() + "/jsp/cliente/mis-pedidos.jsp");
            return;
        }
    } catch (Exception e) {
        errorMsg = "No se pudo cargar el pedido.";
    }

    boolean esNuevo = "1".equals(request.getParameter("nuevo"));
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle del Pedido — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        .panel-hero { padding:48px 64px 24px; }
        .panel-hero h1 { font-family:var(--titulo); font-size:36px; font-weight:700; }

        .detalle-pedido {
            padding:0 64px 64px;
            display:grid; grid-template-columns:2fr 1fr; gap:32px;
        }

        .info-card {
            background:#fff; border:1px solid var(--borde);
            border-radius:12px; padding:32px;
        }
        .info-card h2 { font-family:var(--titulo); font-size:20px; margin-bottom:24px; }

        .info-fila {
            display:flex; justify-content:space-between; align-items:center;
            padding:12px 0; border-bottom:1px solid var(--borde); font-size:14px;
        }
        .info-fila:last-child { border-bottom:none; }
        .info-fila strong { color:var(--texto); font-weight:600; flex-shrink:0; margin-right:16px; }
        .info-fila span   { color:var(--texto-suave); text-align:right; }

        .acciones {
            padding:24px; background:var(--fondo-alt);
            border-radius:12px; position:sticky; top:80px;
        }
        .acciones h3 { font-family:var(--titulo); font-size:18px; margin-bottom:16px; }

        .estado-timeline { margin-bottom:24px; }
        .estado-paso {
            display:flex; align-items:center; gap:12px;
            font-size:13px; margin-bottom:10px; color:var(--texto-suave);
        }
        .estado-paso .dot {
            width:10px; height:10px; border-radius:50%;
            background:var(--borde); flex-shrink:0;
        }
        .estado-paso.activo .dot  { background:var(--primario); }
        .estado-paso.activo      { color:var(--texto); font-weight:600; }
        .estado-paso.completado .dot { background:#22c55e; }

        .precio-pendiente {
            background:#fdf3e3; border:1px solid #f5d99a; border-radius:8px;
            padding:12px; font-size:13px; color:#7a4f00; margin-bottom:16px; text-align:center;
        }

        .alerta-exito {
            background:#d1fae5; border:1px solid #6ee7b7; border-radius:8px;
            padding:12px 16px; color:#065f46; font-size:14px; margin:0 64px 16px;
        }
    </style>
</head>
<body>
<% request.setAttribute("paginaActiva", "pedidos"); %>
<%@ include file="/jsp/layouts/header.jsp" %>

<main>
    <% if (esNuevo) { %>
    <div class="alerta-exito">
        ✅ <strong>¡Pedido enviado!</strong> Lo revisaremos pronto y te confirmaremos el precio.
    </div>
    <% } %>

    <% if (errorMsg != null) { %>
    <section class="panel-hero">
        <h1>Error</h1>
        <p style="color:var(--texto-suave);"><%= errorMsg %></p>
        <a href="${pageContext.request.contextPath}/jsp/cliente/mis-pedidos.jsp"
           class="btn btn-outline" style="margin-top:16px;">← Volver a mis pedidos</a>
    </section>
    <% } else { %>

    <section class="panel-hero">
        <span class="etiqueta">Detalle del Pedido</span>
        <h1>Pedido #<%= pedido.getIdPedido() %></h1>
    </section>

    <div class="detalle-pedido">

        <div class="info-card">
            <h2>Información del pedido</h2>
            <div class="info-fila"><strong>Producto</strong><span><%= pedido.getNombreProducto() %></span></div>
            <div class="info-fila"><strong>Variante</strong><span><%= pedido.getTamanoVariante() %></span></div>
            <div class="info-fila"><strong>Fecha de entrega</strong><span><%= pedido.getFechaEntrega() %></span></div>
            <div class="info-fila"><strong>Fecha del pedido</strong><span><%= pedido.getFechaPedido() %></span></div>
            <div class="info-fila">
                <strong>Descripción del diseño</strong>
                <span><%= pedido.getDescripcionDiseno() != null && !pedido.getDescripcionDiseno().isEmpty()
                          ? pedido.getDescripcionDiseno() : "Sin descripción" %></span>
            </div>
            <div class="info-fila">
                <strong>Estado</strong>
                <span>
                    <%
                    String est = pedido.getEstado();
                    String badgeClass = "badge-" + est.toLowerCase()
                        .replace(" ", "").replace("ó","o").replace("ú","u").replace("é","e");
                    %>
                    <span class="badge <%= badgeClass %>"><%= est %></span>
                </span>
            </div>
            <div class="info-fila">
                <strong>Precio total</strong>
                <span>
                    <% if (pedido.isPrecioConfirmado()) { %>
                        <strong style="color:var(--primario);">$<%= String.format("%.2f", pedido.getPrecioTotal()) %></strong>
                    <% } else { %>
                        <em>Pendiente de confirmación por el equipo</em>
                    <% } %>
                </span>
            </div>
        </div>

        <div>
            <div class="acciones">
                <h3>Estado del pedido</h3>

                <%
                String[] pasos = {"Pendiente","Aceptado","En produccion","Listo","Entregado"};
                int pasoActual = 0;
                for (int i = 0; i < pasos.length; i++) {
                    if (pasos[i].equals(pedido.getEstado())) { pasoActual = i; break; }
                }
                %>
                <div class="estado-timeline">
                <% for (int i = 0; i < pasos.length; i++) {
                    String clase = i < pasoActual ? "completado" : (i == pasoActual ? "activo" : "");
                %>
                    <div class="estado-paso <%= clase %>">
                        <div class="dot"></div>
                        <%= pasos[i] %>
                    </div>
                <% } %>
                </div>

                <% if (!pedido.isPrecioConfirmado()) { %>
                <div class="precio-pendiente">
                    El precio aún no ha sido confirmado por el equipo. Te avisaremos pronto.
                </div>
                <% } %>

                <% if ("Pendiente".equals(pedido.getEstado())) { %>
                <form action="${pageContext.request.contextPath}/pedido" method="POST"
                      onsubmit="return confirm('¿Seguro que deseas cancelar este pedido?')">
                    <input type="hidden" name="accion"    value="cancelar">
                    <input type="hidden" name="id_pedido" value="<%= pedido.getIdPedido() %>">
                    <button type="submit" class="btn btn-outline btn-bloque"
                            style="color:#8b1a1a; border-color:#f5a5a5; margin-bottom:8px;">
                        Cancelar pedido
                    </button>
                </form>
                <% } %>

                <a href="${pageContext.request.contextPath}/jsp/cliente/mis-pedidos.jsp"
                   class="btn btn-outline btn-bloque">← Volver a mis pedidos</a>
            </div>
        </div>
    </div>

    <% } %>
</main>

<%@ include file="/jsp/layouts/footer.jsp" %>
</body>
</html>
