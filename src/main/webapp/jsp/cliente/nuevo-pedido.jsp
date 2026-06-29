<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, dao.ProductoDAO, modelo.Producto, modelo.Variante" %>
<%
    String rol = (String) session.getAttribute("rol");
    if (!"cliente".equals(rol)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    ProductoDAO productoDAO = new ProductoDAO();
    List<Producto> todosProductos = productoDAO.listarTodos();

    // Si viene un producto preseleccionado desde el catálogo
    String preseleccionado = request.getParameter("producto");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nuevo Pedido — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        .panel-hero { padding:48px 64px 24px; }
        .panel-hero h1 { font-family:var(--titulo); font-size:36px; font-weight:700; }

        .formulario-pedido {
            padding:0 64px 64px;
            display:grid; grid-template-columns:1fr 1fr; gap:48px;
        }

        .form-card {
            background:#fff; border:1px solid var(--borde);
            border-radius:12px; padding:32px;
        }
        .form-card h2 { font-family:var(--titulo); font-size:20px; margin-bottom:24px; }

        .resumen {
            padding:24px; background:var(--fondo-alt); border-radius:12px;
            position:sticky; top:80px;
        }
        .resumen h3 { font-family:var(--titulo); font-size:18px; margin-bottom:16px; }
        .resumen-fila {
            display:flex; justify-content:space-between;
            font-size:14px; margin-bottom:12px; color:var(--texto-suave);
        }
        .resumen-fila span:last-child { color:var(--texto); font-weight:500; }
        .resumen-fila.total {
            font-size:16px; font-weight:700; border-top:1px solid var(--borde);
            padding-top:12px; margin-top:12px; color:var(--texto);
        }
        .resumen-fila.total span:last-child { color:var(--primario); }

        .info-box {
            background:#fdf3e3; border:1px solid #f5d99a; border-radius:8px;
            padding:14px 16px; margin-bottom:20px; font-size:14px; color:#7a4f00;
        }

        .btn-enviar {
            display:block; width:100%; padding:14px; background:var(--primario); color:#fff;
            border:none; border-radius:999px; font-size:15px; font-weight:600;
            cursor:pointer; margin-top:8px; transition:background 0.15s;
        }
        .btn-enviar:hover { background:var(--primario-dark); }
        .btn-enviar:disabled { background:#ccc; cursor:not-allowed; }
    </style>
</head>
<body>
<% request.setAttribute("paginaActiva", "pedidos"); %>
<%@ include file="/jsp/layouts/header.jsp" %>

<main>
    <section class="panel-hero">
        <span class="etiqueta">Panel del Cliente</span>
        <h1>Nuevo Pedido</h1>
        <p style="color:var(--texto-suave);">Selecciona el producto, la variante y cuéntanos cómo quieres decorarlo.</p>
    </section>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alerta-error" style="margin:0 64px 16px;"><%= request.getAttribute("error") %></div>
    <% } %>

    <div class="formulario-pedido">
        <div class="form-card">
            <h2>Datos del pedido</h2>
            <form id="formPedido" action="${pageContext.request.contextPath}/pedido" method="POST">
                <input type="hidden" name="accion" value="crear">

                <div class="campo">
                    <label for="id_producto">Producto</label>
                    <select id="id_producto" name="id_producto" required onchange="actualizarVariantes()">
                        <option value="">Selecciona un producto</option>
                        <% for (Producto p : todosProductos) { %>
                        <option value="<%= p.getIdProducto() %>"
                                data-categoria="<%= p.getNombreCategoria() %>"
                                <%= (preseleccionado != null && preseleccionado.equals(String.valueOf(p.getIdProducto()))) ? "selected" : "" %>>
                            <%= p.getNombre() %> (<%= p.getNombreCategoria() %>)
                        </option>
                        <% } %>
                    </select>
                </div>

                <div class="campo">
                    <label for="id_variante">Variante / Tamaño</label>
                    <select id="id_variante" name="id_variante" required onchange="actualizarResumen()">
                        <option value="">Primero selecciona un producto</option>
                    </select>
                </div>

                <div class="campo">
                    <label for="cantidad">Cantidad</label>
                    <input type="number" id="cantidad" name="cantidad"
                           min="1" max="20" value="1" required oninput="actualizarResumen()">
                </div>

                <div class="campo">
                    <label for="descripcion_diseno">Descripción del diseño / personalización</label>
                    <textarea id="descripcion_diseno" name="descripcion_diseno" rows="3"
                              placeholder="Ej: Decorar con fresas frescas, mensaje 'Feliz Cumpleaños María'..."></textarea>
                </div>

                <div class="campo">
                    <label for="fecha_entrega">Fecha de entrega</label>
                    <input type="date" id="fecha_entrega" name="fecha_entrega" required>
                </div>

                <div class="info-box">
                    <strong>Recuerda:</strong> Se requiere un abono del 50% del precio para confirmar tu pedido.
                    El precio final lo confirma el equipo de La Casa de Mandi.
                </div>

                <button type="submit" class="btn-enviar" id="btnEnviar">Enviar pedido</button>
            </form>
        </div>

        <div>
            <div class="resumen">
                <h3>Resumen</h3>
                <div class="resumen-fila"><span>Producto</span><span id="res-producto">—</span></div>
                <div class="resumen-fila"><span>Variante</span><span id="res-variante">—</span></div>
                <div class="resumen-fila"><span>Cantidad</span><span id="res-cantidad">—</span></div>
                <div class="resumen-fila"><span>Precio unitario</span><span id="res-precio-unit">—</span></div>
                <div class="resumen-fila total">
                    <span>Total estimado</span>
                    <span id="res-total">$0.00</span>
                </div>
                <p style="font-size:12px;color:var(--texto-suave);margin-top:12px;">
                    * El precio final puede variar según la complejidad del diseño y lo confirma el equipo.
                </p>
            </div>
        </div>
    </div>
</main>

<%@ include file="/jsp/layouts/footer.jsp" %>

<%-- Datos de productos/variantes para JavaScript --%>
<script>
const productos = {
    <% for (Producto p : todosProductos) { %>
    "<%= p.getIdProducto() %>": {
        nombre: "<%= p.getNombre().replace("\"","\\\"") %>",
        categoria: "<%= p.getNombreCategoria() %>",
        variantes: [
            <% for (Variante v : p.getVariantes()) { %>
            { id: <%= v.getIdVariante() %>, tamano: "<%= v.getTamano().replace("\"","\\\"") %>", precio: <%= v.getPrecioBase() %> },
            <% } %>
        ]
    },
    <% } %>
};

