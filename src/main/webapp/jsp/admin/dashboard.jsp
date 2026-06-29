<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.PedidoDAO, java.util.List, modelo.Pedido" %>
<%
    String rol = (String) session.getAttribute("rol");
    if (!"admin".equals(rol)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    PedidoDAO pedidoDAO  = new PedidoDAO();
    int pendientes       = pedidoDAO.contarPorEstado("Pendiente");
    int enProduccion     = pedidoDAO.contarPorEstado("En produccion");
    int listos           = pedidoDAO.contarPorEstado("Listo");
    int entregados       = pedidoDAO.contarPorEstado("Entregado");

    // Últimos 10 pedidos sin filtro
    List<Pedido> recientes = pedidoDAO.listarTodos(null);
    List<Pedido> ultimos   = recientes.size() > 10 ? recientes.subList(0, 10) : recientes;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Administrador — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        .admin-header { padding:48px 64px 24px; }
        .admin-header h1 { font-family:var(--titulo); font-size:36px; font-weight:700; }

        .stats-grid {
            display:grid; grid-template-columns:repeat(4,1fr);
            gap:24px; padding:0 64px 40px;
        }
        .stat-card {
            background:#fff; border:1px solid var(--borde);
            border-radius:12px; padding:24px; text-align:center;
        }
        .stat-card h3 {
            font-size:12px; color:var(--texto-suave); margin-bottom:8px;
            text-transform:uppercase; letter-spacing:0.05em;
        }
        .stat-card .num {
            font-family:var(--titulo); font-size:40px;
            font-weight:700; color:var(--primario);
        }
        .stat-card.verde .num { color:#16a34a; }
        .stat-card.azul  .num { color:#1d4ed8; }
        .stat-card.naranja .num { color:#ea580c; }

        .quick-links { padding:0 64px 40px; }
        .quick-links-grid { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; }
        .quick-link {
            display:block; padding:20px; background:#fff; border:1px solid var(--borde);
            border-radius:12px; text-align:center; text-decoration:none; color:var(--texto);
            transition:box-shadow 0.15s, transform 0.15s;
        }
        .quick-link:hover {
            box-shadow:0 4px 12px rgba(0,0,0,0.06);
            transform:translateY(-2px); text-decoration:none;
        }
        .quick-link .icon { font-size:32px; margin-bottom:8px; display:block; }
        .quick-link span  { font-size:14px; font-weight:600; }

        .admin-section { padding:0 64px 64px; }
        .admin-section h2 { font-family:var(--titulo); font-size:22px; margin-bottom:20px; }

        .table-wrap {
            background:#fff; border:1px solid var(--borde);
            border-radius:12px; overflow:hidden;
        }
        table { width:100%; border-collapse:collapse; font-size:14px; }
        th, td { padding:14px 20px; text-align:left; border-bottom:1px solid var(--borde); }
        th {
            font-weight:600; background:var(--fondo-alt);
            color:var(--texto-suave); font-size:12px;
            text-transform:uppercase; letter-spacing:0.05em;
        }
        tr:last-child td { border-bottom:none; }
        tr:hover td { background:#fafafa; }

        .btn-sm {
            padding:6px 14px; font-size:12px; border-radius:999px;
            background:var(--primario); color:#fff; text-decoration:none;
        }
        .btn-sm:hover { background:var(--primario-dark); text-decoration:none; }

        .logout-link {
            font-size:14px; color:var(--texto-suave);
        }
        .logout-link:hover { color:var(--primario); }
    </style>
</head>
<body>
<% request.setAttribute("paginaActiva", "inicio"); %>
<%@ include file="/jsp/layouts/header.jsp" %>

<main>
    <section class="admin-header">
        <span class="etiqueta">Panel Administrador</span>
        <h1>Dashboard</h1>
        <p style="color:var(--texto-suave);">
            Bienvenido, <strong><%= session.getAttribute("nombre") %></strong>.
            <a href="${pageContext.request.contextPath}/logout" class="logout-link" style="margin-left:12px;">Cerrar sesión</a>
        </p>
    </section>

    <div class="stats-grid">
        <div class="stat-card">
            <h3>Pendientes</h3>
            <div class="num"><%= pendientes %></div>
        </div>
        <div class="stat-card naranja">
            <h3>En Producción</h3>
            <div class="num"><%= enProduccion %></div>
        </div>
        <div class="stat-card azul">
            <h3>Listos para entrega</h3>
            <div class="num"><%= listos %></div>
        </div>
        <div class="stat-card verde">
            <h3>Entregados</h3>
            <div class="num"><%= entregados %></div>
        </div>
    </div>

    <div class="quick-links">
        <div class="quick-links-grid">
            <a href="${pageContext.request.contextPath}/jsp/admin/pedidos.jsp" class="quick-link">
                <span class="icon">📦</span><span>Gestionar Pedidos</span>
            </a>
            <a href="${pageContext.request.contextPath}/jsp/admin/productos.jsp" class="quick-link">
                <span class="icon">🧁</span><span>Productos</span>
            </a>
            <a href="${pageContext.request.contextPath}/jsp/admin/clientes.jsp" class="quick-link">
                <span class="icon">👥</span><span>Clientes</span>
            </a>
            <a href="${pageContext.request.contextPath}/jsp/admin/capacidad.jsp" class="quick-link">
                <span class="icon">📅</span><span>Capacidad</span>
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
                        <th>Entrega</th>
                        <th>Estado</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                <% if (ultimos.isEmpty()) { %>
                    <tr><td colspan="6" style="text-align:center;color:var(--texto-suave);padding:32px;">No hay pedidos aún.</td></tr>
                <% } else {
                    for (Pedido p : ultimos) {
                        String bc = "badge-" + p.getEstado().toLowerCase()
                            .replace(" ", "").replace("ó","o").replace("ú","u").replace("é","e");
                %>
                    <tr>
                        <td>#<%= p.getIdPedido() %></td>
                        <td><%= p.getNombreCliente() != null ? p.getNombreCliente() : "—" %></td>
                        <td><%= p.getNombreProducto() %> / <%= p.getTamanoVariante() %></td>
                        <td><%= p.getFechaEntrega() %></td>
                        <td><span class="badge <%= bc %>"><%= p.getEstado() %></span></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/jsp/admin/pedidos.jsp?id=<%= p.getIdPedido() %>"
                               class="btn-sm">Ver</a>
                        </td>
                    </tr>
                <% } } %>
                </tbody>
            </table>
        </div>
    </section>
</main>

<%@ include file="/jsp/layouts/footer.jsp" %>
</body>
</html>
