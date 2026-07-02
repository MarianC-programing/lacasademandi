<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, dao.ProductoDAO, modelo.Producto, modelo.Variante" %>
<%
    String rol = (String) session.getAttribute("rol");
    if (!"admin".equals(rol)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }

    ProductoDAO dao        = new ProductoDAO();
    List<Producto> productos = dao.listarTodosAdmin();
    List<String[]> categorias = dao.listarCategorias();

    // Producto en modo edición o detalle de variantes
    String idParam   = request.getParameter("id");
    Producto editando = null;
    if (idParam != null && !idParam.trim().isEmpty()) {
        try { editando = dao.buscarPorId(Integer.parseInt(idParam.trim())); }
        catch (NumberFormatException ignored) {}
    }

    String ok    = request.getParameter("ok");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Productos — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <style>
        .productos-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 32px;
        }
        .prod-card {
            background: #fff;
            border: 1px solid var(--borde);
            border-radius: 14px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }
        .prod-card.inactivo { opacity: 0.55; }
        .prod-card__img {
            width: 100%; aspect-ratio: 4/3;
            background: var(--fondo-alt);
            position: relative; overflow: hidden;
        }
        .prod-card__img img { width: 100%; height: 100%; object-fit: cover; }
        .prod-card__badge-cat {
            position: absolute; top: 10px; left: 10px;
            background: #fff; border-radius: 999px;
            padding: 3px 10px; font-size: 11px; font-weight: 700;
            color: var(--primario); border: 1px solid var(--borde);
        }
        .prod-card__inactivo-tag {
            position: absolute; top: 10px; right: 10px;
            background: #fee2e2; color: #991b1b;
            border-radius: 999px; padding: 3px 10px;
            font-size: 10px; font-weight: 700;
        }
        .prod-card__body { padding: 18px; flex: 1; }
        .prod-card__nombre { font-family: var(--titulo); font-size: 17px; font-weight: 700; margin-bottom: 6px; }
        .prod-card__desc { font-size: 13px; color: var(--texto-suave); line-height: 19px; margin-bottom: 12px; }
        .prod-card__variantes { margin-bottom: 14px; }
        .variante-chip {
            display: inline-block; background: var(--fondo-alt);
            border: 1px solid var(--borde); border-radius: 999px;
            padding: 3px 10px; font-size: 12px; margin: 2px;
        }
        .variante-chip.inactiva { opacity: 0.5; text-decoration: line-through; }
        .prod-card__acciones { display: flex; gap: 8px; padding: 0 18px 18px; flex-wrap: wrap; }
        .btn-edit {
            padding: 7px 16px; background: var(--primario); color: #fff;
            border-radius: 999px; font-size: 12px; font-weight: 600;
            text-decoration: none; white-space: nowrap;
        }
        .btn-edit:hover { background: var(--primario-dark); text-decoration: none; }
        .btn-toggle {
            padding: 7px 16px; border-radius: 999px; font-size: 12px; font-weight: 600;
            border: 1px solid var(--borde); background: transparent;
            color: var(--texto); cursor: pointer; white-space: nowrap;
        }
        .btn-toggle:hover { background: var(--fondo-alt); }

        /* Modal */
        .modal-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,0.45); z-index: 100;
            align-items: center; justify-content: center;
        }
        .modal-overlay.abierto { display: flex; }
        .modal {
            background: #fff; border-radius: 16px;
            padding: 32px; width: 520px; max-width: 95vw;
            max-height: 90vh; overflow-y: auto;
            position: relative;
        }
        .modal h2 { font-family: var(--titulo); font-size: 20px; font-weight: 700; margin-bottom: 20px; }
        .modal .cerrar {
            position: absolute; top: 16px; right: 20px;
            background: none; border: none; font-size: 22px;
            cursor: pointer; color: var(--texto-suave);
        }
        .modal .campo { margin-bottom: 16px; }
        .modal .campo label { display: block; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: var(--texto-suave); margin-bottom: 5px; }
        .modal .campo input,
        .modal .campo select,
        .modal .campo textarea {
            width: 100%; padding: 10px 14px; border: 1px solid var(--borde);
            border-radius: 8px; font-size: 14px; font-family: var(--cuerpo); outline: none;
            box-sizing: border-box;
        }
        .modal .campo input:focus,
        .modal .campo select:focus,
        .modal .campo textarea:focus { border-color: var(--primario); }
        .modal .btn-submit {
            width: 100%; padding: 12px; background: var(--primario); color: #fff;
            border: none; border-radius: 999px; font-size: 15px; font-weight: 700;
            cursor: pointer; margin-top: 8px;
        }
        .modal .btn-submit:hover { background: var(--primario-dark); }

        /* Tabla variantes en modal */
        .tabla-variantes { width: 100%; border-collapse: collapse; font-size: 13px; margin-bottom: 16px; }
        .tabla-variantes th, .tabla-variantes td { padding: 8px 10px; text-align: left; border-bottom: 1px solid var(--borde); }
        .tabla-variantes th { font-size: 11px; text-transform: uppercase; color: var(--texto-suave); background: var(--fondo-alt); }

        .alerta-ok    { background: #d1fae5; border-radius: 8px; padding: 10px 16px; color: #065f46; font-size: 13px; font-weight: 600; margin-bottom: 16px; }
        .alerta-error { background: #fde8e8; border-radius: 8px; padding: 10px 16px; color: #8b1a1a; font-size: 13px; font-weight: 600; margin-bottom: 16px; }
    </style>
</head>
<body>
<div class="admin-layout">

    <% request.setAttribute("seccionActiva", "productos"); %>
    <%@ include file="/jsp/admin/sidebar.jsp" %>

    <div class="admin-main">
        <div class="admin-content">

            <div class="admin-content-header">
                <div>
                    <h1>Productos</h1>
                    <p>Gestiona el catálogo de dulces y postres.</p>
                </div>
                <button class="btn btn-primario" onclick="abrirModalCrear()">+ Agregar producto</button>
            </div>

            <% if ("creado".equals(ok) || "editado".equals(ok)) { %>
                <div class="alerta-ok">✓ Producto <%= "creado".equals(ok) ? "creado" : "actualizado" %> correctamente.</div>
            <% } else if ("variante".equals(ok)) { %>
                <div class="alerta-ok">✓ Variante guardada correctamente.</div>
            <% } else if ("toggle".equals(ok)) { %>
                <div class="alerta-ok">✓ Disponibilidad del producto actualizada.</div>
            <% } else if ("1".equals(error)) { %>
                <div class="alerta-error">✗ Ocurrió un error. Intenta de nuevo.</div>
            <% } %>

            <%-- STATS RÁPIDAS --%>
            <div class="admin-stats-grid" style="grid-template-columns:repeat(3,1fr);margin-bottom:28px;">
                <%
                    long totalP    = productos.size();
                    long activos   = productos.stream().filter(Producto::isDisponible).count();
                    long inactivos = totalP - activos;
                %>
                <div class="admin-stat-card">
                    <h3>Total</h3>
                    <div class="num" style="font-size:28px;"><%= totalP %></div>
                </div>
                <div class="admin-stat-card verde">
                    <h3>Activos</h3>
                    <div class="num" style="font-size:28px;"><%= activos %></div>
                </div>
                <div class="admin-stat-card" style="opacity:0.7;">
                    <h3>Inactivos</h3>
                    <div class="num" style="font-size:28px;"><%= inactivos %></div>
                </div>
            </div>

            <%-- GRID DE PRODUCTOS --%>
            <div class="productos-grid">
            <% for (Producto p : productos) {
                Variante primera = p.getVariantes().isEmpty() ? null : p.getVariantes().get(0);
            %>
                <div class="prod-card <%= p.isDisponible() ? "" : "inactivo" %>">
                    <div class="prod-card__img">
                        <% if (p.getImagen() != null && !p.getImagen().isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}/img/<%= p.getImagen() %>"
                                 alt="<%= p.getNombre() %>" onerror="this.style.display='none'">
                        <% } %>
                        <span class="prod-card__badge-cat"><%= p.getNombreCategoria() %></span>
                        <% if (!p.isDisponible()) { %>
                            <span class="prod-card__inactivo-tag">Inactivo</span>
                        <% } %>
                    </div>
                    <div class="prod-card__body">
                        <div class="prod-card__nombre"><%= p.getNombre() %></div>
                        <div class="prod-card__desc"><%= p.getDescripcion() %></div>
                        <div class="prod-card__variantes">
                            <% for (Variante v : p.getVariantes()) { %>
                                <span class="variante-chip <%= v.isDisponible() ? "" : "inactiva" %>">
                                    <%= v.getTamano() %> — $<%= String.format("%.2f", v.getPrecioBase()) %>
                                </span>
                            <% } %>
                        </div>
                    </div>
                    <div class="prod-card__acciones">
                        <a href="#" class="btn-edit"
                           onclick="abrirModalEditar(
                               <%= p.getIdProducto() %>,
                               '<%= p.getNombreCategoria().replace("'","\\'") %>',
                               <%= p.getIdCategoria() %>,
                               '<%= p.getNombre().replace("'","\\'") %>',
                               '<%= p.getDescripcion() != null ? p.getDescripcion().replace("'","\\'") : "" %>',
                               '<%= p.getImagen() != null ? p.getImagen() : "" %>'
                           ); return false;">
                            Editar
                        </a>
                        <a href="#" class="btn-edit" style="background:var(--fondo-alt);color:var(--texto);"
                           onclick="abrirModalVariantes(<%= p.getIdProducto() %>, '<%= p.getNombre().replace("'","\\'") %>'); return false;">
                            Variantes
                        </a>
                        <form action="${pageContext.request.contextPath}/producto" method="POST" style="display:inline;">
                            <input type="hidden" name="accion"      value="toggle">
                            <input type="hidden" name="id_producto" value="<%= p.getIdProducto() %>">
                            <input type="hidden" name="disponible"  value="<%= !p.isDisponible() %>">
                            <button type="submit" class="btn-toggle">
                                <%= p.isDisponible() ? "Desactivar" : "Activar" %>
                            </button>
                        </form>
                    </div>
                </div>
            <% } %>
            </div>

        </div>
        <%@ include file="/jsp/admin/footer-admin.jsp" %>
    </div>
