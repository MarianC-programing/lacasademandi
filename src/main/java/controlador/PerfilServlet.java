package controlador;

import dao.ClienteDAO;
import modelo.Cliente;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /perfil — Actualiza nombre, teléfono, WhatsApp y correo del cliente en sesión.
 */
public class PerfilServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String rol = (String) req.getSession().getAttribute("rol");
        if (!"cliente".equals(rol)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        int    idCliente = (int) req.getSession().getAttribute("id_cliente");
        String nombre    = trim(req.getParameter("nombre"));
        String correo    = trim(req.getParameter("correo"));
        String whatsapp  = trim(req.getParameter("whatsapp"));
        String telefono  = trim(req.getParameter("telefono"));

        if (nombre.isEmpty() || correo.isEmpty() || whatsapp.isEmpty() || telefono.isEmpty()) {
            req.setAttribute("error", "Todos los campos son obligatorios.");
            req.getRequestDispatcher("/jsp/cliente/mi-perfil.jsp").forward(req, resp);
            return;
        }

        try {
            ClienteDAO dao = new ClienteDAO();

            // Verificar que el correo no lo use otro cliente
            Cliente existeCorreo = dao.buscarPorCorreo(correo);
            if (existeCorreo != null && existeCorreo.getIdCliente() != idCliente) {
                req.setAttribute("error", "Ese correo ya lo usa otra cuenta.");
                req.getRequestDispatcher("/jsp/cliente/mi-perfil.jsp").forward(req, resp);
                return;
            }

            Cliente c = new Cliente();
            c.setIdCliente(idCliente);
            c.setNombre(nombre);
            c.setCorreo(correo);
            c.setWhatsapp(whatsapp);
            c.setTelefono(telefono);
            dao.actualizar(c);

            // Actualizar nombre en sesión
            req.getSession().setAttribute("nombre", nombre);

            resp.sendRedirect(req.getContextPath() + "/jsp/cliente/mi-perfil.jsp?ok=1");

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Error al guardar los cambios. Intenta de nuevo.");
            req.getRequestDispatcher("/jsp/cliente/mi-perfil.jsp").forward(req, resp);
        }
    }

    private String trim(String s) { return s == null ? "" : s.trim(); }
}
