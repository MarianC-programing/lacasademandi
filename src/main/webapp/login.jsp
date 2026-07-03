<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String error   = request.getAttribute("error")   != null ? (String) request.getAttribute("error")   : null;
    String usuario = request.getAttribute("usuario") != null ? (String) request.getAttribute("usuario") : "";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        body { display: flex; min-height: 100vh; align-items: center; justify-content: center; background: var(--fondo-alt); }

        .login-wrap {
            display: grid;
            grid-template-columns: 1fr 1fr;
            width: 900px;
            max-width: 95vw;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 40px rgba(0,0,0,0.12);
        }

        .login-lateral {
            background: var(--primario);
            padding: 48px 40px;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
        }
        .login-lateral h2 {
            font-family: var(--titulo);
            font-style: italic;
            font-size: 32px;
            color: #fff;
            line-height: 1.3;
            margin-bottom: 12px;
        }
        .login-lateral p {
            font-size: 14px;
            color: rgba(255,255,255,0.8);
            line-height: 22px;
        }

        .login-panel {
            background: #fff;
            padding: 48px 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .login-panel h1 {
            font-family: var(--titulo);
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 6px;
        }
        .login-panel .sub {
            font-size: 14px;
            color: var(--texto-suave);
            margin-bottom: 32px;
        }
        .login-panel .sub a { color: var(--primario); }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background: var(--primario);
            color: #fff;
            border: none;
            border-radius: 999px;
            font-family: var(--cuerpo);
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 8px;
            transition: background 0.15s;
        }
        .btn-submit:hover { background: var(--primario-dark); }

        .login-footer-links {
            text-align: center;
            margin-top: 20px;
            font-size: 13px;
            color: var(--texto-suave);
        }
        .login-footer-links a { color: var(--primario); }

        .btn-home {
            position: absolute;
            top: 24px;
            left: 24px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            font-weight: 600;
            color: var(--texto-suave);
            background: #fff;
            padding: 8px 14px;
            border-radius: 999px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            text-decoration: none;
            z-index: 10;
        }
        .btn-home:hover { color: var(--primario); text-decoration: none; }
    </style>
</head>
<body>

<a href="${pageContext.request.contextPath}/index.jsp" class="btn-home">← Inicio</a>

<div class="login-wrap">

    <div class="login-lateral">
        <h2>Artesanía en cada detalle.</h2>
        <p>Redescubre el sabor de lo auténtico. Cada pieza es una obra maestra de la repostería panameña.</p>
    </div>

    <div class="login-panel">
        <h1>Iniciar sesión</h1>
        <p class="sub">¿No tienes cuenta? <a href="${pageContext.request.contextPath}/registro">Regístrate</a></p>

        <% if (error != null) { %>
            <div class="alerta-error"><%= error %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login" method="POST" novalidate>

            <div class="campo">
                <label for="usuario">Correo electrónico o WhatsApp</label>
                <input type="text" id="usuario" name="usuario"
                       placeholder="ejemplo@correo.com o +507 6000-0000"
                       value="<%= usuario %>"
                       required autocomplete="username" autofocus>
            </div>

            <div class="campo">
                <label for="contrasena">Contraseña</label>
                <input type="password" id="contrasena" name="contrasena"
                       placeholder="••••••••" required autocomplete="current-password">
            </div>

            <button type="submit" class="btn-submit">Acceder</button>
        </form>

        <div class="login-footer-links">
            <a href="#">¿Olvidaste tu contraseña?</a>
        </div>
    </div>

</div>

</body>
</html>
