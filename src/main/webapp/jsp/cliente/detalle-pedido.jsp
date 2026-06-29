<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Cliente - Detalle de Pedido --%>
<%
    String rol2 = (String) session.getAttribute("rol");
    if (!"cliente".equals(rol2)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle del Pedido — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        .panel-hero { padding: 48px 64px 24px; }
        .panel-hero h1 { font-family: var(--titulo); font-size: 36px; font-weight: 700; }
        .detalle-pedido { padding: 0 64px 64px; display: grid; grid-template-columns: 2fr 1fr; gap: 32px; }
        .info-card {
            background: #fff; border: 1px solid var(--borde); border-radius: 12px; padding: 32px;
        }
        .info-card h2 { font-family: var(--titulo); font-size: 20px; margin-bottom: 24px; }
        .info-fila { display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid var(--borde); font-size: 14px; }
        .info-fila:last-child { border-bottom: none; }
        .info-fila strong { color: var(--texto); font-weight: 600; }
        .info-fila span { color: var(--texto-suave); }
        .acciones { padding: 24px; background: var(--fondo-alt); border-radius: 12px; text-align: center; }
        .acciones h3 { font-family: var(--titulo); font-size: 18px; margin-bottom: 16px; }
        .acciones .btn { margin-bottom: 8px; }
    </style>
</head>
<body>
<% request.setAttribute("paginaActiva", "pedidos"); %>
<%@ include file="/jsp/layouts/header.jsp" %>
<main>
    <section class="panel-hero">
        <span class="etiqueta">Detalle del Pedido</span>
        <h1>Pedido #<%= request.getParameter("id") != null ? request.getParameter("id") : "1001" %></h1>
    </section>
    <div class="detalle-pedido">
        <div class="info-card">
            <h2>Informacion del pedido</h2>
            <div class="info-fila"><strong>Producto</strong><span>Tres Leches Frutal</span></div>
            <div class="info-fila"><strong>Variante</strong><span>Medio (8-10 porciones)</span></div>
            <div class="info-fila"><strong>Cantidad</strong><span>1</span></div>
            <div class="info-fila"><strong>Fecha de entrega</strong><span>25 de julio, 2026</span></div>
            <div class="info-fila"><strong>Descripcion</strong><span>Decorado con fresas frescas y melocoton.</span></div>
            <div class="info-fila"><strong>Estado</strong><span><span class="badge badge-aceptado">Aceptado</span></span></div>
            <div class="info-fila"><strong>Precio</strong><span>$35.00</span></div>
            <div class="info-fila"><strong>Abono</strong><span>$17.50</span></div>
            <div class="info-fila"><strong>Pendiente</strong><span>$17.50</span></div>
        </div>
        <div>
            <div class="acciones">
                <h3>Acciones</h3>
                <a href="#" class="btn btn-primario btn-bloque">Registrar abono</a>
                <a href="#" class="btn btn-outline btn-bloque" style="margin-top:8px;">Descargar recibo</a>
                <a href="${pageContext.request.contextPath}/jsp/cliente/mis-pedidos.jsp" class="btn btn-outline btn-bloque" style="margin-top:8px;">&larr; Volver a mis pedidos</a>
            </div>
        </div>
    </div>
</main>
<%@ include file="/jsp/layouts/footer.jsp" %>
</body>
</html>
