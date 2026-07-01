<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.PedidoDAO, dao.PagoDAO, modelo.Pedido, modelo.Abono, modelo.PagoFinal" %>
<%
    String rol = (String) session.getAttribute("rol");
    if (!"cliente".equals(rol)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    int idCliente = (int) session.getAttribute("id_cliente");

    String idParam = request.getParameter("id");
    if (idParam == null || idParam.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/jsp/cliente/mis-pedidos.jsp"); return;
    }

    int idPedido = Integer.parseInt(idParam.trim());
    PedidoDAO pedidoDAO = new PedidoDAO();
    PagoDAO   pagoDAO   = new PagoDAO();

    Pedido  pedido    = pedidoDAO.buscarPorId(idPedido);
    if (pedido == null || pedido.getIdCliente() != idCliente) {
        response.sendRedirect(request.getContextPath() + "/jsp/cliente/mis-pedidos.jsp"); return;
    }

    Abono     abono     = pagoDAO.buscarAbonoPorPedido(idPedido);
    PagoFinal pagoFinal = pagoDAO.buscarPagoFinalPorPedido(idPedido);

    String ok    = request.getParameter("ok");
    String error = request.getParameter("error");

    // Lógica del timeline de estados
    String[] estadosOrden = {"Pendiente","Aceptado","En produccion","Listo","Entregado"};
    String estadoActual   = pedido.getEstado();
    int pasoActual = 0;
    for (int i = 0; i < estadosOrden.length; i++) {
        if (estadosOrden[i].equals(estadoActual)) { pasoActual = i; break; }
    }

    // ¿Puede registrar abono? (precio confirmado, no hay abono aún, estado Pendiente/Aceptado)
    boolean puedeAbono     = pedido.isPrecioConfirmado()
                             && abono == null
                             && ("Pendiente".equals(estadoActual) || "Aceptado".equals(estadoActual));
    // ¿Puede registrar pago final? (abono confirmado, sin pago final, estado En produccion/Listo)
    boolean puedePagoFinal = abono != null && abono.isConfirmado()
                             && pagoFinal == null
                             && ("En produccion".equals(estadoActual) || "Listo".equals(estadoActual));

    // Cálculo del 50% para el abono
    java.math.BigDecimal cincuenta = pedido.getPrecioTotal() != null
        ? pedido.getPrecioTotal().multiply(new java.math.BigDecimal("0.50")).setScale(2, java.math.RoundingMode.HALF_UP)
        : java.math.BigDecimal.ZERO;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle del Pedido #<%= idPedido %> — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <style>
        .panel-hero { background: var(--fondo-alt); padding: 48px 64px 32px; border-bottom: 1px solid var(--borde); }
        .panel-hero h1 { font-family: var(--titulo); font-size: 32px; margin: 8px 0 4px; }
        .panel-hero p  { color: var(--texto-suave); font-size: 14px; }
        .back-link { font-size: 13px; color: var(--primario); display: inline-flex; align-items: center; gap: 6px; margin-bottom: 12px; }
        .back-link:hover { text-decoration: none; opacity: 0.8; }

        .contenido { display: grid; grid-template-columns: 1fr 360px; gap: 28px; padding: 40px 64px 64px; }

        /* Info card */
        .info-card { background: #fff; border: 1px solid var(--borde); border-radius: 14px; padding: 28px; }
        .info-card h2 { font-family: var(--titulo); font-size: 19px; font-weight: 700; margin-bottom: 20px; }
        .info-fila { display: flex; justify-content: space-between; align-items: flex-start; padding: 11px 0; border-bottom: 1px solid var(--borde); font-size: 14px; gap: 16px; }
        .info-fila:last-child { border-bottom: none; }
        .info-fila strong { flex-shrink: 0; color: var(--texto-suave); font-weight: 600; }
        .info-fila span   { text-align: right; }

        /* Timeline */
        .timeline { display: flex; align-items: center; margin: 24px 0 8px; }
        .tl-paso  { display: flex; flex-direction: column; align-items: center; flex: 1; }
        .tl-circulo {
            width: 32px; height: 32px; border-radius: 50%;
            border: 2px solid var(--borde); background: #fff;
            display: flex; align-items: center; justify-content: center;
            font-size: 13px; font-weight: 700; color: var(--texto-suave); z-index: 1;
        }
        .tl-circulo.hecho  { background: var(--primario); border-color: var(--primario); color: #fff; }
        .tl-circulo.actual { background: #fff; border-color: var(--primario); color: var(--primario); }
        .tl-label { font-size: 10px; margin-top: 6px; color: var(--texto-suave); text-align: center; }
        .tl-label.hecho  { color: var(--primario); font-weight: 600; }
        .tl-linea { flex: 1; height: 2px; background: var(--borde); margin: 0 -2px; margin-bottom: 18px; }
        .tl-linea.hecha { background: var(--primario); }

        /* Columna derecha */
        .col-der { display: flex; flex-direction: column; gap: 20px; }

        /* Pago card */
        .pago-card { background: #fff; border: 1px solid var(--borde); border-radius: 14px; padding: 22px; }
        .pago-card h3 { font-family: var(--titulo); font-size: 16px; font-weight: 700; margin-bottom: 16px; display: flex; align-items: center; gap: 8px; }
        .pago-card .monto-grande { font-family: var(--titulo); font-size: 28px; font-weight: 700; color: var(--primario); margin-bottom: 4px; }
        .pago-card .sub { font-size: 12px; color: var(--texto-suave); margin-bottom: 16px; }

        .badge-pago-ok      { background: #d1fae5; color: #065f46; border-radius: 8px; padding: 10px 14px; font-size: 13px; font-weight: 600; }
        .badge-pago-pending { background: #fef3c7; color: #92400e; border-radius: 8px; padding: 10px 14px; font-size: 13px; font-weight: 600; }
        .badge-pago-locked  { background: var(--fondo-alt); color: var(--texto-suave); border-radius: 8px; padding: 10px 14px; font-size: 13px; }

        .campo-pago { margin-bottom: 14px; }
        .campo-pago label { display: block; font-size: 12px; font-weight: 700; margin-bottom: 5px; color: var(--texto-suave); text-transform: uppercase; letter-spacing: 0.05em; }
        .campo-pago input, .campo-pago select {
            width: 100%; padding: 10px 14px; border: 1px solid var(--borde);
            border-radius: 8px; font-size: 14px; font-family: var(--cuerpo); outline: none;
        }
        .campo-pago input:focus, .campo-pago select:focus { border-color: var(--primario); }

        .btn-pago {
            width: 100%; padding: 12px; background: var(--primario); color: #fff;
            border: none; border-radius: 999px; font-size: 14px; font-weight: 700;
            font-family: var(--cuerpo); cursor: pointer; margin-top: 6px;
        }
        .btn-pago:hover { background: var(--primario-dark); }
        .btn-pago:disabled { background: var(--borde); color: var(--texto-suave); cursor: not-allowed; }

        /* Alertas */
        .alerta-ok    { background: #d1fae5; border: 1px solid #6ee7b7; border-radius: 10px; padding: 12px 18px; color: #065f46; font-size: 14px; margin-bottom: 20px; }
        .alerta-error { background: #fde8e8; border: 1px solid #f5a5a5; border-radius: 10px; padding: 12px 18px; color: #8b1a1a; font-size: 14px; margin-bottom: 20px; }

        /* Cancelado/Rechazado */
        .estado-cancelado { background: #fde8e8; border-radius: 14px; padding: 20px; text-align: center; color: #8b1a1a; font-size: 14px; }

        @media (max-width: 900px) { .contenido { grid-template-columns: 1fr; padding: 24px; } }
    </style>
</head>
<body>
<% request.setAttribute("paginaActiva", "pedidos"); %>
<%@ include file="/jsp/layouts/header.jsp" %>

<main>
    <div class="panel-hero">
        <a href="${pageContext.request.contextPath}/jsp/cliente/mis-pedidos.jsp" class="back-link">← Mis pedidos</a>
        <span class="etiqueta">Panel del Cliente</span>
        <h1>Pedido #<%= String.format("%04d", idPedido) %></h1>
        <p>Realizado el <%= pedido.getFechaPedido() != null ? pedido.getFechaPedido().toString().substring(0,10) : "—" %></p>
    </div>

    <div class="contenido">
        <%-- COLUMNA IZQUIERDA --%>
        <div>
            <%-- Alertas de feedback --%>
            <% if ("abono".equals(ok)) { %>
                <div class="alerta-ok">✓ Abono registrado correctamente. El administrador lo verificará pronto.</div>
            <% } else if ("pago_final".equals(ok)) { %>
                <div class="alerta-ok">✓ Pago final registrado. El pedido quedará listo una vez confirmado.</div>
            <% } else if ("abono_duplicado".equals(error)) { %>
                <div class="alerta-error">Ya existe un abono registrado para este pedido.</div>
            <% } else if ("pago_duplicado".equals(error)) { %>
                <div class="alerta-error">Ya existe un pago final registrado para este pedido.</div>
            <% } %>

            <%-- Info del pedido --%>
            <div class="info-card" style="margin-bottom:24px;">
                <h2>Información del pedido</h2>
                <div class="info-fila"><strong>Producto</strong><span><%= pedido.getNombreProducto() %></span></div>
                <div class="info-fila"><strong>Tamaño</strong><span><%= pedido.getTamanoVariante() %></span></div>
                <div class="info-fila"><strong>Fecha de entrega</strong><span><%= pedido.getFechaEntrega() %></span></div>
                <div class="info-fila">
                    <strong>Descripción del diseño</strong>
                    <span><%= (pedido.getDescripcionDiseno() != null && !pedido.getDescripcionDiseno().isEmpty())
                               ? pedido.getDescripcionDiseno() : "Sin descripción" %></span>
                </div>
                <div class="info-fila">
                    <strong>Precio total</strong>
                    <span>
                        <strong>$<%= String.format("%.2f", pedido.getPrecioTotal()) %></strong>
                        <%= pedido.isPrecioConfirmado() ? "<span style='color:#16a34a;font-size:12px;'> ✓ confirmado</span>" : "<span style='color:#d97706;font-size:12px;'> ⏳ pendiente de confirmación</span>" %>
                    </span>
                </div>
                <div class="info-fila">
                    <strong>Estado</strong>
                    <span>
                        <% String bc = badgeClase(estadoActual); %>
                        <span class="badge <%= bc %>"><%= estadoActual.toUpperCase() %></span>
                    </span>
                </div>
            </div>

            <%-- Timeline --%>
            <% if (!"Cancelado".equals(estadoActual) && !"Rechazado".equals(estadoActual)) { %>
            <div class="info-card">
                <h2>Estado del pedido</h2>
                <div class="timeline">
                <% for (int i = 0; i < estadosOrden.length; i++) {
                    boolean hecho  = i < pasoActual;
                    boolean actual = i == pasoActual;
                    String claseC  = hecho ? "hecho" : (actual ? "actual" : "");
                    String claseL  = hecho ? "hecha" : "";
                %>
                    <div class="tl-paso">
                        <div class="tl-circulo <%= claseC %>"><%= hecho ? "✓" : (i+1) %></div>
                        <div class="tl-label <%= claseC %>">
                            <%= estadosOrden[i].equals("En produccion") ? "En producción" : estadosOrden[i] %>
                        </div>
                    </div>
                    <% if (i < estadosOrden.length - 1) { %>
                    <div class="tl-linea <%= claseL %>"></div>
                    <% } %>
                <% } %>
                </div>
            </div>
            <% } else { %>
            <div class="estado-cancelado">
                Este pedido fue <strong><%= estadoActual.toLowerCase() %></strong>.
                Si tienes dudas, contáctanos.
            </div>
            <% } %>
        </div>

        <%-- COLUMNA DERECHA — PAGOS --%>
        <div class="col-der">

            <%-- ABONO --%>
            <div class="pago-card">
                <h3>Abono (50%)</h3>

                <% if (abono != null && abono.isConfirmado()) { %>
                    <div class="monto-grande">$<%= String.format("%.2f", abono.getMonto()) %></div>
                    <div class="sub">Abono confirmado el <%= abono.getFechaConfirmacion() %></div>
                    <div class="badge-pago-ok">✓ Abono verificado por el administrador</div>

                <% } else if (abono != null && !abono.isConfirmado()) { %>
                    <div class="monto-grande">$<%= String.format("%.2f", abono.getMonto()) %></div>
                    <div class="sub">Registrado el <%= abono.getFechaPago() %> vía <%= abono.getMetodoPago() %>
                        <% if (abono.getReferencia() != null && !abono.getReferencia().isEmpty()) { %>
                            · Ref: <%= abono.getReferencia() %>
                        <% } %>
                    </div>
                    <div class="badge-pago-pending">⏳ Esperando verificación del administrador</div>

                <% } else if (puedeAbono) { %>
                    <div class="monto-grande">$<%= String.format("%.2f", cincuenta) %></div>
                    <div class="sub">50% del total confirmado — registra tu pago para que comience la producción.</div>
                    <form action="${pageContext.request.contextPath}/pago" method="POST">
                        <input type="hidden" name="accion"      value="abono">
                        <input type="hidden" name="id_pedido"   value="<%= idPedido %>">
                        <input type="hidden" name="monto"       value="<%= cincuenta %>">
                        <input type="hidden" name="porcentaje"  value="50.00">
                        <div class="campo-pago">
                            <label>Método de pago</label>
                            <select name="metodo_pago" required>
                                <option value="">Selecciona...</option>
                                <option value="Yappy">Yappy</option>
                                <option value="Efectivo">Efectivo</option>
                                <option value="Transferencia">Transferencia</option>
                            </select>
                        </div>
                        <div class="campo-pago">
                            <label>Fecha del pago</label>
                            <input type="date" name="fecha_pago" required
                                   value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                        </div>
                        <div class="campo-pago">
                            <label>Referencia / Número de transacción</label>
                            <input type="text" name="referencia" placeholder="Ej: YAP-12345678">
                        </div>
                        <button type="submit" class="btn-pago">Registrar abono</button>
                    </form>

                <% } else if (!pedido.isPrecioConfirmado()) { %>
                    <div class="badge-pago-locked">⏳ El administrador aún no ha confirmado el precio del pedido.</div>
                <% } %>
            </div>

            <%-- PAGO FINAL --%>
            <div class="pago-card">
                <h3>Pago Final (50%)</h3>

                <% if (pagoFinal != null && pagoFinal.isConfirmado()) { %>
                    <div class="monto-grande">$<%= String.format("%.2f", pagoFinal.getMonto()) %></div>
                    <div class="sub">Pago final confirmado el <%= pagoFinal.getFechaConfirmacion() %></div>
                    <div class="badge-pago-ok">✓ Pago final verificado — pedido completado</div>

                <% } else if (pagoFinal != null && !pagoFinal.isConfirmado()) { %>
                    <div class="monto-grande">$<%= String.format("%.2f", pagoFinal.getMonto()) %></div>
                    <div class="sub">Registrado el <%= pagoFinal.getFechaPago() %> vía <%= pagoFinal.getMetodoPago() %>
                        <% if (pagoFinal.getReferencia() != null && !pagoFinal.getReferencia().isEmpty()) { %>
                            · Ref: <%= pagoFinal.getReferencia() %>
                        <% } %>
                    </div>
                    <div class="badge-pago-pending">⏳ Esperando verificación del administrador</div>

                <% } else if (puedePagoFinal) { %>
                    <%
                        java.math.BigDecimal montoPagoFinal = pedido.getPrecioTotal() != null
                            ? pedido.getPrecioTotal().subtract(abono.getMonto()).setScale(2, java.math.RoundingMode.HALF_UP)
                            : java.math.BigDecimal.ZERO;
                    %>
                    <div class="monto-grande">$<%= String.format("%.2f", montoPagoFinal) %></div>
                    <div class="sub">Monto restante para completar el pago total del pedido.</div>
                    <form action="${pageContext.request.contextPath}/pago" method="POST">
                        <input type="hidden" name="accion"    value="pago_final">
                        <input type="hidden" name="id_pedido" value="<%= idPedido %>">
                        <input type="hidden" name="monto"     value="<%= montoPagoFinal %>">
                        <div class="campo-pago">
                            <label>Método de pago</label>
                            <select name="metodo_pago" required>
                                <option value="">Selecciona...</option>
                                <option value="Yappy">Yappy</option>
                                <option value="Efectivo">Efectivo</option>
                                <option value="Transferencia">Transferencia</option>
                            </select>
                        </div>
                        <div class="campo-pago">
                            <label>Fecha del pago</label>
                            <input type="date" name="fecha_pago" required
                                   value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                        </div>
                        <div class="campo-pago">
                            <label>Referencia / Número de transacción</label>
                            <input type="text" name="referencia" placeholder="Ej: YAP-12345678">
                        </div>
                        <button type="submit" class="btn-pago">Registrar pago final</button>
                    </form>

                <% } else { %>
                    <div class="badge-pago-locked">
                        <%= abono == null ? "Primero registra y confirma el abono." :
                            !abono.isConfirmado() ? "Espera la confirmación del abono para registrar el pago final." :
                            "El pago final estará disponible cuando el pedido esté en producción." %>
                    </div>
                <% } %>
            </div>

        </div>
    </div>
</main>

<%@ include file="/jsp/layouts/footer.jsp" %>

<%!
    private String badgeClase(String estado) {
        if (estado == null) return "badge-pendiente";
        switch (estado) {
            case "Pendiente":     return "badge-pendiente";
            case "Aceptado":      return "badge-aceptado";
            case "En produccion": return "badge-produccion";
            case "Listo":         return "badge-listo";
            case "Entregado":     return "badge-entregado";
            case "Cancelado":
            case "Rechazado":     return "badge-cancelado";
            default:              return "badge-pendiente";
        }
    }
%>
</body>
</html>
