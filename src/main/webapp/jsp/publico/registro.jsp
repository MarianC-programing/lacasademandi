<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear cuenta — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        body { display:flex; min-height:100vh; align-items:center; justify-content:center; background:var(--fondo-alt); }

        .registro-wrap {
            display: grid;
            grid-template-columns: 1fr 1fr;
            width: 900px;
            max-width: 95vw;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 40px rgba(0,0,0,0.12);
        }

        .registro-lateral {
            background: var(--primario);
            padding: 48px 40px;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
        }
        .registro-lateral h2 {
            font-family: var(--titulo);
            font-style: italic;
            font-size: 28px;
            color: #fff;
            line-height: 1.3;
            margin-bottom: 12px;
        }
        .registro-lateral p { font-size: 14px; color: rgba(255,255,255,0.8); line-height: 22px; }

        .registro-panel {
            background: #fff;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .registro-panel h1 { font-family:var(--titulo); font-size:28px; font-weight:700; margin-bottom:4px; }
        .registro-panel .sub { font-size:14px; color:var(--texto-suave); margin-bottom:24px; }
        .registro-panel .sub a { color:var(--primario); }

        .grid-2 { display:grid; grid-template-columns:1fr 1fr; gap:0 16px; }

        .btn-submit {
            width:100%; padding:13px; background:var(--primario); color:#fff;
            border:none; border-radius:999px; font-family:var(--cuerpo);
            font-size:15px; font-weight:600; cursor:pointer; margin-top:8px; transition:background 0.15s;
        }
        .btn-submit:hover { background:var(--primario-dark); }
    </style>
</head>
<body>

<div class="registro-wrap">

    <div class="registro-lateral">
        <h2>Tu primer pedido, a un paso.</h2>
        <p>Crea tu cuenta en segundos y comienza a disfrutar de la repostería artesanal de La Casa de Mandi.</p>
    </div>

    <div class="registro-panel">
        <h1>Crear cuenta</h1>
        <p class="sub">¿Ya tienes cuenta? <a href="${pageContext.request.contextPath}/login.jsp">Inicia sesión</a></p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alerta-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/registro" method="POST" novalidate>

            <div class="campo">
                <label for="nombre">Nombre completo</label>
                <input type="text" id="nombre" name="nombre"
                       value="<%= request.getAttribute("nombre") != null ? request.getAttribute("nombre") : "" %>"
                       placeholder="Tu nombre" required autofocus>
            </div>

            <div class="grid-2">
                <div class="campo">
                    <label for="telefono">Teléfono</label>
                    <input type="tel" id="telefono" name="telefono"
                           value="<%= request.getAttribute("telefono") != null ? request.getAttribute("telefono") : "" %>"
                           placeholder="6000-0000" required>
                </div>
                <div class="campo">
                    <label for="whatsapp">WhatsApp</label>
                    <input type="tel" id="whatsapp" name="whatsapp"
                           value="<%= request.getAttribute("whatsapp") != null ? request.getAttribute("whatsapp") : "" %>"
                           placeholder="6000-0000" required>
                </div>
            </div>

            <div class="campo">
                <label for="correo">Correo electrónico</label>
                <input type="email" id="correo" name="correo"
                       value="<%= request.getAttribute("correo") != null ? request.getAttribute("correo") : "" %>"
                       placeholder="ejemplo@correo.com" required autocomplete="email">
            </div>

            <div class="grid-2">
                <div class="campo">
                    <label for="password">Contraseña</label>
                    <input type="password" id="password" name="password"
                           placeholder="Mínimo 6 caracteres" required pattern=".{6,}" title="Mínimo 6 caracteres" autocomplete="new-password">
                </div>
                <div class="campo">
                    <label for="password2">Confirmar contraseña</label>
                    <input type="password" id="password2" name="password2"
                           placeholder="Repite la contraseña" required autocomplete="new-password">
                </div>
            </div>

            <button type="submit" class="btn-submit">Crear cuenta</button>
        </form>
    </div>

</div>

</body>
</html>
