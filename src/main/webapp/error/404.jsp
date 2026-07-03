<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página no encontrada — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        body {
            display: flex; min-height: 100vh; align-items: center; justify-content: center;
            background: var(--fondo-alt); text-align: center; padding: 24px;
        }
        .error-wrap { max-width: 460px; }
        .error-codigo {
            font-family: var(--titulo); font-style: italic; font-size: 96px;
            font-weight: 700; color: var(--primario); line-height: 1;
        }
        .error-wrap h1 { font-family: var(--titulo); font-size: 26px; font-weight: 700; margin: 12px 0 8px; }
        .error-wrap p { color: var(--texto-suave); font-size: 15px; line-height: 22px; margin-bottom: 28px; }
        .error-acciones { display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; }
    </style>
</head>
<body>
    <div class="error-wrap">
        <div class="error-codigo">404</div>
        <h1>Esta página no existe</h1>
        <p>Puede que el enlace esté roto o que la página se haya movido. Volvamos a un lugar conocido.</p>
        <div class="error-acciones">
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primario">Ir al inicio</a>
            <a href="${pageContext.request.contextPath}/jsp/publico/catalogo.jsp" class="btn btn-outline">Ver catálogo</a>
        </div>
    </div>
</body>
</html>