// Fecha mínima: mañana
(function() {
    const hoy = new Date();
    hoy.setDate(hoy.getDate() + 1);
    document.getElementById('fecha_entrega').min = hoy.toISOString().split('T')[0];
})();

function actualizarVariantes() {
    const idProd = document.getElementById('id_producto').value;
    const sel    = document.getElementById('id_variante');
    sel.innerHTML = '<option value="">Selecciona una variante</option>';

    if (!idProd || !productos[idProd]) {
        actualizarResumen();
        return;
    }

    const prod = productos[idProd];
    document.getElementById('res-producto').textContent = prod.nombre;

    prod.variantes.forEach(v => {
        const opt = document.createElement('option');
        opt.value = v.id;
        opt.dataset.precio = v.precio;
        opt.textContent = v.tamano + ' — $' + parseFloat(v.precio).toFixed(2);
        sel.appendChild(opt);
    });

    if (prod.variantes.length === 1) sel.selectedIndex = 1;
    actualizarResumen();
}

function actualizarResumen() {
    const idProd    = document.getElementById('id_producto').value;
    const selVar    = document.getElementById('id_variante');
    const cantidad  = parseInt(document.getElementById('cantidad').value) || 0;
    const optSelec  = selVar.options[selVar.selectedIndex];

    if (!idProd || !optSelec || !optSelec.value) {
        document.getElementById('res-variante').textContent   = '—';
        document.getElementById('res-precio-unit').textContent = '—';
        document.getElementById('res-cantidad').textContent   = '—';
        document.getElementById('res-total').textContent      = '$0.00';
        return;
    }

    const precio = parseFloat(optSelec.dataset.precio) || 0;
    const total  = precio * cantidad;

    document.getElementById('res-variante').textContent    = optSelec.textContent.split(' — ')[0];
    document.getElementById('res-precio-unit').textContent = '$' + precio.toFixed(2);
    document.getElementById('res-cantidad').textContent    = cantidad;
    document.getElementById('res-total').textContent       = '$' + total.toFixed(2);
}

// Si hay producto preseleccionado desde catálogo
window.addEventListener('DOMContentLoaded', function() {
    const sel = document.getElementById('id_producto');
    if (sel.value) actualizarVariantes();
});
</script>
</body>
</html>
