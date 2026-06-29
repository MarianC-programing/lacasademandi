<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sobre Nosotros — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        .hero-nosotros {
            text-align: center;
            padding: 80px 64px 48px;
        }
        .hero-nosotros h1 {
            font-family: var(--titulo);
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 16px;
        }
        .hero-nosotros p {
            color: var(--texto-suave);
            max-width: 600px;
            margin: 0 auto;
            font-size: 17px;
            line-height: 28px;
        }
        .historia {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 48px;
            align-items: center;
            padding: 64px;
        }
        .historia__img {
            width: 100%;
            aspect-ratio: 4/3;
            background: var(--fondo-alt);
            border-radius: 20px;
            overflow: hidden;
        }
        .historia__img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .historia__texto h2 {
            font-family: var(--titulo);
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 20px;
        }
        .historia__texto p {
            color: var(--texto-suave);
            line-height: 28px;
            margin-bottom: 16px;
        }
        .valores {
            padding: 64px;
            background: var(--fondo-alt);
            text-align: center;
        }
        .valores h2 {
            font-family: var(--titulo);
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 40px;
        }
        .valores-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 32px;
        }
        .valor {
            padding: 32px;
            background: #fff;
            border: 1px solid var(--borde);
            border-radius: 16px;
        }
        .valor__icono {
            font-size: 40px;
            margin-bottom: 16px;
        }
        .valor h3 {
            font-family: var(--titulo);
            font-size: 20px;
            margin-bottom: 12px;
        }
        .valor p {
            font-size: 14px;
            color: var(--texto-suave);
            line-height: 22px;
        }
    </style>
</head>
<body>

<% request.setAttribute("paginaActiva", "nosotros"); %>
<%@ include file="/jsp/layouts/header.jsp" %>

<main>

    <section class="hero-nosotros">
        <span class="etiqueta">Nuestra Historia</span>
        <h1>La Casa de Mandi</h1>
        <p>Llevando el sabor de lo casero a tu mesa con ingredientes 100% naturales y recetas tradicionales transmitidas de generacion en generacion.</p>
    </section>

    <section class="historia">
        <div class="historia__img">
            <div style="width:100%;height:100%;background:var(--fondo-alt);"></div>
        </div>
        <div class="historia__texto">
            <h2>Origen Familiar</h2>
            <p>La Casa de Mandi nacio con la idea de compartir el sabor de la reposteria casera que se cocina con amor. Cada receta es un legado familiar que hemos perfeccionado con los anos.</p>
            <p>Utilizamos unicamente ingredientes frescos y naturales, sin conservantes artificiales, para que cada bocado sea una experiencia autentica y memorable.</p>
            <p>Desde hace mas de una decada, nos especializamos en crear momentos dulces para celebraciones, familias y amigos en Panama y sus alrededores.</p>
        </div>
    </section>

    <section class="valores">
        <span class="etiqueta">Lo que nos define</span>
        <h2>Nuestros Valores</h2>
        <div class="valores-grid">
            <div class="valor">
                <div class="valor__icono">🌿</div>
                <h3>Ingredientes Naturales</h3>
                <p>Solo utilizamos ingredientes frescos y 100% naturales. Sin conservantes ni colorantes artificiales en ninguna de nuestras recetas.</p>
            </div>
            <div class="valor">
                <div class="valor__icono">❤️</div>
                <h3>Hecho con Amor</h3>
                <p>Cada pieza es elaborada con dedicacion y carino. No son solo postres, son momentos de felicidad que compartimos contigo.</p>
            </div>
            <div class="valor">
                <div class="valor__icono">📍</div>
                <h3>Origen Panameno</h3>
                <p>Orgullosamente panamenos. Apoyamos a productores locales y traemos los sabores tropicales del pais a cada creacion.</p>
            </div>
        </div>
    </section>

</main>

<%@ include file="/jsp/layouts/footer.jsp" %>

</body>
</html>
