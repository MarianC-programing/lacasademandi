package controlador;

import dao.PedidoDAO;
import dao.ProductoDAO;
import modelo.Pedido;
import modelo.Variante;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;

/**
 * POST /pedido?accion=crear   — Guarda un pedido nuevo (cliente).
 * POST /pedido?accion=estado  — Cambia estado de un pedido (admin).
 * POST /pedido?accion=precio  — Confirma precio de un pedido (admin).
 * POST /pedido?accion=cancelar — Cancela pedido propio (cliente, solo si Pendiente).
 */
public class PedidoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");

        if ("crear".equals(accion)) {
            crearPedido(req, resp);
        } else if ("estado".equals(accion)) {
            cambiarEstado(req, resp);
        } else if ("precio".equals(accion)) {
            confirmarPrecio(req, resp);
        } else if ("cancelar".equals(accion)) {
            cancelarPedido(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/jsp/cliente/mis-pedidos.jsp");
        }
    }

    // ----------------------------------------------------------------
    private void crearPedido(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String rol = (String) req.getSession().getAttribute("rol");
        if (!"cliente".equals(rol)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int idCliente = (int) req.getSession().getAttribute("id_cliente");

        try {
            int    idVariante  = Integer.parseInt(req.getParameter("id_variante"));
            int    cantidad    = Integer.parseInt(req.getParameter("cantidad"));
            String fechaStr    = req.getParameter("fecha_entrega");
            String descripcion = req.getParameter("descripcion_diseno");

            if (fechaStr == null || fechaStr.isEmpty()) {
                req.setAttribute("error", "Debes seleccionar una fecha de entrega.");
                req.getRequestDispatcher("/jsp/cliente/nuevo-pedido.jsp").forward(req, resp);
                return;
            }

            ProductoDAO prodDAO = new ProductoDAO();
            Variante variante   = prodDAO.buscarVariantePorId(idVariante);

            if (variante == null) {
                req.setAttribute("error", "Variante no encontrada.");
                req.getRequestDispatcher("/jsp/cliente/nuevo-pedido.jsp").forward(req, resp);
                return;
            }

            BigDecimal precioUnitario = variante.getPrecioBase();
            BigDecimal precioTotal    = precioUnitario.multiply(BigDecimal.valueOf(cantidad));

            Pedido pedido = new Pedido();
            pedido.setIdCliente(idCliente);
            pedido.setFechaEntrega(Date.valueOf(fechaStr));
            pedido.setDescripcionDiseno(descripcion != null ? descripcion.trim() : "");
            pedido.setPrecioTotal(precioTotal);

            PedidoDAO dao = new PedidoDAO();
            int idPedido  = dao.crear(pedido, idVariante, cantidad, precioUnitario);

            resp.sendRedirect(req.getContextPath()
                + "/jsp/cliente/detalle-pedido.jsp?id=" + idPedido + "&nuevo=1");

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Datos del formulario inválidos.");
            req.getRequestDispatcher("/jsp/cliente/nuevo-pedido.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Error al guardar el pedido. Intenta de nuevo.");
            req.getRequestDispatcher("/jsp/cliente/nuevo-pedido.jsp").forward(req, resp);
        }
    }

    // ----------------------------------------------------------------
    private void cambiarEstado(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String rol = (String) req.getSession().getAttribute("rol");
        if (!"admin".equals(rol)) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

        try {
            int    idPedido    = Integer.parseInt(req.getParameter("id_pedido"));
            String nuevoEstado = req.getParameter("estado");
            new PedidoDAO().actualizarEstado(idPedido, nuevoEstado);
            resp.sendRedirect(req.getContextPath() + "/jsp/admin/pedidos.jsp?ok=1");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/jsp/admin/pedidos.jsp?error=1");
        }
    }

    // ----------------------------------------------------------------
    private void confirmarPrecio(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String rol = (String) req.getSession().getAttribute("rol");
        if (!"admin".equals(rol)) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

        try {
            int        idPedido = Integer.parseInt(req.getParameter("id_pedido"));
            BigDecimal precio   = new BigDecimal(req.getParameter("precio_total"));
            new PedidoDAO().confirmarPrecio(idPedido, precio);
            resp.sendRedirect(req.getContextPath() + "/jsp/admin/pedidos.jsp?ok=1");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/jsp/admin/pedidos.jsp?error=1");
        }
    }

    // ----------------------------------------------------------------
    private void cancelarPedido(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String rol = (String) req.getSession().getAttribute("rol");
        if (!"cliente".equals(rol)) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

        try {
            int    idPedido  = Integer.parseInt(req.getParameter("id_pedido"));
            Pedido pedido    = new PedidoDAO().buscarPorId(idPedido);
            int    idCliente = (int) req.getSession().getAttribute("id_cliente");

            // Solo puede cancelar si el pedido es suyo y está Pendiente
            if (pedido != null && pedido.getIdCliente() == idCliente
                    && "Pendiente".equals(pedido.getEstado())) {
                new PedidoDAO().actualizarEstado(idPedido, "Cancelado");
            }
            resp.sendRedirect(req.getContextPath() + "/jsp/cliente/mis-pedidos.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/jsp/cliente/mis-pedidos.jsp");
        }
    }
}
