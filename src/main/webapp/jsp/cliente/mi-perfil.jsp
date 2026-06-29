<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.ClienteDAO, modelo.Cliente" %>
<%
    String rol = (String) session.getAttribute("rol");
    if (!"cliente".equals(rol)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    int idCliente = (int) session.getAttribute("id_cliente");
    Cliente cliente = new ClienteDAO().buscarPorId(idCliente);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        .panel-hero { padding:48px 64px 24px; }
        .panel-hero h1 { font-family:var(--titulo); font-size:36px; font-weight:700; }

        .perfil-content {
            padding:0 64px 64px;
            display:grid; grid-template-columns:1fr 300px; gap:48px; align-items:start;
        }
        .form-card {
            background:#fff; border:1px solid var(--borde);
            border-radius:12px; padding:32px;
        }
        .form-card h2 { font-family:var(--titulo); font-size:20px; margin-bottom:24px; }

        .grid-2 { display:grid; grid-template-columns:1fr 1fr; gap:0 16px; }

        .sidebar-info {
            padding:24px; background:var(--fondo-alt); border-radius:12px;
            position:sticky; top:80px;
        }
        .sidebar-info h3 { font-family:var(--titulo); font-size:18px; margin-bottom:14px; }
        .sidebar-info p  { font-size:14px; color:var(--texto-suave); line-height:22px; margin-bottom:10px; }

        .alerta-exito {
            background:#d1fae5; border:1px solid #6ee7b7; border-radius:8px;
            padding:12px 16px; color:#065f46; font-size:14px; margin-bottom:20px;
        }
        .btn-guardar {
            display:inline-block; padding:12px 32px; background:var(--primario); color:#fff;
            border:none; border-radius:999px; font-size:15px; font-weight:600;
            cursor:pointer; transition:background 0.15s;
        }
        .btn-guardar:hover { background:var(--primario-dark); }
    </style>
</head>
<body>
<% request.setAttribute("paginaActiva", "pedidos"); %>
<%@ include file="/jsp/layouts/header.jsp" %>

<main>
    <section class="panel-hero">
        <span class="etiqueta">Panel del Cliente</span>
        <h1>Mi Perfil</h1>
        <p style="color:var(--texto-suave);">Actualiza tus datos de contacto.</p>
    </section>

    <div class="perfil-content">
        <div class="form-card">
            <h2>Información personal</h2>

            <% if ("1".equals(request.getParameter("ok"))) { %>
                <div class="alerta-exito">✅ Tus datos se guardaron correctamente.</div>
            <% } %>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alerta-error"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/perfil" method="POST">

                <div class="campo">
                    <label for="nombre">Nombre completo</label>
                    <input type="text" id="nombre" name="nombre"
                           value="<%= cliente != null ? cliente.getNombre() : "" %>"
                           required>
                </div>

                <div class="campo">
                    <label for="correo">Correo electrónico</label>
                    <input type="email" id="correo" name="correo"
                           value="<%= cliente != null ? cliente.getCorreo() : "" %>"
                           required autocomplete="email">
                </div>

                <div class="grid-2">
                    <div class="campo">
                        <label for="telefono">Teléfono</label>
                        <input type="tel" id="telefono" name="telefono"
                               value="<%= cliente != null ? cliente.getTelefono() : "" %>"
                               required>
                    </div>
                    <div class="campo">
                        <label for="whatsapp">WhatsApp</label>
                        <input type="tel" id="whatsapp" name="whatsapp"
                               value="<%= cliente != null ? cliente.getWhatsapp() : "" %>"
                               required>
                    </div>
                </div>

                <div style="display:flex; gap:12px; align-items:center; margin-top:8px;">
                    <button type="submit" class="btn-guardar">Guardar cambios</button>
                    <a href="${pageContext.request.contextPath}/jsp/cliente/mis-pedidos.jsp"
                       class="btn btn-outline">Volver</a>
                </div>
            </form>
        </div>

        <div class="sidebar-info">
            <h3>Consejos</h3>
            <p>Mantén tu número de WhatsApp actualizado para recibir notificaciones sobre el estado de tus pedidos.</p>
            <p>Tu correo electrónico es tu método principal de acceso al sistema.</p>
            <p>Si necesitas cambiar tu contraseña, contacta al equipo de La Casa de Mandi.</p>
        </div>
    </div>
</main>

<%@ include file="/jsp/layouts/footer.jsp" %>
</body>
</html>
