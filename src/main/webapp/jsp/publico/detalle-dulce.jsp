<%-- Compatibilidad: redirige al detalle real de producto --%>
<%
    String id = request.getParameter("id");
    String destino = request.getContextPath() + "/jsp/publico/detalle-producto.jsp"
        + (id != null ? "?id=" + id : "");
    response.sendRedirect(destino);
%>
