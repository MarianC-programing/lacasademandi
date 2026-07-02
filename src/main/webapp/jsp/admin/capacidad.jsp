<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, dao.CapacidadDAO" %>
<%
    String rol = (String) session.getAttribute("rol");
    if (!"admin".equals(rol)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }

    CapacidadDAO dao     = new CapacidadDAO();
    List<String[]> dias  = dao.listarCalendario(30); // próximos 30 días
    List<String> bloqueadas = dao.fechasBloqueadas();

    String ok    = request.getParameter("ok");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Capacidad de Entregas — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <style>
        .cap-grid {
            display: grid;
            grid-template-columns: 1fr 340px;
            gap: 28px;
        }

        /* Calendario de capacidad */
        .cal-tabla { width: 100%; border-collapse: collapse; font-size: 14px; }
        .cal-tabla th, .cal-tabla td {
            padding: 12px 16px; text-align: left;
            border-bottom: 1px solid var(--borde);
        }
        .cal-tabla th {
            font-size: 11px; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.06em; color: var(--texto-suave);
            background: var(--fondo-alt);
        }
        .cal-tabla tr:last-child td { border-bottom: none; }
        .cal-tabla tr:hover td { background: #fafafa; }

        /* Barra de capacidad */
        .cap-bar-wrap {
            display: flex; align-items: center; gap: 10px; min-width: 180px;
        }
        .cap-bar {
            flex: 1; height: 8px; background: var(--fondo-alt);
            border-radius: 999px; overflow: hidden;
        }
        .cap-bar__fill {
            height: 100%; border-radius: 999px;
            background: var(--primario); transition: width 0.3s;
        }
        .cap-bar__fill.lleno  { background: #ef4444; }
        .cap-bar__fill.casi   { background: #f59e0b; }
        .cap-num { font-size: 13px; font-weight: 700; white-space: nowrap; }

        /* Chip de estado */
        .chip-libre    { background: #d1fae5; color: #065f46; border-radius: 999px; padding: 3px 10px; font-size: 11px; font-weight: 700; white-space: nowrap; }
        .chip-casi     { background: #fef3c7; color: #92400e; border-radius: 999px; padding: 3px 10px; font-size: 11px; font-weight: 700; white-space: nowrap; }
        .chip-lleno    { background: #fee2e2; color: #991b1b; border-radius: 999px; padding: 3px 10px; font-size: 11px; font-weight: 700; white-space: nowrap; }

        /* Form editar límite */
        .edit-limite {
            display: inline-flex; align-items: center; gap: 6px;
        }
        .edit-limite input[type=number] {
            width: 60px; padding: 4px 8px; border: 1px solid var(--borde);
            border-radius: 6px; font-size: 13px; text-align: center;
        }
        .edit-limite button {
            padding: 4px 12px; background: var(--primario); color: #fff;
            border: none; border-radius: 6px; font-size: 12px; cursor: pointer;
        }
        .edit-limite button:hover { background: var(--primario-dark); }

        /* Panel lateral */
        .panel-card {
            background: #fff; border: 1px solid var(--borde);
            border-radius: 14px; padding: 22px; margin-bottom: 20px;
        }
        .panel-card h3 {
            font-family: var(--titulo); font-size: 16px; font-weight: 700;
            margin-bottom: 16px;
        }
        .regla-fila {
            display: flex; justify-content: space-between; align-items: center;
            padding: 10px 0; border-bottom: 1px solid var(--borde); font-size: 14px;
        }
        .regla-fila:last-child { border-bottom: none; }
        .regla-fila strong { color: var(--primario); font-size: 20px; font-weight: 700; }

        .fechas-bloqueadas { margin-top: 8px; }
        .fecha-chip {
            display: inline-block; background: #fee2e2; color: #991b1b;
            border-radius: 6px; padding: 4px 10px; font-size: 12px;
            font-weight: 600; margin: 3px;
        }
        .sin-bloqueos { font-size: 13px; color: #16a34a; font-weight: 600; }

        .alerta-ok    { background: #d1fae5; border-radius: 8px; padding: 10px 16px; color: #065f46; font-size: 13px; font-weight: 600; margin-bottom: 16px; }
        .alerta-error { background: #fde8e8; border-radius: 8px; padding: 10px 16px; color: #8b1a1a; font-size: 13px; font-weight: 600; margin-bottom: 16px; }
    </style>
</head>
<body>
<div class="admin-layout">

    <% request.setAttribute("seccionActiva", "configuracion"); %>
    <%@ include file="/jsp/admin/sidebar.jsp" %>

    <div class="admin-main">
        <div class="admin-content">

            <div class="admin-content-header">
                <div>
                    <h1>Capacidad de Entregas</h1>
                    <p>Gestiona cuántos pedidos puedes producir y entregar por día.</p>
                </div>
            </div>

            <% if ("1".equals(ok)) { %>
                <div class="alerta-ok">✓ Límite actualizado correctamente.</div>
            <% } else if ("1".equals(error)) { %>
                <div class="alerta-error">✗ Error al actualizar. Intenta de nuevo.</div>
            <% } %>

            <div class="cap-grid">

                <%-- TABLA DE CALENDARIO --%>
                <div>
                    <div style="background:#fff;border:1px solid var(--borde);border-radius:14px;overflow:hidden;">
                        <table class="cal-tabla">
                            <thead>
                                <tr>
                                    <th>Fecha</th>
                                    <th>Ocupación</th>
                                    <th>Estado</th>
                                    <th>Límite</th>
                                </tr>
                            </thead>
                            <tbody>
                            <% if (dias.isEmpty()) { %>
                                <tr><td colspan="4" style="text-align:center;color:var(--texto-suave);padding:32px;">
                                    No hay fechas registradas.
                                </td></tr>
                            <% } else {
                                for (String[] dia : dias) {
                                    String fecha     = dia[0];
                                    int confirmados  = Integer.parseInt(dia[1]);
                                    int limite       = Integer.parseInt(dia[2]);
                                    double pct       = limite > 0 ? (confirmados * 100.0 / limite) : 100;
                                    String fillClass = pct >= 100 ? "lleno" : pct >= 75 ? "casi" : "";
                                    String chip      = pct >= 100 ? "chip-lleno" : pct >= 75 ? "chip-casi" : "chip-libre";
                                    String chipTxt   = pct >= 100 ? "Lleno" : pct >= 75 ? "Casi lleno" : "Disponible";

                                    // Formatear fecha a texto legible
                                    java.time.LocalDate ld = java.time.LocalDate.parse(fecha);
                                    String[] meses = {"","Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic"};
                                    String[] dias_semana = {"Dom","Lun","Mar","Mié","Jue","Vie","Sáb"};
                                    String fechaTexto = dias_semana[ld.getDayOfWeek().getValue() % 7] + " " + ld.getDayOfMonth() + " " + meses[ld.getMonthValue()];
                            %>
                                <tr>
                                    <td><strong><%= fechaTexto %></strong><br>
                                        <span style="font-size:11px;color:var(--texto-suave);"><%= fecha %></span>
                                    </td>
                                    <td>
                                        <div class="cap-bar-wrap">
                                            <div class="cap-bar">
                                                <div class="cap-bar__fill <%= fillClass %>"
                                                     style="width:<%= Math.min(pct,100) %>%"></div>
                                            </div>
                                            <span class="cap-num"><%= confirmados %>/<%= limite %></span>
                                        </div>
                                    </td>
                                    <td><span class="<%= chip %>"><%= chipTxt %></span></td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/capacidad" method="POST"
                                              class="edit-limite">
                                            <input type="hidden" name="accion" value="limite">
                                            <input type="hidden" name="fecha"  value="<%= fecha %>">
                                            <input type="number" name="limite" value="<%= limite %>"
                                                   min="0" max="20" required>
                                            <button type="submit">OK</button>
                                        </form>
                                    </td>
                                </tr>
                            <% } } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <%-- PANEL LATERAL --%>
                <div>
                    <div class="panel-card">
                        <h3>Reglas actuales</h3>
                        <div class="regla-fila">
                            <span>Límite por defecto</span>
                            <strong>5</strong>
                        </div>
                        <div class="regla-fila">
                            <span>Días mostrados</span>
                            <strong>30</strong>
                        </div>
                        <div class="regla-fila">
                            <span>Fechas bloqueadas</span>
                            <strong><%= bloqueadas.size() %></strong>
                        </div>
                    </div>

                    <div class="panel-card">
                        <h3>Fechas bloqueadas</h3>
                        <% if (bloqueadas.isEmpty()) { %>
                            <p class="sin-bloqueos">✓ No hay fechas bloqueadas en los próximos 30 días.</p>
                        <% } else { %>
                            <div class="fechas-bloqueadas">
                                <% for (String f : bloqueadas) {
                                    java.time.LocalDate ld = java.time.LocalDate.parse(f);
                                    String[] meses = {"","Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic"};
                                %>
                                <span class="fecha-chip">
                                    <%= ld.getDayOfMonth() %> <%= meses[ld.getMonthValue()] %>
                                </span>
                                <% } %>
                            </div>
                        <% } %>
                    </div>

                    <div class="panel-card">
                        <h3>¿Cómo funciona?</h3>
                        <p style="font-size:13px;color:var(--texto-suave);line-height:20px;">
                            Cada fecha tiene un límite de pedidos que puedes confirmar ese día.
                            Cuando un pedido llega al estado <strong>Aceptado</strong>, se suma al contador.
                            Las fechas marcadas como <span class="chip-lleno">Lleno</span> no están disponibles
                            para nuevos pedidos. Puedes ajustar el límite de cualquier fecha en la tabla.
                        </p>
                    </div>
                </div>

            </div>
        </div>

        <%@ include file="/jsp/admin/footer-admin.jsp" %>
    </div>
</div>
</body>
</html>
