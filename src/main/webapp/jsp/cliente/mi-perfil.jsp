<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Cliente - Mi Perfil --%>
<%
    String rol4 = (String) session.getAttribute("rol");
    if (!"cliente".equals(rol4)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        .panel-hero { padding: 48px 64px 24px; }
        .panel-hero h1 { font-family: var(--titulo); font-size: 36px; font-weight: 700; }
        .perfil-content { padding: 0 64px 64px; display: grid; grid-template-columns: 1fr 300px; gap: 48px; align-items: start; }
        .form-card {
            background: #fff; border: 1px solid var(--borde); border-radius: 12px; padding: 32px;
        }
        .form-card h2 { font-family: var(--titulo); font-size: 20px; margin-bottom: 24px; }
        .form-card .campo { margin-bottom: 20px; }
        .form-card .campo label { display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; }
        .form-card .campo input {
            width: 100%; padding: 12px 16px; border: 1px solid var(--borde); border-radius: 8px;
            font-family: var(--cuerpo); font-size: 15px; outline: none; transition: border-color 0.15s;
        }
        .form-card .campo input:focus { border-color: var(--primario); }
        .btn-guardar { display: inline-block; padding: 12px 32px; background: var(--primario); color: #fff; border: none; border-radius: 999px; font-size: 15px; font-weight: 600; cursor: pointer; }
        .btn-guardar:hover { background: var(--primario-dark); }
        .sidebar-info { padding: 24px; background: var(--fondo-alt); border-radius: 12px; }
        .sidebar-info h3 { font-family: var(--titulo); font-size: 18px; margin-bottom: 16px; }
        .sidebar-info p { font-size: 14px; color: var(--texto-suave); line-height: 22px; margin-bottom: 12px; }
    </style>
</head>
<body>
<% request.setAttribute("paginaActiva", "pedidos"); %>
<%@ include file="/jsp/layouts/header.jsp" %>
<main>
    <section class="panel-hero">
        <span class="etiqueta">Panel del Cliente</span>
        <h1>Mi Perfil</h1>
        <p style="color:var(--texto-suave);">Actualiza tus datos personales.</p>
    </section>
    <div class="perfil-content">
        <div class="form-card">
            <h2>Informacion personal</h2>
            <form action="#" method="POST">
                <div class="campo">
                    <label for="nombre">Nombre completo</label>
                    <input type="text" id="nombre" name="nombre" value="<%= session.getAttribute("nombre") != null ? session.getAttribute("nombre") : "" %>" required>
                </div>
                <div class="campo">
                    <label for="correo">Correo electronico</label>
                    <input type="email" id="correo" name="correo" value="<%= session.getAttribute("correo") != null ? session.getAttribute("correo") : "" %>" required>
                </div>
                <div class="campo">
                    <label for="telefono">Telefono</label>
                    <input type="tel" id="telefono" name="telefono" placeholder="+507 6***-****">
                </div>
                <div class="campo">
                    <label for="whatsapp">WhatsApp</label>
                    <input type="tel" id="whatsapp" name="whatsapp" placeholder="+507 6***-****">
                </div>
                <button type="submit" class="btn-guardar">Guardar cambios</button>
                <a href="${pageContext.request.contextPath}/jsp/cliente/mis-pedidos.jsp" class="btn btn-outline" style="margin-left:12px;">Volver</a>
            </form>
        </div>
        <div class="sidebar-info">
            <h3>Consejos</h3>
            <p>Manten tu numero de WhatsApp actualizado para recibir notificaciones sobre el estado de tus pedidos.</p>
            <p>Tu correo electronico es tu metodo principal de acceso al sistema.</p>
        </div>
    </div>
</main>
<%@ include file="/jsp/layouts/footer.jsp" %>
</body>
</html>
