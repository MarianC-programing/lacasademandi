<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, dao.ProductoDAO, modelo.Producto, modelo.Variante" %>
<%
    List<Producto> destacados = new ProductoDAO().listarTodos();
    if (destacados.size() > 3) destacados = destacados.subList(0, 3);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>La Casa de Mandi — Dulces Hechos con Amor</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        /* Hereproo */
        .hero {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 48px;
            align-items: center;
            padding: 80px 64px;
        }
        .hero h1 {
            font-family: var(--titulo);
            font-size: 56px;
            font-weight: 700;
            line-height: 1.1;
            margin-bottom: 20px;
        }
        .hero p {
            color: var(--texto-suave);
            font-size: 17px;
            line-height: 28px;
            margin-bottom: 32px;
            max-width: 420px;
        }
        .hero__botones { display: flex; gap: 12px; }
        .hero__img {
            width: 100%;
            aspect-ratio: 4/3;
            border-radius: 20px;
            overflow: hidden;
            background: var(--fondo-alt);
        }
        .hero__img img { width: 100%; height: 100%; object-fit: cover; }

        /* ---- Destacados ---- */
        .seccion {
            padding: 64px;
        }
        .seccion--alt {
            background: var(--fondo-alt);
        }
        .seccion__titulo {
            font-family: var(--titulo);
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 8px;
        }
        .seccion__sub {
            color: var(--texto-suave);
            margin-bottom: 40px;
        }
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
        }
        .card-producto {
            background: #fff;
            border: 1px solid var(--borde);
            border-radius: 16px;
            overflow: hidden;
        }
        .card-producto__img {
            width: 100%;
            aspect-ratio: 4/3;
            background: var(--fondo-alt);
            overflow: hidden;
        }
        .card-producto__img img {
            width: 100%; height: 100%; object-fit: cover;
        }
        .card-producto__cuerpo { padding: 20px; }
        .card-producto__cat {
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--texto-suave);
            margin-bottom: 8px;
        }
        .card-producto__nombre {
            font-family: var(--titulo);
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 16px;
        }
        .card-producto__pie {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid var(--borde);
            padding-top: 14px;
            font-size: 14px;
        }
        .precio { color: var(--primario); font-weight: 700; font-size: 16px; }
        .sin-productos { text-align: center; color: var(--texto-suave); padding: 40px; }

        /* ---- Pasos ---- */
        .pasos { display: flex; gap: 48px; justify-content: center; margin-top: 40px; }
        .paso { text-align: center; max-width: 180px; }
        .paso__num {
            width: 52px; height: 52px;
            border-radius: 50%;
            background: #fde8e8;
            color: var(--primario);
            font-weight: 700;
            font-size: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 14px;
        }
        .paso h3 { font-family: var(--titulo); font-size: 18px; margin-bottom: 8px; }
        .paso p { font-size: 14px; color: var(--texto-suave); }

        /* ---- Noticias ---- */
        .noticias-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
        }
        .noticia {
            background: #fff;
            border: 1px solid var(--borde);
            border-radius: 16px;
            overflow: hidden;
        }
        .noticia__img {
            width: 100%;
            aspect-ratio: 16/9;
            background: var(--fondo-alt);
            overflow: hidden;
        }
        .noticia__img img { width: 100%; height: 100%; object-fit: cover; }
        .noticia__cuerpo { padding: 20px; }
        .noticia__titulo { font-family: var(--titulo); font-size: 18px; margin-bottom: 8px; }
        .noticia__texto { font-size: 14px; color: var(--texto-suave); margin-bottom: 12px; line-height: 22px; }
    </style>
</head>
<body>

<% request.setAttribute("paginaActiva", "inicio"); %>
<%@ include file="/jsp/layouts/header.jsp" %>

