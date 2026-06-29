<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Admin - Gestion de Productos --%>
<%
    String rol7 = (String) session.getAttribute("rol");
    if (!"admin".equals(rol7)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Productos — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        .admin-header { padding: 48px 64px 24px; }
        .admin-header h1 { font-family: var(--titulo); font-size: 36px; font-weight: 700; }
        .productos-grid { padding: 0 64px 64px; display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; }
        .producto-card {
            background: #fff; border: 1px solid var(--borde); border-radius: 12px; overflow: hidden;
        }
        .producto-card__img { width: 100%; aspect-ratio: 4/3; background: var(--fondo-alt); }
        .producto-card__body { padding: 20px; }
        .producto-card__body h3 { font-family: var(--titulo); font-size: 18px; margin-bottom: 8px; }
        .producto-card__body p { font-size: 14px; color: var(--texto-suave); margin-bottom: 12px; }
        .producto-card__body .precio { color: var(--primario); font-weight: 700; font-size: 16px; }
        .producto-card__actions { display: flex; gap: 8px; margin-top: 12px; }
        .btn-sm { padding: 6px 14px; font-size: 12px; border-radius: 999px; background: var(--primario); color: #fff; text-decoration: none; }
        .btn-sm:hover { background: var(--primario-dark); text-decoration: none; }
        .btn-sm-outline { padding: 6px 14px; font-size: 12px; border-radius: 999px; border: 1px solid var(--borde); color: var(--texto); text-decoration: none; background: transparent; }
        .add-producto { padding: 0 64px 24px; }
        .add-producto .btn { padding: 12px 28px; }
    </style>
</head>
<body>
<% request.setAttribute("paginaActiva", "inicio"); %>
<%@ include file="/jsp/layouts/header.jsp" %>
<main>
    <section class="admin-header">
        <span class="etiqueta">Panel Administrador</span>
        <h1>Productos</h1>
        <p style="color:var(--texto-suave);">Gestionar catalogo de dulces y postres.</p>
    </section>
    <div class="add-producto">
        <a href="#" class="btn btn-primario">+ Agregar producto</a>
    </div>
    <div class="productos-grid">
        <div class="producto-card">
            <div class="producto-card__img"></div>
            <div class="producto-card__body">
                <small style="font-size:11px;color:var(--texto-suave)">Dulce Tradicional</small>
                <h3>Delicia Tres Leches Frutal</h3>
                <p>Bizcocho tres leches con fresas y melocoton.</p>
                <span class="precio">$35.00</span>
                <div class="producto-card__actions">
                    <a href="#" class="btn-sm">Editar</a>
                    <a href="#" class="btn-sm-outline">Variantes</a>
                </div>
            </div>
        </div>
        <div class="producto-card">
            <div class="producto-card__img"></div>
            <div class="producto-card__body">
                <small style="font-size:11px;color:var(--texto-suave)">Reposteria Fina</small>
                <h3>Cheesecake Tropical de Maracuya</h3>
                <p>Cheesecake con cobertura de maracuya natural.</p>
                <span class="precio">$18.00</span>
                <div class="producto-card__actions">
                    <a href="#" class="btn-sm">Editar</a>
                    <a href="#" class="btn-sm-outline">Variantes</a>
                </div>
            </div>
        </div>
        <div class="producto-card">
            <div class="producto-card__img"></div>
            <div class="producto-card__body">
                <small style="font-size:11px;color:var(--texto-suave)">Clasicos</small>
                <h3>Chocoflan de Fresas</h3>
                <p>Combinacion de flan y chocolate con fresas.</p>
                <span class="precio">$15.00</span>
                <div class="producto-card__actions">
                    <a href="#" class="btn-sm">Editar</a>
                    <a href="#" class="btn-sm-outline">Variantes</a>
                </div>
            </div>
        </div>
    </div>
</main>
<%@ include file="/jsp/layouts/footer.jsp" %>
</body>
</html>
