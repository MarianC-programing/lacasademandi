package controlador;

import dao.ClienteDAO;
import modelo.Cliente;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /registro  — Registra un cliente nuevo y lo deja con sesión iniciada.
 * GET  /registro  — Muestra el formulario.
 */
public class RegistroServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/publico/registro.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String nombre    = trim(req.getParameter("nombre"));
        String correo    = trim(req.getParameter("correo"));
        String whatsapp  = trim(req.getParameter("whatsapp"));
        String telefono  = trim(req.getParameter("telefono"));
        String password  = req.getParameter("password");
        String password2 = req.getParameter("password2");

        String error = validar(nombre, correo, whatsapp, telefono, password, password2);

        if (error != null) {
            req.setAttribute("error",    error);
            req.setAttribute("nombre",   nombre);
            req.setAttribute("correo",   correo);
            req.setAttribute("whatsapp", whatsapp);
            req.setAttribute("telefono", telefono);
            req.getRequestDispatcher("/jsp/publico/registro.jsp").forward(req, resp);
            return;
        }

        try {
            ClienteDAO dao = new ClienteDAO();

            if (dao.existeCorreo(correo)) {
                req.setAttribute("error", "Ese correo electrónico ya está registrado.");
                req.setAttribute("nombre", nombre); req.setAttribute("whatsapp", whatsapp); req.setAttribute("telefono", telefono);
                req.getRequestDispatcher("/jsp/publico/registro.jsp").forward(req, resp);
                return;
            }
            if (dao.existeWhatsapp(whatsapp)) {
                req.setAttribute("error", "Ese número de WhatsApp ya está registrado.");
                req.setAttribute("nombre", nombre); req.setAttribute("correo", correo); req.setAttribute("telefono", telefono);
                req.getRequestDispatcher("/jsp/publico/registro.jsp").forward(req, resp);
                return;
            }

            String hash = BCrypt.hashpw(password, BCrypt.gensalt(12));

            Cliente c = new Cliente();
            c.setNombre(nombre);
            c.setCorreo(correo);
            c.setWhatsapp(whatsapp);
            c.setTelefono(telefono);
            c.setPassword(hash);

            int idCliente = dao.registrar(c);

            req.getSession().setAttribute("rol",        "cliente");
            req.getSession().setAttribute("id_cliente", idCliente);
            req.getSession().setAttribute("nombre",     nombre);

            resp.sendRedirect(req.getContextPath() + "/jsp/cliente/mis-pedidos.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Error al guardar el registro. Intenta de nuevo.");
            req.getRequestDispatcher("/jsp/publico/registro.jsp").forward(req, resp);
        }
    }

    private String validar(String nombre, String correo, String whatsapp,
                            String telefono, String password, String password2) {
        if (nombre.isEmpty() || correo.isEmpty() || whatsapp.isEmpty()
                || telefono.isEmpty() || password == null || password.isEmpty())
            return "Todos los campos son obligatorios.";
        if (!correo.contains("@"))
            return "Ingresa un correo electrónico válido.";
        if (password.length() < 6)
            return "La contraseña debe tener al menos 6 caracteres.";
        if (!password.equals(password2))
            return "Las contraseñas no coinciden.";
        return null;
    }

    private String trim(String s) { return s == null ? "" : s.trim(); }
}