</div>

<%-- ══ MODAL: CREAR PRODUCTO ══ --%>
<div class="modal-overlay" id="modalCrear">
    <div class="modal">
        <button class="cerrar" onclick="cerrarModal('modalCrear')">✕</button>
        <h2>Nuevo producto</h2>
        <form action="${pageContext.request.contextPath}/producto" method="POST">
            <input type="hidden" name="accion" value="crear">
            <div class="campo">
                <label>Categoría</label>
                <select name="id_categoria" required>
                    <option value="">Selecciona...</option>
                    <% for (String[] cat : categorias) { %>
                        <option value="<%= cat[0] %>"><%= cat[1] %></option>
                    <% } %>
                </select>
            </div>
            <div class="campo">
                <label>Nombre</label>
                <input type="text" name="nombre" required placeholder="Ej: Torta de Fresas">
            </div>
            <div class="campo">
                <label>Descripción</label>
                <textarea name="descripcion" rows="3" placeholder="Breve descripción del producto..."></textarea>
            </div>
            <div class="campo">
                <label>Nombre de imagen (en /img/)</label>
                <input type="text" name="imagen" placeholder="Ej: torta-fresas.jpg">
            </div>
            <button type="submit" class="btn-submit">Crear producto</button>
        </form>
    </div>
</div>

