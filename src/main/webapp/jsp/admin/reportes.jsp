<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, dao.ReporteDAO" %>
<%
    String rol = (String) session.getAttribute("rol");
    if (!"admin".equals(rol)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }

    ReporteDAO dao = new ReporteDAO();

    java.math.BigDecimal totalIngresos  = dao.totalIngresos();
    java.math.BigDecimal ingresosMes    = dao.ingresosMesActual();
    int totalClientes                   = dao.totalClientes();
    int totalPedidos                    = dao.totalPedidos();
    List<String[]> porEstado            = dao.pedidosPorEstado();
    List<String[]> topProductos         = dao.topProductos();
    List<String[]> ingresosMeses        = dao.ingresosPorMes();
    List<String[]> metodosPago          = dao.metodosPago();

    // Calcular max para barras relativas
    int maxPedidosProd = 1;
    for (String[] p : topProductos) {
        int v = Integer.parseInt(p[1]);
        if (v > maxPedidosProd) maxPedidosProd = v;
    }
    double maxIngMes = 1;
    for (String[] m : ingresosMeses) {
        double v = Double.parseDouble(m[1]);
        if (v > maxIngMes) maxIngMes = v;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes — La Casa de Mandi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <style>
        .rep-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-bottom: 24px;
        }
        .rep-grid-3 {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
            margin-bottom: 24px;
        }
        .rep-card {
            background: #fff;
            border: 1px solid var(--borde);
            border-radius: 14px;
            padding: 22px;
        }
        .rep-card h3 {
            font-family: var(--titulo); font-size: 16px; font-weight: 700;
            margin-bottom: 18px; color: var(--texto);
        }

        /* KPI Cards */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }
        .kpi-card {
            background: #fff; border: 1px solid var(--borde);
            border-radius: 14px; padding: 20px;
        }
        .kpi-card .kpi-label {
            font-size: 11px; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.08em; color: var(--texto-suave); margin-bottom: 8px;
        }
        .kpi-card .kpi-valor {
            font-family: var(--titulo); font-size: 32px; font-weight: 700;
            color: var(--primario); line-height: 1;
        }
        .kpi-card .kpi-sub {
            font-size: 12px; color: var(--texto-suave); margin-top: 4px;
        }

        /* Barras horizontales */
        .barra-fila {
            display: flex; align-items: center; gap: 12px;
            padding: 8px 0; border-bottom: 1px solid var(--borde); font-size: 13px;
        }
        .barra-fila:last-child { border-bottom: none; }
        .barra-label { width: 160px; flex-shrink: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; font-weight: 500; }
        .barra-wrap  { flex: 1; height: 10px; background: var(--fondo-alt); border-radius: 999px; overflow: hidden; }
        .barra-fill  { height: 100%; border-radius: 999px; background: var(--primario); }
        .barra-val   { width: 56px; text-align: right; flex-shrink: 0; font-weight: 700; color: var(--primario); }

        /* Barras verticales (ingresos por mes) */
        .chart-wrap {
            display: flex; align-items: flex-end; gap: 10px;
            height: 160px; padding-top: 8px;
        }
        .chart-col {
            flex: 1; display: flex; flex-direction: column;
            align-items: center; gap: 6px;
        }
        .chart-bar-outer {
            width: 100%; background: var(--fondo-alt);
            border-radius: 4px 4px 0 0;
            display: flex; align-items: flex-end;
            height: 120px;
        }
        .chart-bar-inner {
            width: 100%; background: var(--primario);
            border-radius: 4px 4px 0 0; transition: height 0.3s;
        }
        .chart-mes   { font-size: 10px; color: var(--texto-suave); text-align: center; }
        .chart-valor { font-size: 10px; font-weight: 700; color: var(--primario); text-align: center; }

        /* Estado donut (tabla) */
        .estado-fila {
            display: flex; justify-content: space-between; align-items: center;
            padding: 9px 0; border-bottom: 1px solid var(--borde); font-size: 13px;
        }
        .estado-fila:last-child { border-bottom: none; }
        .estado-count { font-weight: 700; font-size: 18px; }

        /* Métodos de pago */
        .metodo-fila {
            display: flex; justify-content: space-between; align-items: center;
            padding: 10px 0; border-bottom: 1px solid var(--borde); font-size: 14px;
        }
        .metodo-fila:last-child { border-bottom: none; }
        .metodo-chip {
            display: inline-block; padding: 3px 12px; border-radius: 999px;
            font-size: 12px; font-weight: 700;
            background: var(--fondo-alt); color: var(--texto);
        }
    </style>
