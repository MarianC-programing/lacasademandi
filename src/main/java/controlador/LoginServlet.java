package controlador;

import dao.AdministradorDAO;
import dao.ClienteDAO;
import modelo.Administrador;
import modelo.Cliente;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

/**
 * POST /login — Valida credenciales (correo o WhatsApp) contra Administrador y Cliente.
 * GET  /login — Reenvía al formulario en login.jsp.
 */
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String usuario    = req.getParameter("usuario");
        String contrasena = req.getParameter("contrasena");

        if (usuario == null || usuario.trim().isEmpty()
                || contrasena == null || contrasena.trim().isEmpty()) {
            mostrarError(req, resp, "Por favor completa todos los campos.", usuario);
            return;
        }

        usuario = usuario.trim();
        boolean esCorreo = usuario.contains("@");

        try {
            // 1. Buscar primero en Administrador (solo entran por correo)
            if (esCorreo) {
                AdministradorDAO adminDAO = new AdministradorDAO();
                Administrador admin = adminDAO.buscarPorCorreo(usuario);

                if (admin != null) {
                    if (BCrypt.checkpw(contrasena, admin.getPassword())) {
                        req.getSession().setAttribute("rol",      "admin");
                        req.getSession().setAttribute("id_admin", admin.getIdAdmin());
                        req.getSession().setAttribute("nombre",   admin.getNombre());
                        resp.sendRedirect(req.getContextPath() + "/jsp/admin/dashboard.jsp");
                        return;
                    } else {
                        mostrarError(req, resp, "Contraseña incorrecta.", usuario);
                        return;
                    }
                }
            }

            // 2. Buscar en Cliente (por correo o WhatsApp)
            ClienteDAO clienteDAO = new ClienteDAO();
            Cliente cliente = esCorreo
                ? clienteDAO.buscarPorCorreo(usuario)
                : clienteDAO.buscarPorWhatsapp(usuario);

            if (cliente == null) {
                mostrarError(req, resp, "No encontramos una cuenta con ese correo o WhatsApp.", usuario);
                return;
            }

            if (!BCrypt.checkpw(contrasena, cliente.getPassword())) {
                mostrarError(req, resp, "Contraseña incorrecta.", usuario);
                return;
            }

            req.getSession().setAttribute("rol",        "cliente");
            req.getSession().setAttribute("id_cliente", cliente.getIdCliente());
            req.getSession().setAttribute("nombre",     cliente.getNombre());
            resp.sendRedirect(req.getContextPath() + "/jsp/cliente/mis-pedidos.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            mostrarError(req, resp, "Error de conexión. Verifica que MySQL esté activo.", usuario);
        }
    }

    private void mostrarError(HttpServletRequest req, HttpServletResponse resp,
                               String mensaje, String usuario)
            throws ServletException, IOException {
        req.setAttribute("error", mensaje);
        req.setAttribute("usuario", usuario);
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
}