<%-- ══ MODAL: EDITAR PRODUCTO ══ --%>
<div class="modal-overlay" id="modalEditar">
    <div class="modal">
        <button class="cerrar" onclick="cerrarModal('modalEditar')">✕</button>
        <h2>Editar producto</h2>
        <form action="${pageContext.request.contextPath}/producto" method="POST">
            <input type="hidden" name="accion" value="editar">
            <input type="hidden" name="id_producto" id="edit-id">
            <div class="campo">
                <label>Categoría</label>
                <select name="id_categoria" id="edit-cat" required>
                    <% for (String[] cat : categorias) { %>
                        <option value="<%= cat[0] %>"><%= cat[1] %></option>
                    <% } %>
                </select>
            </div>
            <div class="campo">
                <label>Nombre</label>
                <input type="text" name="nombre" id="edit-nombre" required>
            </div>
            <div class="campo">
                <label>Descripción</label>
                <textarea name="descripcion" id="edit-desc" rows="3"></textarea>
            </div>
            <div class="campo">
                <label>Nombre de imagen (en /img/)</label>
                <input type="text" name="imagen" id="edit-img">
            </div>
            <button type="submit" class="btn-submit">Guardar cambios</button>
        </form>
    </div>
</div>

<%-- ══ MODAL: VARIANTES ══ --%>
<div class="modal-overlay" id="modalVariantes">
    <div class="modal">
        <button class="cerrar" onclick="cerrarModal('modalVariantes')">✕</button>
        <h2 id="modal-var-titulo">Variantes</h2>

        <table class="tabla-variantes" id="tabla-var-existentes">
            <thead>
                <tr><th>Tamaño</th><th>Precio</th><th>Estado</th><th></th></tr>
            </thead>
            <tbody id="tbody-variantes">
                <% for (Producto p : productos) {
                    for (Variante v : p.getVariantes()) { %>
                <tr data-prod="<%= p.getIdProducto() %>" style="display:none;">
                    <td><%= v.getTamano() %></td>
                    <td>$<%= String.format("%.2f", v.getPrecioBase()) %></td>
                    <td><span class="badge <%= v.isDisponible() ? "badge-listo" : "badge-cancelado" %>">
                        <%= v.isDisponible() ? "Activa" : "Inactiva" %>
                    </span></td>
                    <td>
                        <form action="${pageContext.request.contextPath}/producto" method="POST" style="display:inline">
                            <input type="hidden" name="accion"       value="editar_variante">
                            <input type="hidden" name="id_variante"  value="<%= v.getIdVariante() %>">
                            <input type="hidden" name="id_producto"  value="<%= p.getIdProducto() %>">
                            <input type="hidden" name="tamano"       value="<%= v.getTamano() %>">
                            <input type="hidden" name="precio_base"  value="<%= v.getPrecioBase() %>">
                            <input type="hidden" name="disponible"   value="<%= !v.isDisponible() %>">
                            <button type="submit" class="btn-toggle" style="padding:4px 12px;font-size:11px;">
                                <%= v.isDisponible() ? "Desactivar" : "Activar" %>
                            </button>
                        </form>
                    </td>
                </tr>
                <% } } %>
            </tbody>
        </table>

        <hr style="margin:16px 0;border-color:var(--borde);">
        <p style="font-size:13px;font-weight:700;margin-bottom:12px;">Agregar variante nueva</p>
        <form action="${pageContext.request.contextPath}/producto" method="POST">
            <input type="hidden" name="accion" value="crear_variante">
            <input type="hidden" name="id_producto" id="var-id-prod">
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;">
                <div class="campo">
                    <label>Tamaño</label>
                    <input type="text" name="tamano" required placeholder='Ej: 8"'>
                </div>
                <div class="campo">
                    <label>Precio base ($)</label>
                    <input type="number" name="precio_base" step="0.01" min="0" required placeholder="0.00">
                </div>
            </div>
            <button type="submit" class="btn-submit">Agregar variante</button>
        </form>
    </div>
