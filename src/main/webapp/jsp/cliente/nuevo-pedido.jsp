<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Cliente - Nuevo Pedido --%>
<%
    String rol3 = (String) session.getAttribute("rol");
    if (!"cliente".equals(rol3)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nuevo Pedido — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        .panel-hero { padding: 48px 64px 24px; }
        .panel-hero h1 { font-family: var(--titulo); font-size: 36px; font-weight: 700; }
        .formulario-pedido { padding: 0 64px 64px; display: grid; grid-template-columns: 1fr 1fr; gap: 48px; }
        .form-card {
            background: #fff; border: 1px solid var(--borde); border-radius: 12px; padding: 32px;
        }
        .form-card h2 { font-family: var(--titulo); font-size: 20px; margin-bottom: 24px; }
        .form-card .campo { margin-bottom: 20px; }
        .form-card .campo label { display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; }
        .form-card .campo input,
        .form-card .campo select,
        .form-card .campo textarea {
            width: 100%; padding: 12px 16px; border: 1px solid var(--borde); border-radius: 8px;
            font-family: var(--cuerpo); font-size: 15px; outline: none; transition: border-color 0.15s;
        }
        .form-card .campo input:focus,
        .form-card .campo select:focus,
        .form-card .campo textarea:focus { border-color: var(--primario); }
        .form-card .campo textarea { min-height: 80px; resize: vertical; }
        .resumen { padding: 24px; background: var(--fondo-alt); border-radius: 12px; }
        .resumen h3 { font-family: var(--titulo); font-size: 18px; margin-bottom: 16px; }
        .resumen-fila { display: flex; justify-content: space-between; font-size: 14px; margin-bottom: 12px; }
        .resumen-fila.total { font-size: 16px; font-weight: 700; border-top: 1px solid var(--borde); padding-top: 12px; margin-top: 12px; }
        .btn-enviar { display: block; width: 100%; padding: 14px; background: var(--primario); color: #fff; border: none; border-radius: 999px; font-size: 15px; font-weight: 600; cursor: pointer; margin-top: 24px; }
        .btn-enviar:hover { background: var(--primario-dark); }
        .info-box {
            background: #fde8e8; border: 1px solid #f5a5a5; border-radius: 8px;
            padding: 16px; margin-bottom: 24px; font-size: 14px; color: #8b1a1a;
        }
    </style>
</head>
<body>
<% request.setAttribute("paginaActiva", "pedidos"); %>
<%@ include file="/jsp/layouts/header.jsp" %>
<main>
    <section class="panel-hero">
        <span class="etiqueta">Panel del Cliente</span>
        <h1>Nuevo Pedido</h1>
        <p style="color:var(--texto-suave);">Completa el formulario para realizar tu pedido personalizado.</p>
    </section>
    <div class="formulario-pedido">
        <div class="form-card">
            <h2>Datos del pedido</h2>
            <form action="#" method="POST">
                <div class="campo">
                    <label for="producto">Producto</label>
                    <select id="producto" name="producto">
                        <option value="">Selecciona un producto</option>
                        <option value="tres-leches">Delicia Tres Leches Frutal</option>
                        <option value="cheesecake-maracuya">Cheesecake Tropical de Maracuya</option>
                        <option value="fresas-crema">Fresas &amp; Crema</option>
                        <option value="chocoflan">Chocoflan de Fresas</option>
                        <option value="melocoton">Melocoton &amp; Crema</option>
                        <option value="frutos-bosque">Cheesecake Frutos del Bosque</option>
                    </select>
                </div>
                <div class="campo">
                    <label for="variante">Variante / Tamano</label>
                    <select id="variante" name="variante">
                        <option value="">Selecciona una variante</option>
                        <option value="mini">Mini (2-3 porciones)</option>
                        <option value="medio">Medio (8-10 porciones)</option>
                        <option value="grande">Grande (16-20 porciones)</option>
                    </select>
                </div>
                <div class="campo">
                    <label for="cantidad">Cantidad</label>
                    <input type="number" id="cantidad" name="cantidad" min="1" value="1" required>
                </div>
                <div class="campo">
                    <label for="descripcion">Descripcion del diseno / personalizacion</label>
                    <textarea id="descripcion" name="descripcion" placeholder="Ej: Decorar con fresas frescas, mensaje Happy Birthday..."></textarea>
                </div>
                <div class="campo">
                    <label for="fecha">Fecha de entrega</label>
                    <input type="date" id="fecha" name="fecha" required>
                </div>
                <div class="info-box">
                    <strong>Abono requerido:</strong> 50% del precio total para confirmar tu pedido.
                </div>
                <button type="submit" class="btn-enviar">Enviar pedido</button>
            </form>
        </div>
        <div>
            <div class="resumen">
                <h3>Resumen</h3>
                <div class="resumen-fila"><span>Producto</span><span>--</span></div>
                <div class="resumen-fila"><span>Variante</span><span>--</span></div>
                <div class="resumen-fila"><span>Cantidad</span><span>--</span></div>
                <div class="resumen-fila total"><span>Precio estimado</span><span>$0.00</span></div>
            </div>
        </div>
    </div>
</main>
<%@ include file="/jsp/layouts/footer.jsp" %>
</body>
</html>