</head>
<body>
<div class="admin-layout">

    <% request.setAttribute("seccionActiva", "reportes"); %>
    <%@ include file="/jsp/admin/sidebar.jsp" %>

    <div class="admin-main">
        <div class="admin-content">

            <div class="admin-content-header">
                <div>
                    <h1>Reportes</h1>
                    <p>Resumen de ingresos, pedidos y productos más solicitados.</p>
                </div>
                <span style="font-size:12px;color:var(--texto-suave);">
                    Generado el <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(new java.util.Date()) %>
                </span>
            </div>

            <%-- KPIs --%>
            <div class="kpi-grid">
                <div class="kpi-card">
                    <div class="kpi-label">Ingresos totales</div>
                    <div class="kpi-valor">$<%= String.format("%.0f", totalIngresos) %></div>
                    <div class="kpi-sub">Abonos + pagos finales confirmados</div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-label">Ingresos este mes</div>
                    <div class="kpi-valor">$<%= String.format("%.0f", ingresosMes) %></div>
                    <div class="kpi-sub">Mes actual</div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-label">Total pedidos</div>
                    <div class="kpi-valor"><%= totalPedidos %></div>
                    <div class="kpi-sub">Todos los estados</div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-label">Clientes registrados</div>
                    <div class="kpi-valor"><%= totalClientes %></div>
                    <div class="kpi-sub">En la plataforma</div>
                </div>
            </div>

            <%-- FILA 1: Top productos + Ingresos por mes --%>
            <div class="rep-grid">

                <div class="rep-card">
                    <h3>Top 5 productos más solicitados</h3>
                    <% if (topProductos.isEmpty()) { %>
                        <p style="color:var(--texto-suave);font-size:13px;">No hay datos aún.</p>
                    <% } else {
                        for (String[] p : topProductos) {
                            int pct = (int)(Integer.parseInt(p[1]) * 100.0 / maxPedidosProd);
                    %>
                        <div class="barra-fila">
                            <span class="barra-label" title="<%= p[0] %>"><%= p[0] %></span>
                            <div class="barra-wrap">
                                <div class="barra-fill" style="width:<%= pct %>%"></div>
                            </div>
                            <span class="barra-val"><%= p[1] %></span>
                        </div>
                    <% } } %>
                </div>

                <div class="rep-card">
                    <h3>Ingresos por mes (últimos 6 meses)</h3>
                    <% if (ingresosMeses.isEmpty()) { %>
                        <p style="color:var(--texto-suave);font-size:13px;">No hay datos de ingresos aún.</p>
                    <% } else { %>
                    <div class="chart-wrap">
                        <% for (String[] m : ingresosMeses) {
                            double val = Double.parseDouble(m[1]);
                            int pct = (int)(val * 100 / maxIngMes);
                            String mes = m[0].length() >= 7 ? m[0].substring(5) : m[0];
                        %>
                        <div class="chart-col">
                            <span class="chart-valor">$<%= String.format("%.0f", val) %></span>
                            <div class="chart-bar-outer">
                                <div class="chart-bar-inner" style="height:<%= pct %>%;"></div>
                            </div>
                            <span class="chart-mes"><%= mes %></span>
                        </div>
                        <% } %>
                    </div>
                    <% } %>
                </div>

            </div>

            <%-- FILA 2: Pedidos por estado + Métodos de pago + Ingresos detalle --%>
            <div class="rep-grid-3">

                <div class="rep-card">
                    <h3>Pedidos por estado</h3>
                    <% if (porEstado.isEmpty()) { %>
                        <p style="color:var(--texto-suave);font-size:13px;">No hay pedidos aún.</p>
                    <% } else {
                        for (String[] e : porEstado) {
                            String bc = badgeClase(e[0]);
                    %>
                        <div class="estado-fila">
                            <span class="badge <%= bc %>"><%= e[0] %></span>
                            <span class="estado-count"><%= e[1] %></span>
                        </div>
                    <% } } %>
                </div>

                <div class="rep-card">
                    <h3>Métodos de pago</h3>
                    <% if (metodosPago.isEmpty()) { %>
                        <p style="color:var(--texto-suave);font-size:13px;">No hay pagos confirmados aún.</p>
                    <% } else {
                        for (String[] mp : metodosPago) {
                    %>
                        <div class="metodo-fila">
                            <span class="metodo-chip"><%= mp[0] %></span>
                            <strong><%= mp[1] %> pagos</strong>
                        </div>
                    <% } } %>
                </div>

                <div class="rep-card">
                    <h3>Desglose de ingresos</h3>
                    <%
                        java.math.BigDecimal abonos = new dao.PagoDAO().totalAbonosConfirmados();
                        java.math.BigDecimal pagosF = new dao.PagoDAO().totalPagosFinalesConfirmados();
                        java.math.BigDecimal pendiente = new dao.PagoDAO().totalPendienteCobro();
                    %>
                    <div class="metodo-fila">
                        <span>Abonos confirmados</span>
                        <strong style="color:var(--primario);">$<%= String.format("%.2f", abonos) %></strong>
                    </div>
                    <div class="metodo-fila">
                        <span>Pagos finales confirmados</span>
                        <strong style="color:#16a34a;">$<%= String.format("%.2f", pagosF) %></strong>
                    </div>
                    <div class="metodo-fila" style="border-bottom:none;">
                        <span>Pendiente de cobro</span>
                        <strong style="color:#d97706;">$<%= String.format("%.2f", pendiente) %></strong>
                    </div>
                </div>

            </div>

        </div>
        <%@ include file="/jsp/admin/footer-admin.jsp" %>
    </div>
</div>

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