<main>

    <!-- Hero -->
    <section class="hero">
        <div>
            <span class="etiqueta">Pastelería Artesanal Panameña</span>
            <h1>Dulces Hechos con Amor</h1>
            <p>Descubre la magia de la repostería artesanal. Ingredientes frescos, recetas de toda la vida y mucho amor en cada bocado.</p>
            <div class="hero__botones">
                <a href="${pageContext.request.contextPath}/jsp/publico/catalogo.jsp" class="btn btn-primario">Ver Catálogo</a>
                <a href="${pageContext.request.contextPath}/jsp/publico/nosotros.jsp" class="btn btn-outline">Sobre Nosotros</a>
            </div>
        </div>
        <div class="hero__img">
            <img src="${pageContext.request.contextPath}/img/HeroIndex.png" alt="Pasteles artesanales de La Casa de Mandi" onerror="this.style.display='none'">
        </div>
    </section>

    <!-- Productos destacados (reales, desde la BD) -->
    <section class="seccion">
        <span class="etiqueta">Nuestros Favoritos</span>
        <h2 class="seccion__titulo">Dulces y Postres Destacados</h2>
        <p class="seccion__sub">Cada receta es un legado familiar preparada con ingredientes orgánicos.</p>

        <% if (destacados.isEmpty()) { %>
            <p class="sin-productos">Aún no hay productos cargados en el catálogo.</p>
        <% } else { %>
        <div class="cards-grid">
            <% for (Producto p : destacados) {
                Variante primera = (p.getVariantes() != null && !p.getVariantes().isEmpty())
                    ? p.getVariantes().get(0) : null;
            %>
            <div class="card-producto">
                <div class="card-producto__img">
                    <% if (p.getImagen() != null && !p.getImagen().isEmpty()) { %>
                        <img src="${pageContext.request.contextPath}/img/<%= p.getImagen() %>"
                             alt="<%= p.getNombre() %>" onerror="this.style.display='none'">
                    <% } %>
                </div>
                <div class="card-producto__cuerpo">
                    <p class="card-producto__cat"><%= p.getNombreCategoria() %></p>
                    <h3 class="card-producto__nombre"><%= p.getNombre() %></h3>
                    <div class="card-producto__pie">
                        <span>desde <strong class="precio">
                            $<%= primera != null ? String.format("%.2f", primera.getPrecioBase()) : "--" %>
                        </strong></span>
                        <a href="${pageContext.request.contextPath}/jsp/publico/detalle-producto.jsp?id=<%= p.getIdProducto() %>">Ver detalles</a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>

        <div style="text-align:center; margin-top:40px;">
            <a href="${pageContext.request.contextPath}/jsp/publico/catalogo.jsp" class="btn btn-primario">Explorar todo el catálogo</a>
        </div>
    </section>

    <!-- Proceso de compra -->
    <section class="seccion seccion--alt" style="text-align:center;">
        <span class="etiqueta">Proceso de Compra</span>
        <h2 class="seccion__titulo">¿Cómo hacer tu pedido?</h2>
        <div class="pasos">
            <div class="paso">
                <div class="paso__num">1</div>
                <h3>Elige</h3>
                <p>Selecciona tus dulces favoritos del catálogo.</p>
            </div>
            <div class="paso">
                <div class="paso__num">2</div>
                <h3>Confirma</h3>
                <p>Crea tu cuenta y registra tu pedido.</p>
            </div>
            <div class="paso">
                <div class="paso__num">3</div>
                <h3>Abona</h3>
                <p>Realiza el pago del abono mínimo del 50%.</p>
            </div>
            <div class="paso">
                <div class="paso__num">4</div>
                <h3>Disfruta</h3>
                <p>Recibe tu pedido y disfrútalo en casa.</p>
            </div>
        </div>
    </section>

    <!-- Noticias -->
    <section class="seccion">
        <span class="etiqueta">Noticias y Novedades</span>
        <h2 class="seccion__titulo">Mantente al tanto</h2>
        <p class="seccion__sub">Nuestras últimas historias y secretos culinarios.</p>
        <div class="noticias-grid">
            <div class="noticia">
                <div class="noticia__img"></div>
                <div class="noticia__cuerpo">
                    <h3 class="noticia__titulo">El Secreto de la Masa Madre</h3>
                    <p class="noticia__texto">Descubre las técnicas ancestrales que dan vida a nuestros productos más especiales.</p>
                    <a href="#">Leer más →</a>
                </div>
            </div>
            <div class="noticia">
                <div class="noticia__img"></div>
                <div class="noticia__cuerpo">
                    <h3 class="noticia__titulo">El Arte de la Decoración</h3>
                    <p class="noticia__texto">Un vistazo a la precisión y creatividad detrás de nuestras tartas personalizadas.</p>
                    <a href="#">Leer más →</a>
                </div>
            </div>
            <div class="noticia">
                <div class="noticia__img"></div>
                <div class="noticia__cuerpo">
                    <h3 class="noticia__titulo">Un día en nuestra cocina</h3>
                    <p class="noticia__texto">Acompáñanos en el proceso diario de creación de nuestros dulces artesanales.</p>
                    <a href="#">Ver más →</a>
                </div>
            </div>
        </div>
    </section>

</main>

<%@ include file="/jsp/layouts/footer.jsp" %>
</body>
</html>
