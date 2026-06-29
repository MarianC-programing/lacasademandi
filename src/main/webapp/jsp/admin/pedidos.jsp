<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Admin - Gestion de Pedidos --%>
<%
    String rol6 = (String) session.getAttribute("rol");
    if (!"admin".equals(rol6)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion de Pedidos — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        .admin-header { padding: 48px 64px 24px; }
        .admin-header h1 { font-family: var(--titulo); font-size: 36px; font-weight: 700; }
        .filtros { padding: 0 64px 24px; display: flex; gap: 12px; align-items: center; }
        .filtros select, .filtros input {
            padding: 10px 16px; border: 1px solid var(--borde); border-radius: 8px;
            font-family: var(--cuerpo); font-size: 14px;
        }
        .admin-section { padding: 0 64px 64px; }
        .table-wrap {
            background: #fff; border: 1px solid var(--borde); border-radius: 12px; overflow: hidden;
        }
        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        th, td { padding: 14px 20px; text-align: left; border-bottom: 1px solid var(--borde); }
        th { font-weight: 600; background: var(--fondo-alt); color: var(--texto-suave); font-size: 12px; text-transform: uppercase; letter-spacing: 0.05em; }
        tr:hover td { background: #fafafa; }
        .btn-sm { padding: 6px 14px; font-size: 12px; border-radius: 999px; background: var(--primario); color: #fff; text-decoration: none; }
        .btn-sm:hover { background: var(--primario-dark); text-decoration: none; }
    </style>
</head>
<body>
<% request.setAttribute("paginaActiva", "inicio"); %>
<%@ include file="/jsp/layouts/header.jsp" %>
<main>
    <section class="admin-header">
        <span class="etiqueta">Panel Administrador</span>
        <h1>Gestion de Pedidos</h1>
    </section>
    <div class="filtros">
        <select>
            <option value="">Todos los estados</option>
            <option value="pendiente">Pendiente</option>
            <option value="aceptado">Aceptado</option>
            <option value="produccion">En produccion</option>
            <option value="listo">Listo</option>
            <option value="entregado">Entregado</option>
        </select>
        <input type="text" placeholder="Buscar cliente o ID...">
        <button class="btn btn-primario" style="padding: 10px 20px; font-size: 14px;">Filtrar</button>
    </div>
    <div class="admin-section">
        <div class="table-wrap">
            <table>
                <thead>
                    <tr><th>ID</th><th>Cliente</th><th>Producto</th><th>Fecha</th><th>Total</th><th>Estado</th><th></th></tr>
                </thead>
                <tbody>
                    <tr><td>#1025</td><td>Maria G.</td><td>Tres Leches</td><td>01/08/2026</td><td>$35.00</td><td><span class="badge badge-pendiente">Pendiente</span></td><td><a href="#" class="btn-sm">Ver</a></td></tr>
                    <tr><td>#1024</td><td>Carlos M.</td><td>Cheesecake Maracuya</td><td>30/07/2026</td><td>$18.00</td><td><span class="badge badge-aceptado">Aceptado</span></td><td><a href="#" class="btn-sm">Ver</a></td></tr>
                    <tr><td>#1023</td><td>Ana R.</td><td>Chocoflan</td><td>28/07/2026</td><td>$15.00</td><td><span class="badge badge-produccion">Produccion</span></td><td><a href="#" class="btn-sm">Ver</a></td></tr>
                    <tr><td>#1022</td><td>Juan P.</td><td>Frutos del Bosque</td><td>26/07/2026</td><td>$18.00</td><td><span class="badge badge-listo">Listo</span></td><td><a href="#" class="btn-sm">Ver</a></td></tr>
                    <tr><td>#1021</td><td>Lucia S.</td><td>Fresas &amp; Crema</td><td>25/07/2026</td><td>$15.00</td><td><span class="badge badge-entregado">Entregado</span></td><td><a href="#" class="btn-sm">Ver</a></td></tr>
                </tbody>
            </table>
        </div>
    </div>
</main>
<%@ include file="/jsp/layouts/footer.jsp" %>
</body>
</html>
