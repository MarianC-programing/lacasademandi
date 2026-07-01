package controlador;

import dao.PagoDAO;
import dao.PedidoDAO;
import modelo.Abono;
import modelo.PagoFinal;
import modelo.Pedido;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;

/**
 * POST /pago?accion=abono        — Cliente registra su abono
 * POST /pago?accion=pago_final   — Cliente registra su pago final
 * POST /pago?accion=conf_abono   — Admin confirma el abono
 * POST /pago?accion=rech_abono   — Admin rechaza el abono
 * POST /pago?accion=conf_final   — Admin confirma el pago final
 * POST /pago?accion=rech_final   — Admin rechaza el pago final
 */
public class PagoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

        String rol    = (String) session.getAttribute("rol");
        String accion = req.getParameter("accion");
        String ctx    = req.getContextPath();

        try {
            PagoDAO  pagoDAO  = new PagoDAO();
            PedidoDAO pedidoDAO = new PedidoDAO();
            int idPedido = Integer.parseInt(req.getParameter("id_pedido"));

            switch (accion == null ? "" : accion) {

                // ── CLIENTE: registrar abono ──────────────────────────────
                case "abono": {
                    if (!"cliente".equals(rol)) { resp.sendRedirect(ctx + "/login.jsp"); return; }
                    int idCliente = (int) session.getAttribute("id_cliente");

                    // Verificar que el pedido pertenece al cliente
                    Pedido p = pedidoDAO.buscarPorId(idPedido);
                    if (p == null || p.getIdCliente() != idCliente) {
                        resp.sendRedirect(ctx + "/jsp/cliente/mis-pedidos.jsp?error=acceso"); return;
                    }
                    // No registrar si ya hay uno
                    if (pagoDAO.buscarAbonoPorPedido(idPedido) != null) {
                        resp.sendRedirect(ctx + "/jsp/cliente/detalle-pedido.jsp?id=" + idPedido + "&error=abono_duplicado"); return;
                    }

                    Abono a = new Abono();
                    a.setIdPedido(idPedido);
                    a.setMonto(new BigDecimal(req.getParameter("monto")));
                    a.setPorcentaje(new BigDecimal(req.getParameter("porcentaje")));
                    a.setFechaPago(Date.valueOf(req.getParameter("fecha_pago")));
                    a.setMetodoPago(req.getParameter("metodo_pago"));
                    a.setReferencia(req.getParameter("referencia"));
                    pagoDAO.registrarAbono(a);

                    resp.sendRedirect(ctx + "/jsp/cliente/detalle-pedido.jsp?id=" + idPedido + "&ok=abono");
                    break;
                }

                // ── CLIENTE: registrar pago final ─────────────────────────
                case "pago_final": {
                    if (!"cliente".equals(rol)) { resp.sendRedirect(ctx + "/login.jsp"); return; }
                    int idCliente = (int) session.getAttribute("id_cliente");

                    Pedido p = pedidoDAO.buscarPorId(idPedido);
                    if (p == null || p.getIdCliente() != idCliente) {
                        resp.sendRedirect(ctx + "/jsp/cliente/mis-pedidos.jsp?error=acceso"); return;
                    }
                    if (pagoDAO.buscarPagoFinalPorPedido(idPedido) != null) {
                        resp.sendRedirect(ctx + "/jsp/cliente/detalle-pedido.jsp?id=" + idPedido + "&error=pago_duplicado"); return;
                    }

                    PagoFinal pf = new PagoFinal();
                    pf.setIdPedido(idPedido);
                    pf.setMonto(new BigDecimal(req.getParameter("monto")));
                    pf.setFechaPago(Date.valueOf(req.getParameter("fecha_pago")));
                    pf.setMetodoPago(req.getParameter("metodo_pago"));
                    pf.setReferencia(req.getParameter("referencia"));
                    pagoDAO.registrarPagoFinal(pf);

                    resp.sendRedirect(ctx + "/jsp/cliente/detalle-pedido.jsp?id=" + idPedido + "&ok=pago_final");
                    break;
                }

                // ── ADMIN: confirmar abono ────────────────────────────────
                case "conf_abono": {
                    if (!"admin".equals(rol)) { resp.sendRedirect(ctx + "/login.jsp"); return; }
                    pagoDAO.confirmarAbono(idPedido);
                    // Cambiar estado del pedido a "Aceptado"
                    pedidoDAO.actualizarEstado(idPedido, "Aceptado");
                    resp.sendRedirect(ctx + "/jsp/admin/pedidos.jsp?id=" + idPedido + "&ok=1");
                    break;
                }

                // ── ADMIN: rechazar abono ─────────────────────────────────
                case "rech_abono": {
                    if (!"admin".equals(rol)) { resp.sendRedirect(ctx + "/login.jsp"); return; }
                    pagoDAO.rechazarAbono(idPedido);
                    resp.sendRedirect(ctx + "/jsp/admin/pedidos.jsp?id=" + idPedido + "&ok=1");
                    break;
                }

                // ── ADMIN: confirmar pago final ───────────────────────────
                case "conf_final": {
                    if (!"admin".equals(rol)) { resp.sendRedirect(ctx + "/login.jsp"); return; }
                    pagoDAO.confirmarPagoFinal(idPedido); // también pone estado = Listo
                    resp.sendRedirect(ctx + "/jsp/admin/pedidos.jsp?id=" + idPedido + "&ok=1");
                    break;
                }

                // ── ADMIN: rechazar pago final ────────────────────────────
                case "rech_final": {
                    if (!"admin".equals(rol)) { resp.sendRedirect(ctx + "/login.jsp"); return; }
                    pagoDAO.rechazarPagoFinal(idPedido);
                    resp.sendRedirect(ctx + "/jsp/admin/pedidos.jsp?id=" + idPedido + "&ok=1");
                    break;
                }

                default:
                    resp.sendRedirect(ctx + "/index.jsp");
            }

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/jsp/cliente/mis-pedidos.jsp?error=1");
        }
    }
}
