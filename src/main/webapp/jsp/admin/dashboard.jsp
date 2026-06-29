<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Admin - Dashboard / Panel de Control --%>
<%
    Object admin = session.getAttribute("admin");
    String rol5 = (String) session.getAttribute("rol");
    if (!"admin".equals(rol5)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Administrador — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        .admin-header { padding: 48px 64px 24px; }
        .admin-header h1 { font-family: var(--titulo); font-size: 36px; font-weight: 700; }
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 24px; padding: 0 64px 40px; }
        .stat-card {
            background: #fff; border: 1px solid var(--borde); border-radius: 12px;
            padding: 24px; text-align: center;
        }
        .stat-card h3 { font-size: 14px; color: var(--texto-suave); margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.05em; }
        .stat-card .stat-num { font-family: var(--titulo); font-size: 36px; font-weight: 700; color: var(--primario); }
        .admin-section { padding: 0 64px 64px; }
        .admin-section h2 { font-family: var(--titulo); font-size: 24px; margin-bottom: 24px; }
        .table-wrap {
            background: #fff; border: 1px solid var(--borde); border-radius: 12px; overflow: hidden;
        }
        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        th, td { padding: 14px 20px; text-align: left; border-bottom: 1px solid var(--borde); }
        th { font-weight: 600; background: var(--fondo-alt); color: var(--texto-suave); font-size: 12px; text-transform: uppercase; letter-spacing: 0.05em; }
        tr:hover td { background: #fafafa; }
        .btn-sm { padding: 6px 14px; font-size: 12px; border-radius: 999px; background: var(--primario); color: #fff; text-decoration: none; }
        .btn-sm:hover { background: var(--primario-dark); text-decoration: none; }
        .quick-links { padding: 0 64px 40px; }
        .quick-links-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; }
        .quick-link {
            display: block; padding: 20px; background: #fff; border: 1px solid var(--borde);
            border-radius: 12px; text-align: center; text-decoration: none; color: var(--texto);
            transition: box-shadow 0.15s, transform 0.15s;
        }
        .quick-link:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.06); transform: translateY(-2px); text-decoration: none; }
        .quick-link .icon { font-size: 32px; margin-bottom: 8px; display: block; }
        .quick-link span { font-size: 14px; font-weight: 600; }
    </style>
</head>
<body>
<% request.setAttribute("paginaActiva", "inicio"); %>
<%@ include file="/jsp/layouts/header.jsp" %>
<main>
    <section class="admin-header">
        <span class="etiqueta">Panel Administrador</span>
        <h1>Dashboard</h1>
        <p style="color:var(--texto-suave);">Resumen general del negocio.</p>
    </section>

    <div class="stats-grid">
        <div class="stat-card">
            <h3>Pedidos Pendientes</h3>
            <div class="stat-num">12</div>
        </div>
        <div class="stat-card">
            <h3>Pedidos en Produccion</h3>
            <div class="stat-num">5</div>
        </div>
        <div class="stat-card">
            <h3>Pedidos del Mes</h3>
            <div class="stat-num">48</div>
        </div>
        <div class="stat-card">
            <h3>Ingresos del Mes</h3>
            <div class="stat-num">$842</div>
        </div>
    </div>

    <div class="quick-links">
        <div class="quick-links-grid">
            <a href="${pageContext.request.contextPath}/jsp/admin/pedidos.jsp" class="quick-link">
                <span class="icon">📦</span>
                <span>Gestionar Pedidos</span>
            </a>
            <a href="${pageContext.request.contextPath}/jsp/admin/productos.jsp" class="quick-link">
                <span class="icon">🧁</span>
                <span>Productos</span>
            </a>
            <a href="${pageContext.request.contextPath}/jsp/admin/clientes.jsp" class="quick-link">
                <span class="icon">👥</span>
                <span>Clientes</span>
            </a>
            <a href="${pageContext.request.contextPath}/jsp/admin/capacidad.jsp" class="quick-link">
                <span class="icon">📅</span>
                <span>Capacidad</span>
            </a>
        </div>
    </div>

    <section class="admin-section">
        <h2>Pedidos recientes</h2>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Cliente</th>
                        <th>Producto</th>
                        <th>Fecha Entrega</th>
                        <th>Estado</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>#1020</td>
                        <td>Maria Gonzalez</td>
                        <td>Tres Leches Frutal</td>
                        <td>30 de julio</td>
                        <td><span class="badge badge-pendiente">Pendiente</span></td>
                        <td><a href="#" class="btn-sm">Ver</a></td>
                    </tr>
                    <tr>
                        <td>#1019</td>
                        <td>Juan Perez</td>
                        <td>Cheesecake Maracuya</td>
                        <td>28 de julio</td>
                        <td><span class="badge badge-produccion">Produccion</span></td>
                        <td><a href="#" class="btn-sm">Ver</a></td>
                    </tr>
                    <tr>
                        <td>#1018</td>
                        <td>Ana Rodriguez</td>
                        <td>Chocoflan de Fresas</td>
                        <td>26 de julio</td>
                        <td><span class="badge badge-listo">Listo</span></td>
                        <td><a href="#" class="btn-sm">Ver</a></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </section>
</main>
<%@ include file="/jsp/layouts/footer.jsp" %>
</body>
</html>
