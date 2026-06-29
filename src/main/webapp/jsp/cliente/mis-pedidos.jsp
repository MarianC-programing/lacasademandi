<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Panel de Cliente — Mis Pedidos --%>
<%
    String rol = (String) session.getAttribute("rol");
    if (!"cliente".equals(rol)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Pedidos — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        .panel-hero {
            padding: 48px 64px 24px;
        }
        .panel-hero h1 {
            font-family: var(--titulo);
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 8px;
        }
        .panel-hero p {
            color: var(--texto-suave);
        }
        .pedido-card {
            background: #fff;
            border: 1px solid var(--borde);
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 16px;
        }
        .pedido-card__header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }
        .pedido-card__header h3 {
            font-family: var(--titulo);
            font-size: 18px;
        }
        .pedido-card__detalle {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            font-size: 14px;
            color: var(--texto-suave);
        }
        .pedido-card__detalle div strong {
            display: block;
            color: var(--texto);
            font-size: 13px;
            margin-bottom: 4px;
        }
        .btn-ver {
            display: inline-block;
            padding: 8px 20px;
            background: var(--primario);
            color: #fff;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
        }
        .btn-ver:hover {
            background: var(--primario-dark);
            text-decoration: none;
        }
        .lista-pedidos {
            padding: 0 64px 64px;
        }
        .nuevo-pedido-cta {
            text-align: center;
            padding: 48px;
            background: var(--fondo-alt);
            border-radius: 12px;
            margin: 0 64px 64px;
        }
        .nuevo-pedido-cta h2 {
            font-family: var(--titulo);
            font-size: 24px;
            margin-bottom: 16px;
        }
        .nuevo-pedido-cta p {
            color: var(--texto-suave);
            margin-bottom: 24px;
        }
    </style>
</head>
<body>

<% request.setAttribute("paginaActiva", "pedidos"); %>
<%@ include file="/jsp/layouts/header.jsp" %>

<main>

    <section class="panel-hero">
        <span class="etiqueta">Panel del Cliente</span>
        <h1>Mis Pedidos</h1>
        <p>Aqui puedes ver el estado de todos tus pedidos y realizar nuevos.</p>
    </section>

    <div class="lista-pedidos">
        <%-- Pedido de ejemplo --%>
        <div class="pedido-card">
            <div class="pedido-card__header">
                <h3>Pedido #1001 — Tres Leches Frutal</h3>
                <span class="badge badge-aceptado">Aceptado</span>
            </div>
            <div class="pedido-card__detalle">
                <div>
                    <strong>Fecha de entrega</strong>
                    25 de julio, 2026
                </div>
                <div>
                    <strong>Precio</strong>
                    $35.00
                </div>
                <div>
                    <strong>Abono</strong>
                    $17.50
                </div>
            </div>
            <div style="margin-top:16px; text-align:right;">
                <a href="${pageContext.request.contextPath}/jsp/cliente/detalle-pedido.jsp?id=1001" class="btn-ver">Ver detalles</a>
            </div>
        </div>

        <div class="pedido-card">
            <div class="pedido-card__header">
                <h3>Pedido #1002 — Cheesecake Tropical</h3>
                <span class="badge badge-listo">Listo</span>
            </div>
            <div class="pedido-card__detalle">
                <div>
                    <strong>Fecha de entrega</strong>
                    20 de julio, 2026
                </div>
                <div>
                    <strong>Precio</strong>
                    $18.00
                </div>
                <div>
                    <strong>Abono</strong>
                    $9.00
                </div>
            </div>
            <div style="margin-top:16px; text-align:right;">
                <a href="${pageContext.request.contextPath}/jsp/cliente/detalle-pedido.jsp?id=1002" class="btn-ver">Ver detalles</a>
            </div>
        </div>
    </div>

    <div class="nuevo-pedido-cta">
        <h2>¿Quieres hacer un nuevo pedido?</h2>
        <p>Explora nuestro catalogo y realiza un pedido personalizado para cualquier ocasion.</p>
        <a href="${pageContext.request.contextPath}/jsp/cliente/nuevo-pedido.jsp" class="btn btn-primario">Nuevo pedido</a>
        <a href="${pageContext.request.contextPath}/jsp/publico/catalogo.jsp" class="btn btn-outline" style="margin-left:12px;">Ver catalogo</a>
    </div>

</main>

<%@ include file="/jsp/layouts/footer.jsp" %>

</body>
</html>
