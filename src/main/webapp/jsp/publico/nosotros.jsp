<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sobre Nosotros — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        /* ── Hero ── */
        .nosotros-hero {
            text-align: center;
            padding: 80px 64px 24px;
        }
        .nosotros-hero h1 {
            font-family: var(--titulo);
            font-size: 52px;
            font-weight: 700;
            margin: 12px 0 24px;
        }
        .nosotros-hero .divisor {
            width: 48px;
            height: 2px;
            background: var(--primario);
            margin: 0 auto 28px;
        }
        .nosotros-hero p {
            color: var(--texto-suave);
            max-width: 580px;
            margin: 0 auto;
            font-size: 16px;
            line-height: 28px;
        }

        /* ── Equipo ── */
        .equipo {
            padding: 72px 64px;
            text-align: center;
        }
        .equipo h2 {
            font-family: var(--titulo);
            font-size: 40px;
            font-weight: 700;
            margin-bottom: 8px;
        }
        .equipo__sub {
            color: var(--texto-suave);
            margin-bottom: 48px;
            font-size: 15px;
        }
        .equipo-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 28px;
        }
        .miembro {
            text-align: center;
        }
        .miembro__foto {
            width: 100%;
            aspect-ratio: 3/4;
            border-radius: 12px;
            overflow: hidden;
            background: var(--fondo-alt);
            margin-bottom: 16px;
        }
        .miembro__foto img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: top;
            display: block;
        }
        .miembro__carrera {
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--primario);
            margin-bottom: 6px;
        }
        .miembro__nombre {
            font-family: var(--titulo);
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 4px;
        }
        .miembro__cedula {
            font-size: 12px;
            color: var(--texto-suave);
            margin-bottom: 10px;
        }
        .miembro__desc {
            font-size: 13px;
            color: var(--texto-suave);
            line-height: 20px;
        }

        /* ── CTA ── */
        .cta-nosotros {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 56px 64px;
            background: var(--fondo-alt);
        }
        .cta-nosotros__texto h2 {
            font-family: var(--titulo);
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 8px;
        }
        .cta-nosotros__texto p {
            color: var(--texto-suave);
            font-size: 15px;
        }
        .cta-nosotros__botones {
            display: flex;
            gap: 12px;
            flex-shrink: 0;
        }
        .btn-outline {
            padding: 12px 24px;
            border-radius: 8px;
            border: 2px solid var(--primario);
            color: var(--primario);
            font-family: var(--cuerpo);
            font-weight: 600;
            font-size: 15px;
            text-decoration: none;
            transition: background 0.15s, color 0.15s;
        }
        .btn-outline:hover {
            background: var(--primario);
            color: #fff;
        }
    </style>
</head>
<body>

<% request.setAttribute("paginaActiva", "nosotros"); %>
<%@ include file="/jsp/layouts/header.jsp" %>

<main>

    <%-- ── HERO ── --%>
    <section class="nosotros-hero">
        <span class="etiqueta">Nuestra Historia</span>
        <h1>Tradición y Pasión en Cada Bocado</h1>
        <div class="divisor"></div>
        <p>Nacimos del deseo de compartir el calor de un hogar panameño a través de la repostería artesanal. En La Casa de Mandi, cada ingrediente es seleccionado con rigor técnico y amor casero, fusionando la precisión de la ingeniería con la dulzura de la tradición.</p>
    </section>

    <%-- ── EQUIPO ── --%>
    <section class="equipo">
        <h2>Nuestro Equipo</h2>
        <p class="equipo__sub">El talento detrás de la innovación y el sabor.</p>

        <div class="equipo-grid">

            <div class="miembro">
                <div class="miembro__foto">
                    <img src="${pageContext.request.contextPath}/img/MarianBarba.jpeg"
                         alt="Marian Barba" onerror="this.style.display='none'">
                </div>
                <p class="miembro__carrera">Lic. Ingeniería de Software</p>
                <h3 class="miembro__nombre">Marian Barba</h3>
                <p class="miembro__cedula">8-1012-213</p>
                <p class="miembro__desc">Líder de desarrollo y arquitectura de soluciones, enfocada en la optimización de procesos digitales para la gestión de pedidos artesanales.</p>
            </div>

            <div class="miembro">
                <div class="miembro__foto">
                    <img src="${pageContext.request.contextPath}/img/GabrielaFuentes.jpeg"
                         alt="Gabriela Fuentes" onerror="this.style.display='none'">
                </div>
                <p class="miembro__carrera">Lic. Ingeniería de Software</p>
                <h3 class="miembro__nombre">Gabriela Fuentes</h3>
                <p class="miembro__cedula">8-1042-245</p>
                <p class="miembro__desc">Especialista en experiencia de usuario y diseño de interfaces intuitivas que conectan la calidez de lo casero con la facilidad de lo digital.</p>
            </div>

            <div class="miembro">
                <div class="miembro__foto">
                    <img src="${pageContext.request.contextPath}/img/LauraOrellana.jpeg"
                         alt="Laura Orellana" onerror="this.style.display='none'">
                </div>
                <p class="miembro__carrera">Lic. Ingeniería de Software</p>
                <h3 class="miembro__nombre">Laura Orellana</h3>
                <p class="miembro__cedula">E-8-221893</p>
                <p class="miembro__desc">Encargada de la lógica de negocio y escalabilidad del sistema, garantizando que cada transacción sea tan fluida como nuestra crema pastelera.</p>
            </div>

            <div class="miembro">
                <div class="miembro__foto">
                    <img src="${pageContext.request.contextPath}/img/EvelinPineda.jpeg"
                         alt="Evelin Pineda" onerror="this.style.display='none'">
                </div>
                <p class="miembro__carrera">Lic. Ingeniería de Software</p>
                <h3 class="miembro__nombre">Evelin Pineda</h3>
                <p class="miembro__cedula">8-1031-1126</p>
                <p class="miembro__desc">Responsable de control de calidad y pruebas integrales, asegurando la robustez tecnológica de nuestra plataforma de ventas.</p>
            </div>

        </div>
    </section>

    <%-- ── CTA FINAL ── --%>
    <section class="cta-nosotros">
        <div class="cta-nosotros__texto">
            <h2>¿Listo para probar la tradición?</h2>
            <p>Descubre nuestra selección de dulces caseros hoy mismo.</p>
        </div>
        <div class="cta-nosotros__botones">
            <a href="${pageContext.request.contextPath}/jsp/publico/catalogo.jsp" class="btn btn-primario">Ver Catálogo</a>
        </div>
    </section>

</main>

<%@ include file="/jsp/layouts/footer.jsp" %>

</body>
</html>
