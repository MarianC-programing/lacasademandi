package controlador;

import dao.ProductoDAO;
import modelo.Producto;
import modelo.Variante;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

/**
 * POST /producto?accion=crear         — Crear producto nuevo
 * POST /producto?accion=editar        — Editar producto existente
 * POST /producto?accion=toggle        — Activar/desactivar producto
 * POST /producto?accion=crear_variante — Agregar variante a producto
 * POST /producto?accion=editar_variante — Editar variante existente
 */
public class ProductoServlet extends HttpServlet {
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
            ProductoDAO dao = new ProductoDAO();

            switch (accion == null ? "" : accion) {

                case "crear": {
                    Producto p = new Producto();
                    p.setIdCategoria(Integer.parseInt(req.getParameter("id_categoria")));
                    p.setNombre(req.getParameter("nombre"));
                    p.setDescripcion(req.getParameter("descripcion"));
                    p.setImagen(req.getParameter("imagen"));
                    dao.crear(p);
                    resp.sendRedirect(ctx + "/jsp/admin/productos.jsp?ok=creado");
                    break;
                }

                case "editar": {
                    Producto p = new Producto();
                    p.setIdProducto(Integer.parseInt(req.getParameter("id_producto")));
                    p.setIdCategoria(Integer.parseInt(req.getParameter("id_categoria")));
                    p.setNombre(req.getParameter("nombre"));
                    p.setDescripcion(req.getParameter("descripcion"));
                    p.setImagen(req.getParameter("imagen"));
                    dao.actualizar(p);
                    resp.sendRedirect(ctx + "/jsp/admin/productos.jsp?ok=editado");
                    break;
                }

                case "toggle": {
                    int id          = Integer.parseInt(req.getParameter("id_producto"));
                    boolean activar = "true".equals(req.getParameter("disponible"));
                    dao.toggleDisponible(id, activar);
                    resp.sendRedirect(ctx + "/jsp/admin/productos.jsp?ok=toggle");
                    break;
                }

                case "crear_variante": {
                    Variante v = new Variante();
                    v.setIdProducto(Integer.parseInt(req.getParameter("id_producto")));
                    v.setTamano(req.getParameter("tamano"));
                    v.setPrecioBase(new BigDecimal(req.getParameter("precio_base")));
                    dao.crearVariante(v);
                    resp.sendRedirect(ctx + "/jsp/admin/productos.jsp?id=" + v.getIdProducto() + "&ok=variante");
                    break;
                }

                case "editar_variante": {
                    Variante v = new Variante();
                    v.setIdVariante(Integer.parseInt(req.getParameter("id_variante")));
                    v.setIdProducto(Integer.parseInt(req.getParameter("id_producto")));
                    v.setTamano(req.getParameter("tamano"));
                    v.setPrecioBase(new BigDecimal(req.getParameter("precio_base")));
                    v.setDisponible("true".equals(req.getParameter("disponible")));
                    dao.actualizarVariante(v);
                    resp.sendRedirect(ctx + "/jsp/admin/productos.jsp?id=" + v.getIdProducto() + "&ok=variante");
                    break;
                }

                default:
                    resp.sendRedirect(ctx + "/jsp/admin/productos.jsp");
            }

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            resp.sendRedirect(ctx + "/jsp/admin/productos.jsp?error=1");
        }
    }
}
