package controlador;

import dao.CapacidadDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /capacidad?accion=limite — Admin actualiza límite diario de una fecha
 */
public class CapacidadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String rol = (String) req.getSession(false).getAttribute("rol");
        if (!"admin".equals(rol)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }

        String accion = req.getParameter("accion");
        String ctx    = req.getContextPath();

        try {
            CapacidadDAO dao = new CapacidadDAO();

            if ("limite".equals(accion)) {
                String fecha  = req.getParameter("fecha");
                int    limite = Integer.parseInt(req.getParameter("limite"));
                dao.actualizarLimite(fecha, limite);
                resp.sendRedirect(ctx + "/jsp/admin/capacidad.jsp?ok=1");
            } else {
                resp.sendRedirect(ctx + "/jsp/admin/capacidad.jsp");
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            resp.sendRedirect(ctx + "/jsp/admin/capacidad.jsp?error=1");
        }
    }
}
