<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%
    /*  LOGIN.JSP
       - Si llega un POST: valida credenciales, crea sesion y redirige
       - Si llega un GET: muestra el formulario */

    String error = null;

    if ("POST".equals(request.getMethod())) {

        String usuario    = request.getParameter("usuario");    // correo o whatsapp
        String contrasena = request.getParameter("contrasena");

        // Validacion basica
        if (usuario == null || usuario.trim().isEmpty() ||
            contrasena == null || contrasena.trim().isEmpty()) {
            error = "Por favor completa todos los campos.";

        } else {
            usuario = usuario.trim();

            Connection conn = null;
            try {
                // Conectar a la BD
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                    "jdbc:mysql://127.0.0.1:3306/la_casa_de_mandi?useSSL=false&serverTimezone=America/Panama",
                    "root", ""
                );

                // Determinar si ingreso correo o whatsapp
                boolean esCorreo = usuario.contains("@");

                // 1. Buscar en Administrador (solo por correo)
                if (esCorreo) {
                    PreparedStatement ps = conn.prepareStatement(
                        "SELECT id_admin, nombre, password FROM Administrador WHERE correo = ?"
                    );
                    ps.setString(1, usuario);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
                        String hashGuardado = rs.getString("password");
                        // Comparar contrasena con BCrypt
                        if (org.mindrot.jbcrypt.BCrypt.checkpw(contrasena, hashGuardado)) {
                            // Sesion de admin
                            session.setAttribute("rol", "admin");
                            session.setAttribute("id_admin", rs.getInt("id_admin"));
                            session.setAttribute("nombre", rs.getString("nombre"));
                            response.sendRedirect(request.getContextPath() + "/jsp/admin/dashboard.jsp");
                            return;
                        } else {
                            error = "Contraseña incorrecta.";
                        }
                    }
                    rs.close(); ps.close();
                }

                // 2. Buscar en Cliente (por correo o whatsapp)
                if (error == null) {
                    String columna = esCorreo ? "correo" : "whatsapp";
                    PreparedStatement ps = conn.prepareStatement(
                        "SELECT id_cliente, nombre, password FROM Cliente WHERE " + columna + " = ?"
                    );
                    ps.setString(1, usuario);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
                        String hashGuardado = rs.getString("password");
                        if (org.mindrot.jbcrypt.BCrypt.checkpw(contrasena, hashGuardado)) {
                            // Sesion de cliente
                            session.setAttribute("rol", "cliente");
                            session.setAttribute("id_cliente", rs.getInt("id_cliente"));
                            session.setAttribute("nombre", rs.getString("nombre"));
                            response.sendRedirect(request.getContextPath() + "/jsp/cliente/mis-pedidos.jsp");
                            return;
                        } else {
                            error = "Contraseña incorrecta.";
                        }
                    } else if (error == null) {
                        error = "No encontramos una cuenta con ese correo o WhatsApp.";
                    }
                    rs.close(); ps.close();
                }

            } catch (Exception e) {
                error = "Error de conexion. Verifica que MySQL este activo.";
                e.printStackTrace();
            } finally {
                if (conn != null) try { conn.close(); } catch (Exception ignored) {}
            }
        }
    }
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

        /* Panel izquierdo decorativo */
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

        /* Panel derecho: formulario */
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
    </style>
</head>
<body>

<div class="login-wrap">

    <!-- Panel izquierdo -->
    <div class="login-lateral">
        <h2>Artesanía en cada detalle.</h2>
        <p>Redescubre el sabor de lo auténtico. Cada pieza es una obra maestra de la repostería panameña.</p>
    </div>

    <!-- Panel derecho -->
    <div class="login-panel">
        <h1>Iniciar sesión</h1>
        <p class="sub">¿No tienes cuenta? <a href="${pageContext.request.contextPath}/jsp/publico/registro.jsp">Regístrate</a></p>

        <!-- Mensaje de error -->
        <% if (error != null) { %>
            <div class="alerta-error"><%= error %></div>
        <% } %>

        <!-- El formulario apunta a si mismo (POST al mismo login.jsp) -->
        <form action="${pageContext.request.contextPath}/login.jsp" method="POST" novalidate>

            <div class="campo">
                <label for="usuario">Correo electrónico o WhatsApp</label>
                <input type="text" id="usuario" name="usuario"
                       placeholder="ejemplo@correo.com o +507 6000-0000"
                       value="<%= request.getParameter("usuario") != null ? request.getParameter("usuario") : "" %>"
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