</div>

<script>
function abrirModalCrear() {
    document.getElementById('modalCrear').classList.add('abierto');
}

function abrirModalEditar(id, catNombre, catId, nombre, desc, img) {
    document.getElementById('edit-id').value     = id;
    document.getElementById('edit-nombre').value = nombre;
    document.getElementById('edit-desc').value   = desc;
    document.getElementById('edit-img').value    = img;
    const sel = document.getElementById('edit-cat');
    for (let o of sel.options) { if (o.value == catId) { o.selected = true; break; } }
    document.getElementById('modalEditar').classList.add('abierto');
}

function abrirModalVariantes(idProd, nombre) {
    document.getElementById('modal-var-titulo').textContent = 'Variantes — ' + nombre;
    document.getElementById('var-id-prod').value = idProd;
    // Mostrar solo filas del producto seleccionado
    document.querySelectorAll('#tbody-variantes tr').forEach(tr => {
        tr.style.display = tr.dataset.prod == idProd ? '' : 'none';
    });
    document.getElementById('modalVariantes').classList.add('abierto');
}

function cerrarModal(id) {
    document.getElementById(id).classList.remove('abierto');
}

// Cerrar al click fuera del modal
document.querySelectorAll('.modal-overlay').forEach(overlay => {
    overlay.addEventListener('click', function(e) {
        if (e.target === this) this.classList.remove('abierto');
    });
});

// Cerrar con Escape
document.addEventListener('keydown', e => {
    if (e.key === 'Escape') document.querySelectorAll('.modal-overlay.abierto').forEach(m => m.classList.remove('abierto'));
});
</script>
</body>
</html>
