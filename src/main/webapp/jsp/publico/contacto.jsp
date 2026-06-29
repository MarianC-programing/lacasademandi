<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contacto — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        .contacto-hero {
            text-align: center;
            padding: 80px 64px 48px;
        }
        .contacto-hero h1 {
            font-family: var(--titulo);
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 16px;
        }
        .contacto-hero p {
            color: var(--texto-suave);
            max-width: 500px;
            margin: 0 auto;
            font-size: 17px;
            line-height: 28px;
        }
        .contacto-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 64px;
            padding: 0 64px 64px;
            align-items: start;
        }
        .contacto-info h2 {
            font-family: var(--titulo);
            font-size: 28px;
            margin-bottom: 24px;
        }
        .contacto-info p {
            color: var(--texto-suave);
            line-height: 26px;
            margin-bottom: 24px;
        }
        .dato-contacto {
            display: flex;
            align-items: flex-start;
            gap: 16px;
            margin-bottom: 20px;
        }
        .dato-contacto__icono {
            font-size: 24px;
            flex-shrink: 0;
        }
        .dato-contacto__texto h4 {
            font-size: 15px;
            font-weight: 600;
            margin-bottom: 4px;
        }
        .dato-contacto__texto p {
            font-size: 14px;
            color: var(--texto-suave);
            margin: 0;
        }
        .contacto-form {
            background: #fff;
            border: 1px solid var(--borde);
            border-radius: 16px;
            padding: 40px;
        }
        .contacto-form h2 {
            font-family: var(--titulo);
            font-size: 24px;
            margin-bottom: 24px;
        }
        .contacto-form .campo {
            margin-bottom: 20px;
        }
        .contacto-form .campo label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 8px;
        }
        .contacto-form .campo input,
        .contacto-form .campo textarea {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid var(--borde);
            border-radius: 8px;
            font-family: var(--cuerpo);
            font-size: 15px;
            outline: none;
            transition: border-color 0.15s;
        }
        .contacto-form .campo input:focus,
        .contacto-form .campo textarea:focus {
            border-color: var(--primario);
        }
        .contacto-form .campo textarea {
            min-height: 120px;
            resize: vertical;
        }
        .contacto-form .btn-bloque {
            display: block;
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
            transition: background 0.15s;
        }
        .contacto-form .btn-bloque:hover {
            background: var(--primario-dark);
        }
        .mapa-placeholder {
            width: 100%;
            height: 300px;
            background: var(--fondo-alt);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--texto-suave);
            font-size: 14px;
            margin-top: 40px;
        }
    </style>
</head>
<body>

<% request.setAttribute("paginaActiva", "contacto"); %>
<%@ include file="/jsp/layouts/header.jsp" %>

<main>

    <section class="contacto-hero">
        <span class="etiqueta">Estamos para ti</span>
        <h1>Contactanos</h1>
        <p>Tienes dudas, quieres hacer un pedido especial o simplemente saludar? Estamos aqui para escucharte.</p>
    </section>

    <section class="contacto-grid">
        <div class="contacto-info">
            <h2>Informacion de contacto</h2>
            <p>Nos encanta recibir tus mensajes. Ya sea para consultar sobre un producto, cotizar un pastel personalizado o simplemente dejarnos tu opinion.</p>

            <div class="dato-contacto">
                <div class="dato-contacto__icono">📱</div>
                <div class="dato-contacto__texto">
                    <h4>WhatsApp</h4>
                    <p>+507 6***-****</p>
                </div>
            </div>

            <div class="dato-contacto">
                <div class="dato-contacto__icono">📧</div>
                <div class="dato-contacto__texto">
                    <h4>Correo electronico</h4>
                    <p>hola@lacasademandi.com</p>
                </div>
            </div>

            <div class="dato-contacto">
                <div class="dato-contacto__icono">📍</div>
                <div class="dato-contacto__texto">
                    <h4>Direccion</h4>
                    <p>Panama, Ciudad de Panama</p>
                </div>
            </div>

            <div class="dato-contacto">
                <div class="dato-contacto__icono">🕐</div>
                <div class="dato-contacto__texto">
                    <h4>Horario de atencion</h4>
                    <p>Lunes a Sabado: 8:00 AM - 6:00 PM</p>
                </div>
            </div>

            <div class="mapa-placeholder">
                Mapa de ubicacion (integrar con Google Maps)
            </div>
        </div>

        <div class="contacto-form">
            <h2>Envianos un mensaje</h2>
            <form action="#" method="POST">
                <div class="campo">
                    <label for="nombre">Nombre completo</label>
                    <input type="text" id="nombre" name="nombre" required>
                </div>
                <div class="campo">
                    <label for="email">Correo electronico</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="campo">
                    <label for="telefono">Telefono (opcional)</label>
                    <input type="tel" id="telefono" name="telefono">
                </div>
                <div class="campo">
                    <label for="mensaje">Mensaje</label>
                    <textarea id="mensaje" name="mensaje" required></textarea>
                </div>
                <button type="submit" class="btn-bloque">Enviar mensaje</button>
            </form>
        </div>
    </section>

</main>

<%@ include file="/jsp/layouts/footer.jsp" %>

</body>
</html>
